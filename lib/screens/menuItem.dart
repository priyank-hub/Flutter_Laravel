import 'dart:convert';

import 'package:auth_flutter/models/cart.dart';
import 'package:auth_flutter/models/categoryItem.dart';
import 'package:auth_flutter/models/optionCategoryOption.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/providers/cartProvider.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuItem extends StatefulWidget {

  CategoryItem item;
  Restaurant restaurant;
  MenuItem({required this.item, required this.restaurant});

  Map<int,OptionCategoryOption?> _singleOptions = {};
  Map<int, List<OptionCategoryOption>> _multipleOptions = {};
  Map<int, Map<int, int>> _plusMinusOptions = {};
  Map<int, int> map = {};
  int item_count = 1;
  var instructions = '';

  @override
  _MenuItemState createState() => _MenuItemState(this.item, this.restaurant);

}

class _MenuItemState extends State<MenuItem> {
  var item, restaurant;
  Map<int,OptionCategoryOption?> _singleOptions = {};
  Map<int, List<OptionCategoryOption>> _multipleOptions = {};
  Map<int, Map<OptionCategoryOption, int>> _plusMinusOptions = {};
  int item_count = 1;
  var instructions = '';

  _MenuItemState(CategoryItem categoryItem, Restaurant restaurant) {
    this.item = categoryItem;
    this.restaurant = restaurant;

    for (var category in item.optionCategory) {
      Map<OptionCategoryOption, int> map = {};
      for (var option in category.options) {
        if (!category.isSingle) {
          if (option.maximum > 1) {
            map.addAll({
              option: 0
            });

            _plusMinusOptions.addAll({
              category.id: map
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: Color(0xff7c4ad9),
        elevation: 10,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String result) {
              switch (result) {
                case 'logout':
                // _logout();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              item.image,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 6, bottom: 10, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),

                  Text(
                    item.description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black26,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '\$' + item.price.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
                child: _optionCategories(item.optionCategory)
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffd5d5d5),
              ),
              child: ListTile(
                // leading: Icon(
                //   Icons.note,
                //   color: Colors.black,
                // ),
                title: Text(
                  'Additional Notes',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: 8, //or null
                decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                onChanged: (value) {
                  if (value.length > 0) {
                    setState(() {
                      instructions = value;
                    });
                  }
                },
              ),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color(0xffdedede),
                      shape: CircleBorder(),
                    ),
                    width: 50,
                    height: 50,
                    child: IconButton(
                        icon: Icon(Icons.remove, size: 20),
                        onPressed: () {
                          if (item_count != 1) {
                            setState(() {
                              item_count--;
                            });
                          }
                        }
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                        item_count.toString()
                    ),
                  ),

                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color(0xffdedede),
                      shape: CircleBorder(),
                    ),
                    width: 50,
                    height: 50,
                    child: IconButton(
                        icon: Icon(Icons.add, size: 20),
                        onPressed: () {
                          setState(() {
                            item_count++;
                          });
                        }
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              // child: _showFloatingButton(item),
              child: Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff3a177f),
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: () {
                    var res = _checkRequired();
                    if (!res) {
                      showDialog(
                          barrierDismissible: true,//tapping outside dialog will close the dialog if set 'true'
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: const Text('Required Items'),
                              content: const Text('Some of the required items arent selected or soldout. Please check again.'),
                              actions: <Widget>[
                                // TextButton(
                                //   onPressed: () => Navigator.pop(context, 'Cancel'),
                                //   child: const Text('Cancel'),
                                // ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          }
                      );
                    }
                    else {
                      _addToCart();
                    }
                  },
                  child: const Text(
                    'ADD TO CART',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: _showFloatingButton(),
    );
  }

  Widget _optionCategories(data) {
    if (data.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: data.length,
          itemBuilder: (content, index) {
            // print('plus minus options');
            // print(_plusMinusOptions[data[index].id][option]);

            return Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xffd5d5d5),
                      ),
                      child: ListTile(
                        title: Text(
                          data[index].name,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: _isRequired(data[index]),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8),
                      //options
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: data[index].options.length,
                        itemBuilder: (content, index2) {
                          var option = data[index].options[index2];
                          var category = data[index];

                          if (data[index].isSingle) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.70,
                                  child: RadioListTile<OptionCategoryOption>(
                                    title: Text(option.name),
                                    value: option,
                                    activeColor: Color(0xff7c4ad9),
                                    groupValue: _singleOptions[category.id],
                                    onChanged: (OptionCategoryOption? value) {
                                      setState(() {
                                        _singleOptions.addAll(
                                          {category.id: value}
                                        );
                                      });
                                      print(_singleOptions);
                                    },
                                  ),
                                ),

                                Container(
                                  child: _showOptionPrice(option),
                                ),
                              ],
                            );
                          }
                          else {
                            if (option.maximum == 1) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.70,
                                    child: CheckboxListTile(
                                      title: Text(option.name),
                                      value: (_multipleOptions[category.id] == null) ? false : _multipleOptions[category.id]!.contains(option),
                                      // value: (_multipleOptions[category.id] != null) ? (_multipleOptions[category.id]!.length == category.max || _multipleOptions[category.id]!.contains(option)) : false,
                                      // value: (_multipleOptions[category.id] == null) ? false : (_multipleOptions[category.id]!.length == category.max) ? false : _multipleOptions[category.id]!.contains(option),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      activeColor: Color(0xff7c4ad9),
                                      onChanged: (bool? value) {
                                        var list = _multipleOptions[category.id];
                                        if (value == true) {
                                          if (list != null) {
                                            if (list.length >= category.max) {
                                              showDialog(
                                                barrierDismissible: true,//tapping outside dialog will close the dialog if set 'true'
                                                context: context,
                                                builder: (context){
                                                  return AlertDialog(
                                                    title: const Text('Maximum Items Reached'),
                                                    content: const Text('Maximum options has been selected for this category.'),
                                                    actions: <Widget>[
                                                      // TextButton(
                                                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                                                      //   child: const Text('Cancel'),
                                                      // ),
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              );

                                              // _showAlert();
                                            }
                                            else {
                                              list.add(option);
                                              setState(() {
                                                _multipleOptions.addAll({
                                                  category.id: list
                                                });
                                              });
                                            }
                                          }
                                          else {
                                            List<OptionCategoryOption> newList = [option];
                                            setState(() {
                                              _multipleOptions.addAll({
                                                category.id: newList
                                              });
                                            });
                                          }
                                        }
                                        else {
                                          if (_multipleOptions[category.id]!.length <= category.max) {
                                            setState(() {
                                              _multipleOptions[category.id]!.remove(option);
                                              if (_multipleOptions[category.id]!.length == 0) {
                                                _multipleOptions.remove(category.id);
                                              }
                                            });
                                          }
                                        }

                                        print(_multipleOptions);
                                      },
                                    ),
                                  ),

                                  Container(
                                    child: _showOptionPrice(option),
                                  ),
                                ],
                              );
                            }
                            else {
                              // return Text('plus minus option');

                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Ink(
                                          decoration: const ShapeDecoration(
                                            color: Color(0xffdedede),
                                            shape: CircleBorder(),
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: IconButton(
                                              icon: Icon(Icons.remove, size: 18),
                                              onPressed: () {
                                                var count = _plusMinusOptions[category.id]![option];
                                                if (count! >= 1) {
                                                  setState(() {
                                                    _plusMinusOptions[category.id]![option] = (_plusMinusOptions[category.id]![option]! - 1);
                                                  });

                                                }
                                              }
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 12, right: 12),
                                          child: Text(
                                            _plusMinusOptions[data[index].id]![option].toString(),
                                          ),
                                        ),

                                        Ink(
                                          decoration: const ShapeDecoration(
                                            color: Color(0xffdedede),
                                            shape: CircleBorder(),
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: IconButton(
                                              icon: Icon(Icons.add, size: 18),
                                              onPressed: () {
                                                var count = _plusMinusOptions[category.id]![option];
                                                if (count! < option.maximum) {
                                                  setState(() {
                                                    _plusMinusOptions[category.id]![option] = (_plusMinusOptions[category.id]![option]! + 1);
                                                  });
                                                }
                                                print(_plusMinusOptions);
                                              }
                                          ),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      child: _showOptionPrice(option),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                      )
                    )
                  ],
                )
              ],
            );
          }
      );
    }
    else {
      return Text('');
    }
  }

  _showOptionPrice(option) {
    if (option.price != null && double.parse(option.price) != 0) {
      return Text(
        '+ \$ ' + option.price,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.black45,
        ),
      );
    }
    else {
      return Text('');
    }
  }

  _isRequired(data) {
    if (data.isRequired) {
      return Row(
        children: [
          Text(
            'Required',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Maximum ' + data.max.toString(),
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black45,
              ),
            ),
          )
        ],
      );
    }
    else {
      return Row(
        children: [
          Text(
            'Optional',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Maximum ' + data.max.toString(),
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black45,
              ),
            ),
          )
        ],
      );
    }
  }

  bool _checkRequired() {
    var _allOptions = {};
    _allOptions.addAll(_singleOptions);
    _allOptions.addAll(_multipleOptions);
    _allOptions.addAll(_plusMinusOptions);

    print(_allOptions);

    var categories = item.optionCategory;
    bool flag = true;
    var zeroCount = 0;
    for (var category in categories) {
      zeroCount = 0;
      if (category.isRequired) {
        for (var option in category.options) {
          if (option.maximum > 1) {
            if (_allOptions[category.id][option] == 0) {
              zeroCount++;
            }
            if (zeroCount == _allOptions[category.id].length) {
              flag = false;
            }
          }
        }

        if (_allOptions[category.id] == null) {
          flag = false;
        }
      }
    }
    return flag && _checkSoldout();
  }

  bool _checkSoldout() {
    var _allOptions = {};
    bool flag = true;
    _allOptions.addAll(_singleOptions);
    _allOptions.addAll(_multipleOptions);
    _allOptions.addAll(_plusMinusOptions);

    _singleOptions.forEach((key, value) {
      if (value!.soldout) {
        flag = false;
      }
    });

    _multipleOptions.forEach((key, value) {
      value.forEach((element) {
        if (element.soldout) {
          flag = false;
        }
      });
    });

    _plusMinusOptions.forEach((key, value) {
      value.forEach((key, value) {
        if (key.soldout) {
          flag = false;
        }
      });
    });

    return flag;
  }

  _addToCart() async {
    final model = Provider.of<CartProvider>(context, listen: false);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var _allOptions = {};
    _allOptions.addAll(_singleOptions);
    _allOptions.addAll(_multipleOptions);
    _allOptions.addAll(_plusMinusOptions);

    var payload = Cart(
      restaurantId: restaurant.id,
      restaurantName: restaurant.name,
      itemId: item.id,
      itemName: item.name,
      itemImage: item.image,
      charge: _getCharge(),
      originalCharge: item.price,
      soldout: item.soldOut,
      instructions: instructions,
      quantity: item_count,
      optionCategories: _allOptions,
    );

    model.addItem(payload);

    Navigator.pop(context);
  }

  _getCharge() {
    var itemPrice = item.price;

    double singleOptionsPrice = 0.0;
    double doubleOptionsPrice = 0.0;
    double plusMinusOptionsPrice = 0.0;

    if (_singleOptions.length > 0) {
      double sum = 0.0;
      _singleOptions.forEach((key, value) {
        if (value!.price != null) {
          sum = sum + double.parse(value!.price);
        }
      });
      singleOptionsPrice = sum;
    }

    if (_multipleOptions.length > 0) {
      double sum = 0.0;
      print('multiple $_multipleOptions');
      _multipleOptions.forEach((key, value) {
        value.forEach((option) {
          if (option.price != null) {
            sum = sum + double.parse(option.price);
          }
        });
      });
      doubleOptionsPrice = sum;
    }

    if (_plusMinusOptions.length > 0) {
      double sum = 0.0;
      _plusMinusOptions.forEach((key, value) {
        value.forEach((key, value) {
          sum = sum + (double.parse(key.price) * value);
        });
      });

      plusMinusOptionsPrice = sum;
    }

    print('singleOptionsPrice $singleOptionsPrice');
    print('doubleOptionsPrice $doubleOptionsPrice');
    print('plusMinusOptionsPrice $plusMinusOptionsPrice');

    return (double.parse(item.price) + singleOptionsPrice + doubleOptionsPrice + plusMinusOptionsPrice) * item_count;
  }
}