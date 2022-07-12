class CategoryItem {
  CategoryItem({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.soldOut,
    required this.position,
    required this.image,
  });

  int id;
  int restaurantId;
  int categoryId;
  String name;
  String description;
  String price;
  bool soldOut;
  int position;
  String image;
}