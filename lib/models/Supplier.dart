class Supplier {
  static const ID = "_id";
  static const NAME = "name";
  static const ADDRESS = "address";
  static const CONTACT = "contact";
  static const STORENAME = "storeName";

  final String id;
  final String name;
  final String address;
  final String contact;
  final String storeName;

  Supplier(
      {required this.id,
      required this.name,
      required this.address,
      required this.contact,
      required this.storeName});

  List<Supplier> suppliers = [];
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json[Supplier.ID],
      name: json[Supplier.NAME],
      address: json[Supplier.ADDRESS],
      contact: json[Supplier.CONTACT],
      storeName: json[Supplier.STORENAME],
    );
  }
}

class SupplierList {
  final List<Supplier> suppliers;
  SupplierList({required this.suppliers});

  factory SupplierList.fromJson(List<dynamic> parsedJson) {
    List<Supplier> suppliers = <Supplier>[];
    suppliers = parsedJson.map((i) => Supplier.fromJson(i)).toList();

    print(suppliers);
    return new SupplierList(suppliers: suppliers);
  }
}
