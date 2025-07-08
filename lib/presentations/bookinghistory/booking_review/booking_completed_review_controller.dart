import 'package:get/get.dart';

class BookingCompletedReviewController extends GetxController{
  RxDouble rating = 3.0.obs;

  void updateRating(double newRating) {
    rating.value = newRating;
  }
}