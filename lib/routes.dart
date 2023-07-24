import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screens/all-deliveries/all-deliveries_screen.dart';
import 'package:flutter_application_1/screens/all-orders/all-order_screen.dart';
import 'package:flutter_application_1/screens/all-suppliers/all-suppliers_screen.dart';
import 'package:flutter_application_1/screens/create-delivery/create-delivery_screen.dart';
import 'package:flutter_application_1/screens/create-order/create-order_screen.dart';
import 'package:flutter_application_1/screens/home/home_screen.dart';
import 'package:flutter_application_1/screens/splash/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  CreateOrderScreen.routeName: (context) => CreateOrderScreen(),
  AllOrderScreen.routeName: (context) => AllOrderScreen(),
  AllSupplierScreen.routeName: (context) => AllSupplierScreen(),
  CreateDeliveryScreen.routeName: (context) => CreateDeliveryScreen(),
  AllDeliveriesScreen.routeName: (context) => AllDeliveriesScreen()
};
