
class Cart {
  Cart({
    required this.restaurantId,
    required this.restaurantName,
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.charge,
    required this.originalCharge,
    required this.soldout,
    // required this.taxExempt,
    this.instructions,
    required this.quantity,
    required this.optionCategories,
  });

  int restaurantId;
  String restaurantName;
  int itemId;
  String itemName;
  String itemImage;
  double charge;
  String originalCharge;
  bool soldout;
  // bool taxExempt;
  String? instructions;
  int quantity;
  Map optionCategories;

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'itemId': itemId,
      'itemName': itemName,
      'soldout': soldout,
      'instructions': instructions,
      'quantity': quantity,
      'optionCategories': optionCategories,
    };
  }

  factory Cart.fromJson(dynamic json) {
    return Cart(
      restaurantId: json['restaurantId'] as int,
      restaurantName: json['restaurantName'] as String,
      itemId: json['itemId'] as int,
      itemName: json['itemName'] as String,
      itemImage: json['itemImage'] as String,
      soldout: json['soldout'] as bool,
      instructions: json['instructions'] as String,
      quantity: json['quantity'] as int,
      optionCategories: json['optionCategories'] as Map,
      originalCharge: json['originalCharge'] as String,
      charge: json['charge'] as double,
    );
  }
}

