import 'package:flutter/material.dart';
import 'package:git_stat/constant/app_text.dart';
import 'package:git_stat/service/splash_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final splashService = SplashService();
  @override
  void initState() {
    super.initState();
    splashService.startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Image(
              image: AssetImage('assets/images/splash.gif'),
              height: 300,
              width: 300,
            ),
            const SizedBox(height: 50),
            LoadingAnimationWidget.inkDrop(color: Colors.grey.shade800, size: 30),
            const SizedBox(height: 60),
            Text(
              'Git Stats 🚀',
              style: AppText.popinsFont(size: 30, fontWt: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Track Your Code, Elevate Your Game! 📈✨',textAlign: TextAlign.center,
                style: AppText.popinsFont(size: 20, fontWt: FontWeight.bold))
          ]),
        ),
      ),
    );
  }
}
