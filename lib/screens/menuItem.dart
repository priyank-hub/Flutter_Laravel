import 'package:auth_flutter/models/categoryItem.dart';
import 'package:auth_flutter/models/optionCategoryOption.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatefulWidget {

  CategoryItem categoryItem;
  MenuItem({required this.categoryItem});

  @override
  _MenuItemState createState() => _MenuItemState(this.categoryItem);
}

class _MenuItemState extends State<MenuItem> {
  var item;
  Map<int,OptionCategoryOption?> _singleOptions = {};
  Map<int, List<OptionCategoryOption>> _multipleOptions = {};
  Map<int, Map<int, int>> _plusMinusOptions = {};
  Map<int, int> map = {};

  _MenuItemState(CategoryItem categoryItem) {
    this.item = categoryItem;

    for (var category in item.optionCategory) {
      for (var option in category.options) {
        if (!category.isSingle) {
          if (option.maximum > 1) {
            map.addAll({
              option.id: 0
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
                            content: const Text('Some of the required items arent selected. Please check again.'),
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
                            return RadioListTile<OptionCategoryOption>(
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
                            );
                          }
                          else {
                            if (option.maximum == 1) {
                              return CheckboxListTile(
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
                              );
                            }
                            else {
                              // return Text('plus minus option');

                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: <Widget>[
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
                                          var count = _plusMinusOptions[category.id]![option.id];
                                          if (count! >= 1) {
                                            setState(() {
                                              _plusMinusOptions[category.id]![option.id] = (_plusMinusOptions[category.id]![option.id]! - 1);
                                            });
                                          }
                                        }
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                      child: Text(
                                          _plusMinusOptions[data[index].id]![option.id].toString(),
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
                                          var count = _plusMinusOptions[category.id]![option.id];
                                          if (count! < option.maximum) {
                                            setState(() {
                                              _plusMinusOptions[category.id]![option.id] = (_plusMinusOptions[category.id]![option.id]! + 1);
                                            });
                                          }
                                          print(_plusMinusOptions);
                                        }
                                      ),
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
    for (var category in categories) {
      if (category.isRequired) {
        for (var option in category.options) {
          if (option.maximum > 1) {
            if (_allOptions[category.id][option.id] < 0) {
              flag = false;
            }
          }
        }

        if (_allOptions[category.id] == null) {
          flag = false;
        }
      }
    }
    return flag;
  }

  _addToCart() {
    Navigator.pop(context);
  }
}