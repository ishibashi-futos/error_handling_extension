import 'package:functional_error_handling_dart/functional_error_handling_dart.dart';

Future<void> main() async {
  const itemIds = [1, 2, 3, 4, 5];
  // Bad Code
  var badItemList = <Item>[]; // mutable list
  for (var itemId in itemIds) {
    var targetItem = ItemService.find(itemId);
    if (targetItem.isEmpty) {
      // error handling
    } else {
      badItemList.add(targetItem.orNull()!);
    }
  }
  badItemList; // do something

  // better code?
  final beffetItemList = itemIds.map<Either<String, Item>>((itemId) {
    final targetItem = ItemService.find(itemId);
    return targetItem.isEmpty
        ? Left('$itemId not included')
        : Right(targetItem.orNull()!);
  }).toList(); // immutable list
  beffetItemList; // do something
}

class Item {
  final int itemid;
  final String message;
  const Item({required this.itemid, required this.message});
}

const itemList = [
  Item(itemid: 1, message: 'message1'),
  Item(itemid: 2, message: 'message2'),
  Item(itemid: 3, message: 'message3'),
  // Missing id: 4
  Item(itemid: 5, message: 'message5'),
  Item(itemid: 6, message: 'message6'),
];

class ItemService {
  static Option<Item> find(int id) {
    try {
      return Some(itemList.firstWhere((element) => element.itemid == id));
    } catch (e) {
      return None();
    }
  }
}
