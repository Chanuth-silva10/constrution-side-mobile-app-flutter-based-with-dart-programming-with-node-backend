import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomAppBar.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topbar.dart';
import 'package:flutter_application_1/screens/all-orders/components/body.dart';

import '../../enums.dart';

class AllOrderScreen extends StatelessWidget {
  static String routeName = "/order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Orders",
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.orders),
    );
  }
}
