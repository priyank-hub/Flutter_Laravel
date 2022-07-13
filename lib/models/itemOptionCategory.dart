
import 'optionCategoryOption.dart';

class ItemOptionCategory {
  ItemOptionCategory({
    required this.id,
    required this.itemId,
    required this.name,
    required this.isRequired,
    required this.isSingle,
    required this.max,
    required this.position,
    required this.options,
  });

  int id;
  int itemId;
  String name;
  bool isRequired;
  bool isSingle;
  int max;
  int position;
  List<OptionCategoryOption> options;
}