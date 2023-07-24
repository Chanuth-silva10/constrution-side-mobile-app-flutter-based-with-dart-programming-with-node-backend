import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login/components/body.dart';

import '../../size_config.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}
