import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../data/response_models/cart/cart_items_model.dart';
import '../../repositories/cart/cart_repository.dart';

class CartController extends GetxController {
  CartRepository cartRepository = CartRepository();
  ScrollController scrollController = ScrollController();

  //Obserables
  RxInt totalPrice = 0.obs;
  RxInt totalSlot = 0.obs;
  RxBool isLoading = false.obs;
  List<CartItems> cartItems = <CartItems>[];

  @override
  void onInit() {
    getCartItems();
    super.onInit();
  }

  //Functions
  Future<void> getCartItems() async {
    try {
      isLoading.value = true;
      CartItemsModel result = await cartRepository.getCartItems();

      if (result.cartItems!.isNotEmpty) {
        cartItems.assignAll(result.cartItems!);
      }
      log("Cart Items length: ${cartItems.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
