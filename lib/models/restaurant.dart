
class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    // this.description,
    required this.tags,
    required this.orderTypes,
    required this.image,
    required this.mobileBackground,
    required this.isOpenNow,
    required this.openingHours,
  });
  int id;
  String name;
  // String? description;
  String tags;
  String orderTypes;
  String image;
  String mobileBackground;
  bool isOpenNow;
  String openingHours;
}