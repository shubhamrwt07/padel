import 'package:padel_mobile/presentations/splash/widgets/splash_exports.dart';

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
