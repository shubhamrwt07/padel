import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/app_strings.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child:
            Text(AppStrings.appName,style: TextStyle(fontSize: 22),)),
      ),
    );
  }
}
