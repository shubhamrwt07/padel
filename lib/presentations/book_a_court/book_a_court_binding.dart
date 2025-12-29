import 'package:get/get.dart';
import 'package:padel_mobile/presentations/book_a_court/book_a_court_controller.dart';

class BookACourtBinding implements Bindings{
  @override
  void dependencies() {
   Get.put(BookACourtController());
  }
}