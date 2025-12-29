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
      menuScreen: CustomDrawerUi(),
      mainScreen: child,
      borderRadius: 20.0,
      showShadow: true,
      shadowLayer1Color: Colors.black.withValues(alpha: 0.03),
      shadowLayer2Color: Colors.black.withValues(alpha: 0.03),
      angle: 5.0,
      slideWidth: MediaQuery.of(context).size.width * 0.55,
      menuBackgroundColor: Colors.white,
      openCurve: Curves.easeInOut,
      closeCurve: Curves.easeInOut,
      // Optional: Add more shadow customization
      mainScreenTapClose: true,
      moveMenuScreen: true,
    );
  }
}