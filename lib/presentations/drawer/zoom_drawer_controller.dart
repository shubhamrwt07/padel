import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class CustomZoomDrawerController extends GetxController {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
  }

  void closeDrawer() {
    zoomDrawerController.close?.call();
  }

  void openDrawer() {
    zoomDrawerController.open?.call();
  }
}
