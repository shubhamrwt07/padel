import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'configs/routes/routes.dart';
import 'configs/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Padel App',
      theme: AppThemes.appTheme,
      darkTheme: ThemeData.light(),
      themeMode: ThemeMode.light,
      getPages: Routes.route,
      initialRoute: Routes.initialRoute,
    );
  }
}
