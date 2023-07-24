import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomAppBar.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topbar.dart';
import 'package:flutter_application_1/screens/all-deliveries/components/body.dart';

import '../../enums.dart';

class AllDeliveriesScreen extends StatelessWidget {
  static String routeName = "/deliveries";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Deliveries",
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.deliveries),
    );
  }
}
