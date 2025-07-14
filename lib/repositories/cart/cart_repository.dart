import 'dart:convert';

import 'package:padel_mobile/data/response_models/cart/add_to_cart_items_model.dart';
import 'package:padel_mobile/data/response_models/cart/cart_items_model.dart';

import '../../core/endpoitns.dart';
import '../../core/network/dio_client.dart';
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
      } else {
        throw Exception(
          "Cart items failed with status code: ${response.statusCode}",
        );
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
  Future<AddToCartModel> addCartItems() async {
    try {
      var data = json.encode([
        {
          "courtNames": [
            {
              "courtId": "686f70113e9d3976a129119a",
              "name": "Padel Court",
              "status": "active",
              "courtType": "Indoor",
              "slotTimes": [
                {
                  "status": "Active",
                  "time": "11 AM 12 PM",
                  "amount": 200
                },
                {
                  "status": "Active",
                  "time": "12 pM 1 PM",
                  "amount": 200
                }
              ]
            },
            {
              "courtId": "686f70113e9d3976a129119a",
              "name": "Court 2",
              "status": "active",
              "courtType": "Indoor",
              "slotTimes": [
                {
                  "status": "Active",
                  "time": "11 AM 12 PM",
                  "amount": 200
                },
                {
                  "status": "Active",
                  "time": "12 pM 1 PM",
                  "amount": 200
                }
              ]
            }
          ],
          "register_club_id": "686fac90cecf46f01f3cd2b5"
        }
      ]);
      final response = await dioClient.post(AppEndpoints.addCartItems,data:data);

      if (response.statusCode == 200) {
        CustomLogger.logMessage(
          msg: "Cart items fetched successful: ${response.data}",
          level: LogLevel.info,
        );
        return AddToCartModel.fromJson(response.data);
      } else {
        throw Exception(
          "Cart items failed with status code: ${response.statusCode}",
        );
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
}
