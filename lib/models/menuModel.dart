import 'package:auth_flutter/models/menuCategory.dart';

class MenuModel {
  MenuModel({
    required this.id,
    required this.name,
    required this.startsAt,
    required this.endsAt,
    required this.isAvailable,
    // required this.categories,
  });

  int id;
  String name;
  String startsAt;
  String endsAt;
  bool isAvailable;
  // MenuCategory categories;
}