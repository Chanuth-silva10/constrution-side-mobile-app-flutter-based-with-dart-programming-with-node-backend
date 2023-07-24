import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes.dart';
import 'package:flutter_application_1/screens/splash/splash_screen.dart';
import 'package:flutter_application_1/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'construction',
      theme: theme(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
