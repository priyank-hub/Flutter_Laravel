
import 'package:auth_flutter/models/itemOptionCategory.dart';

class CartItem {
  CartItem({
    required this.restaurantId,
    required this.restaurantName,
    required this.itemId,
    required this.itemName,
    required this.charge,
    required this.originalCharge,
    required this.soldout,
    required this.taxExempt,
    this.instructions,
    required this.quantity,
    required this.optionCategories,
  });

  int restaurantId;
  String restaurantName;
  int itemId;
  String itemName;
  double charge;
  double originalCharge;
  bool soldout;
  bool taxExempt;
  String? instructions;
  int quantity;
  Map optionCategories;
}