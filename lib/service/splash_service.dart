import 'dart:async';
import 'package:flutter/material.dart';
import 'package:git_stat/view/home_view.dart';

class SplashService {
  void startTimer(BuildContext context) {
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    });
  }
}
