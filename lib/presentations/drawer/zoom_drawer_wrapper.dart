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

      // 🎯 Smooth animation tuning
      duration: const Duration(milliseconds: 300),
      openCurve: Curves.easeOutCubic,
      closeCurve: Curves.easeInCubic,

      // 🎨 Visual smoothness
      borderRadius: 24,
      angle: 0.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      showShadow: true,

      // shadowLayer1Color: Colors.black.withOpacity(0.05),
      // shadowLayer2Color: Colors.black.withOpacity(0.08),

      // ⚙️ Behavior
      menuBackgroundColor: Colors.white,
      mainScreenTapClose: true,
      moveMenuScreen: true,
    );
  }
}
