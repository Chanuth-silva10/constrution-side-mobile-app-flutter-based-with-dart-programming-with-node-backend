import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:flutter_application_1/components/MultiSelectDialog.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/components/rounded_icon_btn.dart';
import 'package:flutter_application_1/models/Item.dart';
import 'package:flutter_application_1/models/Order.dart';
import 'package:flutter_application_1/models/Site.dart';
import 'package:flutter_application_1/models/Supplier.dart';
import 'package:flutter_application_1/screens/all-orders/all-order_screen.dart';
import 'package:flutter_application_1/screens/home/home_screen.dart';
import 'package:flutter_application_1/services/itemService.dart';
import 'package:flutter_application_1/services/orderService.dart';
import 'package:flutter_application_1/services/siteService.dart';
import 'package:flutter_application_1/services/supplierService.dart';
import 'package:flutter_application_1/size_config.dart';

import '../../../constants.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

  Future<SupplierList> setSupplierList() async {
    final SupplierList allSuppliers = await SupplierService().getAllSuppliers();

    suppliers = [];

    for (Supplier s in allSuppliers.suppliers) {
      Map<String, String> item = {'id': s.id, 'store': s.storeName};
      suppliers.add(item);
    }

    if (suppliers.length > 0) {
      setItemList(suppliers[0]["id"]!);
    }
    await setSiteList();
    await getData();
    return allSuppliers;
  }

  Future<SiteList> setSiteList() async {
    allSites = await SiteService().getAllSites();
    sites = [];
    for (Site s in allSites.sites) {
      Map<String, String> item = {'id': s.id, 'site': s.siteName};
      sites.add(item);
    }
    selectedSite = allSites.sites[0].id;
    return allSites;
  }

  static Future<ItemList> setItemList(String supplierId) async {
    selectedSupplier = supplierId;

    final ItemList allItems = await ItemService().getItemBySupplier(supplierId);

    Map<String, String> item = {};
    items = [];
    for (Item i in allItems.items) {
      item[i.id] = i.itemName;
      items.add(i);
    }
    supplierItems = item;
    return allItems;
  }

  void onSiteSelect(String value) {
    Site s = allSites.sites.where((site) => site.id == value).toList()[0];
    deliveryAddressController.text = s.siteAddress;
    selectedSite = value;
  }

  static DateTime expectedDelivery = new DateTime.now();
  static List<dynamic> addedItems = [];
  int total = 0;

  int calculateTotal() {
    print("Calculate Total");
    int sum = 0;
    addedItems.forEach(
        (item) => {sum = sum + (item['price'] * item['itemQty']) as int});

    setState(() {
      total = sum;
    });
    return sum;
  }

  final db = Localstore.instance;

  getData() async {
    data = await db.collection('login').doc('loginData').get();
    print(data);
  }

  late Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
  }

  String dropdownvalue = '';

  List<Map<String, String>> suppliers = [];
  List<Map<String, String>> sites = [];
  static List<Item> items = [];
  static Map<String, String> supplierItems = {};
  static String? selectedSupplier;
  late String selectedSite;
  late SiteList allSites;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: setSupplierList(),
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
                  SupplierDropDown(
                      label: "Supplier",
                      dropdownvalue: dropdownvalue,
                      items: suppliers),
                  DropDown(
                      label: "Site",
                      dropdownvalue: dropdownvalue,
                      items: sites,
                      onSelect: onSiteSelect),
                  InputBox(
                    label: "Delivery Address",
                    placeholder: "Enter Here",
                    controller: deliveryAddressController,
                  ),
                  DatePickerInput(label: "Expected Delivery"),
                  ItemBox(
                    function: calculateTotal,
                  ),
                  TextArea(
                    label: "Order Notes",
                    placeholder: "Please enter your order notes",
                    controller: orderNotesController,
                  ),
                  Total(total: total),
                  Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                    child: DefaultButton(
                        text: "Place Order",
                        press: () async {
                          List<dynamic> items = [];
                          if (deliveryAddressController.text.length == 0) {
                            showAlertDialog(
                                context, "Please enter a delivery address");
                          } else if (addedItems.length == 0) {
                            showAlertDialog(
                                context, "Please add items to your order");
                          } else {
                            addedItems.forEach((item) {
                              items.add({
                                'itemId': item['itemId'],
                                'qty': item['itemQty'],
                                'price': item['price']
                              });
                            });
                            Map<String, dynamic> order = {
                              'site': selectedSite,
                              'supplier': selectedSupplier,
                              'deliveryAddress': deliveryAddressController.text,
                              'expectedDeliveryDate':
                                  expectedDelivery.toIso8601String(),
                              'orderNotes': orderNotesController.text,
                              'total': total,
                              'comments': [],
                              'items': items,
                              'createdBy': data?["id"]
                            };
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

class Total extends StatefulWidget {
  const Total({Key? key, required this.total}) : super(key: key);
  final int total;
  @override
  State<Total> createState() => _TotalState();
}

class _TotalState extends State<Total> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Expanded(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Rs.${widget.total}",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(20),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemBox extends StatefulWidget {
  ItemBox({Key? key, required this.function}) : super(key: key);

  final Function function;
  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  List<dynamic> selectedItems = [];

  List<MultiSelectDialogItem<String>> multiItem =
      <MultiSelectDialogItem<String>>[];

  void populateMultiselect() {
    final valuestopopulate = _BodyState.supplierItems;
    for (String v in valuestopopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuestopopulate[v]));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    multiItem = [];
    populateMultiselect();
    final items = multiItem;

    final selectedValues = await showDialog<Set<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          // initialSelectedValues: [""].toSet(),
        );
      },
    );

    filterItems(selectedValues!);
  }

  void filterItems(Set selection) {
    if (selection != null) {
      for (String x in selection.toList()) {
        _BodyState.items.where((i) => i.id == x);

        var selectedItem =
            _BodyState.items.where((i) => i.id == x).toList().first;

        var supplierItem = selectedItem.supplier
            .where((i) => i['supplierId'] == _BodyState.selectedSupplier)
            .toList()
            .first;

        var item = {
          'itemId': selectedItem.id,
          'itemName': selectedItem.itemName,
          'unit': selectedItem.defaultUnit,
          'qty': supplierItem['qty'],
          'itemQty': 1,
          'price': supplierItem['unitPrice']
        };
        selectedItems.add(item);
        _BodyState.addedItems.add(item);
        widget.function();
      }
      setState(() {
        selectedItems = selectedItems;
      });
    }
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
                  ),
                  RoundedIconBtn(
                    iconData: Icons.add,
                    press: () => {_showMultiSelect(context)},
                    color: Colors.black,
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
                unitPrice: selectedItems[index]['price'],
                defaultUnit: selectedItems[index]['unit'],
                function: widget.function,
              );
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
      required this.unitPrice,
      required this.defaultUnit,
      required this.function})
      : super(key: key);

  final int index;
  final String itemName;
  final int unitPrice;
  final String defaultUnit;
  final Function function;

  @override
  State<ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  int qty = 1;
  late int price;
  final qtyController = TextEditingController();

  @override
  void initState() {
    price = qty * widget.unitPrice;
    qtyController.addListener(_handleQtyChanges);
  }

  void _handleQtyChanges() {
    qty = int.tryParse(qtyController.text.trim()) ?? 1;

    _BodyState.addedItems.elementAt(widget.index - 1)['itemQty'] = qty;

    setState(() {
      price = qty * widget.unitPrice;
      widget.function();
      // Body.total = Body.calculateTotal();
    });
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
                "Rs.${widget.unitPrice}/${widget.defaultUnit}",
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
                  suffixText: widget.defaultUnit,
                ),
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number),
          ),
          Text(
            "Rs.$price",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenWidth(16)),
          ),
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

