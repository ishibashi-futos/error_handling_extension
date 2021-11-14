# Functional Error Handling dart &middot; [![workflows](https://github.com/ishibashi-futos/functional_error_handling_dart/actions/workflows/workflows.yaml/badge.svg?branch=master)](https://github.com/ishibashi-futos/functional_error_handling_dart/actions/workflows/workflows.yaml)

This library is for functional error handling.

Let's have a Scala Like programming experience using Option, Either and Try.

## Installation

```yaml
dependencies:
  functional_error_handling_dart:
    git:
      url: https://github.com/ishibashi-futos/functional_error_handling_dart.git
      ref: ${tag_name} # latest package version.
```

## How to use?

### Option

Get a value that may be Null

```dart
var names = {'John': 'Doe', 'Hoge': 'Fuga'};

Option<String> getName(String name) =>
    names.containsKey(name) ? Some(names[name]!) : None();

// Some
final doe = getName('John');
print(doe.isDefined); //true
print(doe.getOrElse('No Name')); // 'Doe'

// Some
final smith = getName('Jane');
print(smith.isDefined); // false
print(smith.isEmpty); // true
print(smith.getOrElse('Smith')); // 'Smith
```

### Try

```dart
Try<int, Exception> parseInt(String source) {
  try {
    return Success(int.parse(source));
  } on FormatException catch (e) {
    return Failure(e);
  }
}

var parsed1 = parseInt("1000");
print(parsed1.isSuccess); // true
print(parsed1.getOrElse(1000)); // 2000
var parsed2 = parseInt("#2000");
print(parsed2.isFailure); // true
print(parsed2.getOrElse(1000)); // 1000
print(parsed2.recover((p0) => Success(0))); // Instance of 'Success<int>'
```

### Either

```dart
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
```
