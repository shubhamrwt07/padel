import 'package:flutter/material.dart';
import 'package:padel_mobile/configs/components/primary_container.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PrimaryContainer(
        child: Center(
            child:
            Text("Splash",style: TextStyle(fontSize: 22),)),
      ),
    );
  }
}
