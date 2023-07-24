import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/screens/all-deliveries/all-deliveries_screen.dart';
import 'package:flutter_application_1/screens/all-orders/all-order_screen.dart';
import 'package:flutter_application_1/screens/all-suppliers/all-suppliers_screen.dart';
import 'package:flutter_application_1/screens/create-delivery/create-delivery_screen.dart';
import 'package:flutter_application_1/screens/create-order/create-order_screen.dart';
import 'package:flutter_application_1/size_config.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('MMMM dd, yyyy');

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final String formatted = Body.formatter.format(Body.now);

  final db = Localstore.instance;

  getData() async {
    data = await db.collection('login').doc('loginData').get();
    print(data);
  }

  late Map<String, dynamic>? data;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
              future: getData(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                return Container(
                  padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(20),
                      getProportionateScreenWidth(30),
                      getProportionateScreenWidth(20),
                      getProportionateScreenWidth(30)),
                  margin: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(15),
                      getProportionateScreenWidth(25),
                      getProportionateScreenWidth(15),
                      getProportionateScreenWidth(15)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: kProductBgColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${data?["firstName"] + " " + data?["lastName"]}",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          formatted,
                          style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            child: DefaultButton(
                text: "Create Order",
                press: () => {
                      Navigator.pushNamed(context, CreateOrderScreen.routeName)
                    }),
          ),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            child: DefaultButton(
                text: "View All Orders",
                press: () =>
                    {Navigator.pushNamed(context, AllOrderScreen.routeName)}),
          ),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            child: DefaultButton(
                text: "View Suppliers",
                press: () => {
                      Navigator.pushNamed(context, AllSupplierScreen.routeName)
                    }),
          ),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            child: DefaultButton(
                text: "Create Delivery",
                press: () => {
                      Navigator.pushNamed(
                          context, CreateDeliveryScreen.routeName)
                    }),
          ),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            child: DefaultButton(
                text: "View Deliveries",
                press: () => {
                      Navigator.pushNamed(
                          context, AllDeliveriesScreen.routeName)
                    }),
          ),
        ],
      ),
    );
  }
}
