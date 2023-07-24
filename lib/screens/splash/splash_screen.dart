import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:flutter_application_1/screens/home/home_screen.dart';
import 'package:flutter_application_1/screens/login/login_screen.dart';

import 'dart:async';
import '../../size_config.dart';
import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  final db = Localstore.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Future.delayed(Duration(seconds: 3), () async {
      final data = await db.collection('login').doc('loginData').get();
      var replacement;

      if (data != null && data["id"] != null) {
        replacement = HomeScreen();
      } else {
        replacement = LoginScreen();
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => replacement));
    });
    return Scaffold(
      body: Body(),
    );
  }
}