class SupplierDropDown extends StatefulWidget {
  const SupplierDropDown(
      {Key? key,
      required this.label,
      required this.dropdownvalue,
      required this.items})
      : super(key: key);

  final String label;
  final String dropdownvalue;
  final List<Map<String, String>> items;

  @override
  State<SupplierDropDown> createState() => _SupplierDropdownState();
}

class _SupplierDropdownState extends State<SupplierDropDown> {
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
                  _BodyState.setItemList(newValue!);
                  value = newValue!;
                });
              },
              items: widget.items.map((Map<String, String> items) {
                return DropdownMenuItem(
                    value: items['id']!, child: Text(items['store']!));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class DropDown extends StatefulWidget {
  const DropDown(
      {Key? key,
      required this.label,
      required this.dropdownvalue,
      required this.items,
      required this.onSelect})
      : super(key: key);

  final String label;
  final String dropdownvalue;
  final List<Map<String, String>> items;
  final Function onSelect;

  @override
  State<DropDown> createState() => _DropdownState();
}

class _DropdownState extends State<DropDown> {
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
                  widget.onSelect(newValue!);
                  value = newValue!;
                });
              },
              items: widget.items.map((Map<String, String> items) {
                return DropdownMenuItem(
                    value: items['id']!, child: Text(items['site']!));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
