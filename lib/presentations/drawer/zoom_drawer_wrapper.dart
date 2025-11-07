import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:padel_mobile/presentations/drawer/custom_drawer_ui.dart';
import 'package:padel_mobile/presentations/drawer/zoom_drawer_controller.dart';

class ZoomDrawerWrapper extends StatelessWidget {
  final Widget child;

  const ZoomDrawerWrapper({
    super.key,



    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.put(CustomZoomDrawerController());

    return ZoomDrawer(
      controller: drawerController.zoomDrawerController,
      menuScreen: const CustomDrawerUi(),
      mainScreen: child,
      borderRadius: 20.0,
      showShadow: true,
      angle: 0.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Colors.white,
      openCurve: Curves.easeInOut,
      closeCurve: Curves.easeInOut,
    );
  }
}
