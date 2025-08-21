import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/routes/routes_name.dart';

import '../../data/response_models/cart/cart_items_model.dart';
import '../../data/response_models/cart/carte_booking_model.dart';
import '../../data/response_models/cart/romove_cart_product_model.dart';
import '../../repositories/cart/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository cartRepository = CartRepository();
  final ScrollController scrollController = ScrollController();
  RxBool isBookingLoading = false.obs;

  // Observables
  RxInt totalPrice = 0.obs;
  RxInt totalSlot = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isBooking = false.obs;
  RxList<CartItems> cartItems = <CartItems>[].obs;

  @override
  void onInit() {
    getCartItems();
    print("initialize");
    super.onInit();
  }

  // Fetch Cart Items
  Future<void> getCartItems() async {
    try {
      isLoading.value = true;
      CartItemsModel result = await cartRepository.getCartItems();

      if (result.cartItems != null && result.cartItems!.isNotEmpty) {
        cartItems.assignAll(result.cartItems!);
        totalPrice.value = result.grandTotal ?? 0;
        // Calculate total slots
        calculateTotalSlots();
      } else {
        // Explicitly clear cart when no items
        cartItems.clear();
        totalPrice.value = 0;
        totalSlot.value = 0;
      }

      log("Cart Items length: ${cartItems.length}");
    } catch (e) {
      if (kDebugMode) print("Error fetching cart items: $e");
      // Clear cart on error to avoid showing stale data
      cartItems.clear();
      totalPrice.value = 0;
      totalSlot.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  // Calculate total slots from cart items
  void calculateTotalSlots() {
    int slots = 0;
    for (var item in cartItems) {
      if (item.slot != null && item.slot!.isNotEmpty) {
        for (var slot in item.slot!) {
          if (slot.slotTimes != null) {
            slots += slot.slotTimes!.length;
          }
        }
      }
    }
    totalSlot.value = slots;
  }
  // Remove cart items with immediate UI update
  Future<void> removeCartItemsFromCart({required List<String> slotIds}) async {
    try {
      log("slots ids for remove ${slotIds[0]}");
      if (isLoading.value) return;

      // First, optimistically update UI by removing the item locally
      _removeSlotFromLocalCart(slotIds[0]);

      isLoading.value = true;

      RemoveToCartModel result = await cartRepository.removeCartItems(slotIds: slotIds);

      // Update the total amount from the API response
      if (result.newTotalAmount != null) {
        totalPrice.value = result.newTotalAmount!;
      }

      // Refresh cart items to ensure data consistency with server
      await getCartItems();

      Get.snackbar(
        "Success",
        result.message ?? "Selected items removed from cart.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      log("Item removed successfully");
    } catch (e) {
      log("Remove cart error: $e");
      // On error, refresh cart to restore correct state
      await getCartItems();

      Get.snackbar(
        "Error",
        "Failed to remove items: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to remove slot from local cart immediately
  void _removeSlotFromLocalCart(String slotId) {
    for (int i = 0; i < cartItems.length; i++) {
      var item = cartItems[i];
      if (item.slot != null) {
        for (int j = 0; j < item.slot!.length; j++) {
          var slot = item.slot![j];
          if (slot.slotTimes != null) {
            // Remove the specific slot time
            slot.slotTimes!.removeWhere((slotTime) => slotTime.slotId == slotId);

            // If no slot times left in this slot, remove the slot
            if (slot.slotTimes!.isEmpty) {
              item.slot!.removeAt(j);
              j--; // Adjust index after removal
            }
          }
        }

        // If no slots left in this item, remove the entire item
        if (item.slot!.isEmpty) {
          cartItems.removeAt(i);
          i--; // Adjust index after removal
        }
      }
    }

    // Recalculate totals
    calculateTotalSlots();
    if (cartItems.isEmpty) {
      totalPrice.value = 0;
      totalSlot.value = 0;
    }
  }

  // Book Cart (calls repository.booking)
  Future<void> bookCart({required Map<String, dynamic> data}) async {
    try {
      isBooking.value = true;

      CarteBookingModel bookingResult = await cartRepository.booking(
        data: data,
      );
      log("Booking successful: ${bookingResult.toJson()}");
      Get.toNamed(RoutesName.paymentMethod);
      Get.snackbar(
        "Success",
        "Booking completed successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Optionally refresh cart items
      await getCartItems();
    } catch (e) {
      log("Booking error: $e");
      Get.snackbar(
        "Error",
        "Booking failed: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isBooking.value = false;
    }
  }
}