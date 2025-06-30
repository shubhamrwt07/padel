import 'package:get/get.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = List.generate(
    4,
        (index) => CartItem(
      title: "Padel Haus",
      date: "27June, 2025",
      time: "8:00am (60m)",
      price: 1000,
    ),
  ).obs;

  int get totalPrice => cartItems
      .where((item) => item.isSelected.value)
      .fold(0, (sum, item) => sum + item.price);

  int get selectedCount => cartItems.where((item) => item.isSelected.value).length;
}
class CartItem {
  final String title;
  final String date;
  final String time;
  final int price;
  RxBool isSelected;

  CartItem({
    required this.title,
    required this.date,
    required this.time,
    required this.price,
    bool selected = true,
  }) : isSelected = RxBool(selected);
}
