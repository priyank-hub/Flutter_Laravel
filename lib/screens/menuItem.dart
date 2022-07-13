import 'package:auth_flutter/models/categoryItem.dart';
import 'package:auth_flutter/models/itemOptionCategory.dart';
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

  _MenuItemState(CategoryItem categoryItem) {
    this.item = categoryItem;
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
      body: Column(
        children: [
          Image.network(
            item.image,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.width * 0.45,
            width: MediaQuery.of(context).size.width,
          ),

          Container(
            child: ListTile(
              title: Text(
                item.name,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                item.description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black26,
                ),
              ),
            ),
          ),

          Container(
            child: _optionCategories(item.optionCategory)
          )
        ],
      )
    );
  }

  Widget _optionCategories(data) {
    if (data.length > 0) {
      return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (content, index) {
              return Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index].name,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data[index].options.length,
                          itemBuilder: (content, index2) {
                            return Text(
                              data[index].options[index2].name
                            );
                          }
                        )
                      )
                    ],
                  )
                ],
              );
            }
        ),
      );
    }
    else {
      return Text(
        'No option categories found'
      );
    }
  }

}