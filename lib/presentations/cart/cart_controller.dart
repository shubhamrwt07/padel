import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../data/response_models/cart/cart_items_model.dart';
import '../../data/response_models/cart/carte_booking_model.dart';
import '../../repositories/cart/cart_repository.dart';

class CartController extends GetxController {
  final CartRepository cartRepository = CartRepository();
  final ScrollController scrollController = ScrollController();

  // Observables
  RxInt totalPrice = 0.obs;
  RxInt totalSlot = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isBooking = false.obs;
  RxList<CartItems> cartItems = <CartItems>[].obs;

  @override
  void onInit() {
    getCartItems();
    super.onInit();
  }

  // Fetch Cart Items
  Future<void> getCartItems() async {
    try {
      isLoading.value = true;
      CartItemsModel result = await cartRepository.getCartItems();
      if (result.cartItems != null && result.cartItems!.isNotEmpty) {
        cartItems.assignAll(result.cartItems!);
      }
      log("Cart Items length: ${cartItems.length}");
    } catch (e) {
      if (kDebugMode) print("Error fetching cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Remove cart items
  Future<void> removeCartItemsFromCart({required List<String> slotIds}) async {
    try {
      log("slots ids for remove ${slotIds[0]}");
      if (isLoading.value) return;
      isLoading.value = true;

      await cartRepository.removeCartItems(slotIds: slotIds);

      await getCartItems();

      Get.snackbar(
        "Success",
        "Selected items removed from cart.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      log("message 2");
    } catch (e) {
      log("Remove cart error: $e");
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

  // Book Cart (calls repository.booking)
  Future<void> bookCart({required Map<String, dynamic> data}) async {
    try {
      isBooking.value = true;

      CarteBookingModel bookingResult = await cartRepository.booking(
        data: data,
      );

      // ✅ Do something with bookingResult if needed
      log("Booking successful: ${bookingResult.toJson()}");

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
