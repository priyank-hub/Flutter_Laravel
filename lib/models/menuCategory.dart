import 'package:auth_flutter/models/categoryItem.dart';

class MenuCategory {
  MenuCategory({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.position,
    required this.items,
    required this.image,
  });

  int id;
  int restaurantId;
  String name;
  int position;
  List<CategoryItem> items;
  String image;
}