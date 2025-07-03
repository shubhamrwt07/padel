import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'configs/routes/routes.dart';
import 'configs/themes/app_themes.dart';
import 'core/network/dio_client.dart';

Future<void> main() async {
  await GetStorage.init();
  Get.put(DioClient());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matchacha Padel',
      theme: AppThemes.appTheme,
      darkTheme: ThemeData.light(),
      themeMode: ThemeMode.light,
      getPages: Routes.route,
      initialRoute: Routes.initialRoute,
    );
  }
}
