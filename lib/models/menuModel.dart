import 'package:auth_flutter/models/menuCategory.dart';

class MenuModel {
  MenuModel({
    this.id,
    this.name,
    this.startsAt,
    this.endsAt,
    this.isAvailable,
    required this.categories,
  });

  int? id;
  String? name;
  String? startsAt;
  String? endsAt;
  bool? isAvailable;
  List<MenuCategory> categories;
}