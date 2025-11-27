import 'package:get/get.dart';
class Package {
  final String title;
  final String description;
  final String slots;
  final String validity;
  final String price;

  Package({
    required this.title,
    required this.description,
    required this.slots,
    required this.validity,
    required this.price,
  });
}

class PackagesController extends GetxController {
  var packages = <Package>[
    Package(
      title: "Beginner Pack",
      description: "Perfect for newcomers or a weekend tryout.",
      slots: "3 Hrs",
      validity: "3 Days",
      price: "1800",
    ),
    Package(
      title: "Regular Player",
      description: "Ideal for players who book a few sessions a week.",
      slots: "10 Hrs",
      validity: "10 Days",
      price: "5000",
    ),
    Package(
      title: "Weekend Warrior",
      description: "Great for consistent weekend or evening players.",
      slots: "20 Hrs",
      validity: "20 Days",
      price: "9500",
    ),
    Package(
      title: "Champion",
      description: "Best value for club members or serious competitors.",
      slots: "40 Hrs",
      validity: "60 Days",
      price: "1750",
    ),
    Package(
      title: "Weekend Warrior",
      description: "Great for consistent weekend or evening players.",
      slots: "20 Hrs",
      validity: "20 Days",
      price: "9500",
    ),
    Package(
      title: "Champion",
      description: "Best value for club members or serious competitors.",
      slots: "40 Hrs",
      validity: "60 Days",
      price: "1750",
    ),
  ].obs;
}