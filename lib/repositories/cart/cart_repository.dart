import 'dart:convert';
import 'dart:developer';

import 'package:padel_mobile/data/response_models/cart/add_to_cart_items_model.dart';
import 'package:padel_mobile/data/response_models/cart/cart_items_model.dart';

import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
import '../../data/request_models/authentication_models/reset_password.model.dart';
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
      log("Sending slotIds to delete: $slotIds");

      final response = await dioClient.delete(
        AppEndpoints.removeCartItems,
        data: {"slotIds": slotIds},
      );

      log("Delete response status: ${response.statusCode}");
      log("Delete response data: ${response.data}");

      if (response.statusCode == 200) {
        return RemoveToCartModel.fromJson(response.data);
      } else {
        throw Exception("Failed to remove cart items");
      }
    } catch (e, st) {
      CustomLogger.logMessage(
        msg: "Remove cart items failed: $e",
        level: LogLevel.error,
        st: st,
      );
      rethrow;
    }
  }  Future<AddToCartModel> addCartItems({
    required Map<String, dynamic> data,
  }) async {
    log("POST API -${AppEndpoints.addCartItems} body ${data.toString()}");
    try {
      final response = await dioClient.post(
        AppEndpoints.addCartItems,
        data: data,
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
        data: data,
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
