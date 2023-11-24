import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/MultiSelectDialog.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/components/rounded_icon_btn.dart';
import 'package:flutter_application_1/models/Item.dart';
import 'package:flutter_application_1/models/Order.dart';
import 'package:flutter_application_1/screens/all-orders/all-order_screen.dart';
import 'package:flutter_application_1/services/itemService.dart';
import 'package:flutter_application_1/services/orderService.dart';
import 'package:flutter_application_1/size_config.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../../../constants.dart';

import 'package:intl/intl.dart';

import 'InputBox.dart';
import 'TextArea.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final deliveryAddressController = TextEditingController();
  final orderNotesController = TextEditingController();

  static var orderObjects = [];
  static ItemList allItems = ItemList(items: []);

  Future<OrderList> setOrderList() async {
    final OrderList allOrders = await OrderService().getAllOrders();

    orders = [];
    for (Order order in allOrders.orders) {
      Map<String, String> item = {
        'id': order.id,
        'orderRef': '#' + order.orderReferenceNo.toString()
      };
      orders.add(item);
      orderObjects.add(order);
    }
    if (orders.length > 0) {
      allItems = await ItemService().getAllItems();
      setItemList(orders[0]["id"]!);
    }
    return allOrders;
  }

  Future<ItemList> setItemList(String orderId) async {
    Order selectedOrderObject = Order(
        id: "",
        orderReferenceNo: 0,
        site: {},
        supplier: {},
        deliveryAddress: '',
        expectedDeliveryDate: '',
        total: 0,
        items: [],
        status: '',
        comments: []);

    orderObjects.forEach(
        (order) => {if (order.id == orderId) selectedOrderObject = order});

    selectedOrder = orderId;
    var orderItemObjects = [];

    allItems.items.forEach((item) => {
          selectedOrderObject.items.forEach((orderItem) => {
                if (item.id == orderItem['itemId'])
                  {
                    orderItemObjects
                        .add({'itemName': item.itemName, ...orderItem})
                  }
              })
        });

    setState(() {
      // orderItems = orderItemObjects;
    });

    addedItems = orderItems;

    return allItems;
  }

  static DateTime expectedDelivery = new DateTime.now();
  static List<dynamic> addedItems = [];
  int total = 0;

  @override
  void initState() {
    super.initState();
  }

  String dropdownvalue = '';

  List<Map<String, String>> orders = [];
  static List<Item> items = [];
  static List<dynamic> orderItems = [];
  static String? selectedOrder;

  List<dynamic> getItems() {
    return orderItems;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: setOrderList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            );
          } else {
            return Container(
              color: kProductBgColor,
              child: Column(
                children: [
                  OrderDropDown(
                      label: "Order",
                      dropdownvalue: dropdownvalue,
                      items: orders,
                      function: setItemList),
                  DatePickerInput(label: "Date"),
                  ItemBox(items: orderItems),
                  TextArea(
                    label: "Comment",
                    placeholder: "",
                    controller: orderNotesController,
                  ),
                  Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                    child: DefaultButton(
                        text: "Mark Delivery",
                        press: () async {
                          List<dynamic> items = [];
                          inspect(orderItems);
                          if (addedItems.length == 0) {
                            showAlertDialog(
                                context, "Please add items to your order");
                          } else {
                            addedItems.forEach((item) {
                              items.add({
                                'itemId': item['itemId'],
                                'qty': item['itemQty'],
                                'delivered': item['delivered'] + item['itemQty']
                              });
                            });

                            inspect(items);
                            Map<String, dynamic> order = {
                              'site': "Test Site",
                              'order': selectedOrder,
                              'deliveryAddress': deliveryAddressController.text,
                              'expectedDeliveryDate':
                                  expectedDelivery.toIso8601String(),
                              'orderNotes': orderNotesController.text,
                              'total': total,
                              'comments': [],
                              'items': items
                            };
                            inspect(order);
                            return;
                            int orderNo =
                                await OrderService().createOrder(order);
                            showMessageDialog(context,
                                "Your order No $orderNo has been placed Successfully");
                          }
                        }),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

showAlertDialog(
  BuildContext context,
  String message,
) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showMessageDialog(
  BuildContext context,
  String message,
) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushNamed(context, AllOrderScreen.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class ItemBox extends StatefulWidget {
  ItemBox({Key? key, required this.items}) : super(key: key);

  final List<dynamic> items;
  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  List<dynamic> selectedItems = [];
  @override
  void initState() {
    super.initState();
    selectedItems = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Items",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18)),
                  )
                ],
              ),
            ),
            Divider(
              color: kSecondaryColor,
            ),
            Column(
                children: List.generate(selectedItems.length, (index) {
              return ItemRow(
                  index: index + 1,
                  itemName: selectedItems[index]['itemName'],
                  delivered: selectedItems[index]['delivered'],
                  total: selectedItems[index]['qty']);
            })),
          ],
        ),
      ),
    );
  }
}

class ItemRow extends StatefulWidget {
  const ItemRow(
      {Key? key,
      required this.index,
      required this.itemName,
      required this.delivered,
      required this.total})
      : super(key: key);

  final int index;
  final String itemName;
  final int delivered;
  final int total;
  // final int total;

  @override
  State<ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  int qty = 0;
  late int price = 0;
  final qtyController = TextEditingController();

  @override
  void initState() {
    qtyController.addListener(_handleQtyChanges);
  }

  void _handleQtyChanges() {
    qty = int.tryParse(qtyController.text.trim()) ?? 0;

    _BodyState.orderItems.elementAt(widget.index - 1)['itemQty'] = qty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.index}.",
            style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(14),
                fontWeight: FontWeight.w600),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.itemName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Delivered ${widget.delivered}/${widget.total}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(14)),
              ),
            ],
          ),
          Container(
            width: getProportionateScreenWidth(100),
            child: TextFormField(
                controller: qtyController,
                decoration: InputDecoration(
                  hintText: "$qty",
                  border: OutlineInputBorder(),
                  prefixText: 'Qty: ',
                ),
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number),
          )
        ],
      ),
    );
  }
}

class DatePickerInput extends StatefulWidget {
  const DatePickerInput({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  static DateTime now = DateTime.now();
  static DateFormat formatter = DateFormat('dd-MM-yyyy');
  String formatted = formatter.format(now);

  changeDate(DateTime date) {
    setState(() {
      now = date;
      _BodyState.expectedDelivery = date;
      formatted = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(16)),
                ),
                TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2100, 6, 7), onConfirm: (date) {
                      changeDate(date);
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Icon(
                    Icons.calendar_today,
                    color: kPrimaryDarkColor.withOpacity(0.8),
                    size: 16,
                  ),
                )
              ],
            ),
            Text('$formatted')
          ],
        ),
      ),
    );
  }
}

class OrderDropDown extends StatefulWidget {
  const OrderDropDown(
      {Key? key,
      required this.label,
      required this.dropdownvalue,
      required this.items,
      required this.function})
      : super(key: key);

  final String label;
  final String dropdownvalue;
  final List<Map<String, String>> items;
  final Function function;

  @override
  State<OrderDropDown> createState() => _OrderDropdownState();
}

class _OrderDropdownState extends State<OrderDropDown> {
  late String? value;
  @override
  void initState() {
    value = widget.items[0]['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(16)),
            ),
            DropdownButton(
              value: value,
              icon: Icon(Icons.keyboard_arrow_down),
              underline: Container(
                height: 0,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  widget.function(newValue!);
                  value = newValue!;
                });
              },
              items: widget.items.map((Map<String, String> items) {
                return DropdownMenuItem(
                    value: items['id']!, child: Text(items['orderRef']!));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
