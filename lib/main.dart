import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'admin.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AnimatedSplash(
              imagePath: 'images/logo.png',
              home: Administrator(),
              duration: 2000,
              type: AnimatedSplashType.StaticDuration,
            ),
  ));
}