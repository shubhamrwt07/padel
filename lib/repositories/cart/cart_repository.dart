import 'dart:convert';
import 'dart:developer';

import 'package:padel_mobile/data/response_models/cart/add_to_cart_items_model.dart';
import 'package:padel_mobile/data/response_models/cart/cart_items_model.dart';

import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/response_models/cart/carte_booking_model.dart';
import '../../data/response_models/cart/romove_cart_product_model.dart';
import '../../handler/logger.dart';

class CartRepository {
  static final CartRepository _instance = CartRepository._internal();
  final DioClient dioClient = DioClient();

  factory CartRepository() {
    return _instance;
  }

  CartRepository._internal();

  Future<CartItemsModel> getCartItems() async {
    try {
      final response = await dioClient.get(AppEndpoints.getCartItems);

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Cart items fetched successful: ${response.data}",
          level: LogLevel.info,
        );
        return CartItemsModel.fromJson(response.data);
      } else if(response.statusCode == 404) {
        return CartItemsModel.fromJson(response.data);

      }else{
        throw Exception("Error");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Cart items failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
  Future<RemoveToCartModel> removeCartItems({required List<String> slotIds}) async {
    try {
      log("data remove 2");
      final response = await dioClient.delete(
        AppEndpoints.removeCartItems,
        data: {
          "slotIds": slotIds,
        },
      );
      log("data remove 5");
      if (response.statusCode == 200) {
        log("data remove 25");
        CustomLogger.logMessage(
          msg: "Cart items removed successfully: ${response.data}",
          level: LogLevel.info,
        );

        return RemoveToCartModel.fromJson(response.data);
      } else {
        log("data error 25");
        throw Exception("Remove cart items failed with status code: ${response.statusCode}");
      }
    } catch (e, st) {
      log("data remove 250");
      CustomLogger.logMessage(
        msg: "Remove cart items failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
  Future<AddToCartModel> addCartItems({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dioClient.post(
        AppEndpoints.addCartItems,
        data: data, // ✅ This was missing
      );

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Cart item added successfully: ${response.data}",
          level: LogLevel.info,
        );

        return AddToCartModel.fromJson(response.data);
      } else {
        throw Exception("Add cart item failed with status code: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Add cart item failed with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }
  Future<CarteBookingModel> booking({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await dioClient.post(
        AppEndpoints.carteBooking,
        data: data, // ✅ This was missing
      );

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Cart item added successfully: ${response.data}",
          level: LogLevel.info,
        );

        return CarteBookingModel.fromJson(response.data);
      } else {
        throw Exception("Payment Failed status code: ${response.statusCode}");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Payment Failed  with error: ${e.toString()}",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }

}
