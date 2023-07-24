class Item {
  static const ID = "_id";
  static const ITEMNAME = "itemName";
  static const ITEMCODE = "itemCode";
  static const DEFAULTUNIT = "defaultUnit";
  static const SUPPLIER = "supplier";

  final String id;
  final String itemName;
  final String itemCode;
  final String defaultUnit;
  final List<dynamic> supplier;

  Item(
      {required this.id,
      required this.itemName,
      required this.itemCode,
      required this.defaultUnit,
      required this.supplier});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json[Item.ID],
      itemName: json[Item.ITEMNAME],
      itemCode: json[Item.ITEMCODE],
      defaultUnit: json[Item.DEFAULTUNIT],
      supplier: json[Item.SUPPLIER],
    );
  }
}

class ItemList {
  final List<Item> items;

  ItemList({required this.items});

  factory ItemList.fromJson(List<dynamic> parsedJson) {
    List<Item> items = <Item>[];
    items = parsedJson.map((i) => Item.fromJson(i)).toList();
    return new ItemList(items: items);
  }
}
