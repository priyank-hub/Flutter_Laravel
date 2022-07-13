
class OptionCategoryOption {
  OptionCategoryOption({
    required this.id,
    required this.optionCategoryId,
    required this.name,
    required this.price,
    required this.soldout,
    required this.calories,
    required this.maximum,
    required this.sides,
    required this.position,

  });

  int id;
  int optionCategoryId;
  String name;
  String price;
  bool soldout;
  bool calories;
  int maximum;
  bool sides;
  int position;
}