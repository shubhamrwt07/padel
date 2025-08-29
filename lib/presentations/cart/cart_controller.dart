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
  RxBool isLoading = false.obs;
  RxBool isBooking = false.obs;
  RxList<CartItems> cartItems = <CartItems>[].obs;

  // Selection tracking (club-level)
  RxSet<String> selectedClubIds = <String>{}.obs;

  // Computed totals (only selected clubs)
  RxInt totalPrice = 0.obs;
  RxInt totalSlot = 0.obs;

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
        // By default select all clubs
        selectedClubIds.value = cartItems
            .map((e) => e.registerClubId?.sId ?? "")
            .where((id) => id.isNotEmpty)
            .toSet();

        calculateTotals();
      } else {
        cartItems.clear();
        selectedClubIds.clear();
        totalPrice.value = 0;
        totalSlot.value = 0;
      }

      log("Cart Items length: ${cartItems.length}");
    } catch (e) {
      if (kDebugMode) print("Error fetching cart items: $e");
      cartItems.clear();
      selectedClubIds.clear();
      totalPrice.value = 0;
      totalSlot.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  // Recalculate totals based on selected clubs
  void calculateTotals() {
    int price = 0;
    int slots = 0;

    for (var item in cartItems) {
      final clubId = item.registerClubId?.sId ?? "";
      if (!selectedClubIds.contains(clubId)) continue;

      if (item.slot != null && item.slot!.isNotEmpty) {
        for (var slot in item.slot!) {
          if (slot.slotTimes != null) {
            slots += slot.slotTimes!.length;
            for (var slotTime in slot.slotTimes!) {
              price += int.tryParse(slotTime.amount?.toString() ?? "0") ?? 0;
            }
          }
        }
      }
    }

    totalPrice.value = price;
    totalSlot.value = slots;
  }


  // Toggle single club selection
  void toggleSelectClub(String clubId) {
    if (selectedClubIds.contains(clubId)) {
      selectedClubIds.remove(clubId);
    } else {
      selectedClubIds.add(clubId);
    }
    calculateTotals();
  }

  // Select all clubs
  void selectAll() {
    selectedClubIds.value = cartItems
        .map((e) => e.registerClubId?.sId ?? "")
        .where((id) => id.isNotEmpty)
        .toSet();
    calculateTotals();
  }

  // Unselect all clubs
  void unselectAll() {
    selectedClubIds.clear();
    calculateTotals();
  }

  // Delete only selected clubs
  Future<void> deleteSelectedClubs() async {
    final toDeleteIds = selectedClubIds.toSet();

    final slotIds = <String>[];
    for (var item in cartItems) {
      if (toDeleteIds.contains(item.registerClubId?.sId ?? "")) {
        for (var slot in item.slot ?? []) {
          for (var slotTime in slot.slotTimes ?? []) {
            if (slotTime.slotId != null) slotIds.add(slotTime.slotId!);
          }
        }
      }
    }

    if (slotIds.isNotEmpty) {
      await removeCartItemsFromCart(slotIds: slotIds);
    }
  }


  // Remove cart items (batch slotIds supported)
  Future<void> removeCartItemsFromCart({required List<String> slotIds}) async {
    try {
      log("slots ids for remove $slotIds");
      if (isLoading.value) return;

      isLoading.value = true;

      // Call API
      RemoveToCartModel result = await cartRepository.removeCartItems(slotIds: slotIds);

      // Refresh cart only from API
      await getCartItems();

      // Update total price from API
      if (result.newTotalAmount != null) {
        totalPrice.value = result.newTotalAmount!;
      }

      Get.snackbar(
        "Success",
        result.message ?? "Selected items removed from cart.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      log("Items removed successfully");
    } catch (e) {
      log("Remove cart error: $e");
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
      calculateTotals();
    }
  }

  // Helper to remove slot from local cart

  // Book Cart
  Future<void> bookCart({required List<Map<String, dynamic>> data}) async {
    try {
      isBooking.value = true;

      CarteBookingModel bookingResult =
      await cartRepository.booking(data: data); // send list directly ✅

      log("Booking successful: ${bookingResult.toJson()}");
      Get.toNamed(RoutesName.paymentMethod);
      Get.snackbar(
        "Success",
        "Booking completed successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

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
extension CartControllerBooking on CartController {
  List<Map<String, dynamic>>? buildBookingPayload() {
    final selectedItems = cartItems
        .where((c) => selectedClubIds.contains(c.registerClubId?.sId ?? ""))
        .toList();

    if (selectedItems.isEmpty) return null;

    final List<Map<String, dynamic>> payloadList = [];

    for (var cart in selectedItems) {
      final List<Map<String, dynamic>> slotData = [];

      for (var slot in cart.slot ?? []) {
        for (var slotTime in slot.slotTimes ?? []) {
          // Parse bookingDate
          DateTime? bookingDate = slotTime.bookingDate != null &&
              slotTime.bookingDate!.isNotEmpty
              ? DateTime.tryParse(slotTime.bookingDate!)
              : null;

          String bookingDay = "";
          if (bookingDate != null) {
            switch (bookingDate.weekday) {
              case 1:
                bookingDay = "Monday";
                break;
              case 2:
                bookingDay = "Tuesday";
                break;
              case 3:
                bookingDay = "Wednesday";
                break;
              case 4:
                bookingDay = "Thursday";
                break;
              case 5:
                bookingDay = "Friday";
                break;
              case 6:
                bookingDay = "Saturday";
                break;
              case 7:
                bookingDay = "Sunday";
                break;
            }
          }

          // Only business hours of that day
          final selectedBusinessHour = cart.registerClubId?.businessHours
              ?.where((bh) => bh.day == bookingDay)
              .map((bh) => {
            "time": bh.time ?? "",
            "day": bh.day ?? "",
          })
              .toList() ??
              [];

          slotData.add({
            "slotId": slotTime.slotId ?? "",
            "businessHours": selectedBusinessHour,
            "slotTimes": [
              {
                "time": slotTime.time ?? "",
                "amount": slotTime.amount ?? 0,
              }
            ],
            "courtId": slotTime.courtId,
            "courtName": slotTime.courtName,
            "bookingDate": slotTime.bookingDate ?? "",
          });
        }
      }

      if (slotData.isNotEmpty) {
        final bookingPayload = {
          "slot": slotData,
          "register_club_id": cart.registerClubId?.sId ?? "",
          "ownerId": cart.registerClubId?.ownerId ?? "",
        };

        payloadList.add(bookingPayload);
      }
    }

    return payloadList.isEmpty ? null : payloadList;
  }
}
