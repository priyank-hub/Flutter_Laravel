

import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/components/menuCategoryCard.dart';
import 'package:auth_flutter/models/categoryItem.dart';
import 'package:auth_flutter/models/menuCategory.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/models/menuModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Menu extends StatefulWidget {

  Restaurant restaurant;

  Menu({required this.restaurant});

  @override
  _MenuState createState() => _MenuState(this.restaurant);
}

class _MenuState extends State<Menu> {
  var res_name;
  var res_id;

  var menu;

  void initState() {
    // _getRestaurantMenu();
    super.initState();
  }

  _MenuState(Restaurant restaurant) {
    this.res_name = restaurant.name;
    this.res_id = restaurant.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xff7c4ad9),
        elevation: 10,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (String result) {
              switch (result) {
                case 'logout':
                  _logout();
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

      body: Center(
        child: _menuData(res_id),
      ),
    );
  }

  void _logout() async{
    print('logging out...');
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if(body['success']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> Login()));
    }
  }
}

FutureBuilder _menuData(id){
  return FutureBuilder<List<MenuModel>>(
    future: getMenus(id),
    builder: (BuildContext context, AsyncSnapshot<List<MenuModel>> snapshot){
      if (snapshot.hasData) {
        List<MenuModel>? data = snapshot.data;
        if ((data!.length > 0) && (data[0].id != null)) {
          return _menus(data);
        }
        else {
          return _categories(data[0].categories);
        }
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
    },
  );
}

Future<List<MenuModel>> getMenus(id) async {
  print('getting menus...');
  List<MenuModel> menus = [];
  var res = await Network().getDataWithoutToken('/restaurants/$id/menu');
  var body = json.decode(res.body);

  // Menus present
  if (body['success']) {
    var data = body['result'];
    for (var menu in data) {
      var categories = menu['categories'];
      List<MenuCategory> menuCategory = [];

      for (var category in categories) {
        var items = category['items'];
        List<CategoryItem> categoryItems = [];

        for (var item in items) {
          categoryItems.add(
            CategoryItem(
              id: item['id'],
              restaurantId: item['restaurant_id'],
              categoryId: item['category_id'],
              name: item['name'],
              description: item['description'],
              price: item['price'],
              soldOut: item['soldout'],
              position: item['position']
            ),
          );
        }

        menuCategory.add(
          MenuCategory(
            id: category['id'],
            restaurantId: category['restaurant_id'],
            name: category['name'],
            position: category['position'],
            items: categoryItems,
          ),
        );
      }

      menus.add(
          MenuModel(
            id: menu['id'],
            name: menu['name'],
            startsAt: menu['startsAt'],
            endsAt: menu['endsAt'],
            isAvailable: menu['isAvailable'],
            categories: menuCategory,
          )
      );
    }
    return menus;
  }

  // No menus present
  else {
    var data = body['result'][0];

    var categories = data['categories'];
    List<MenuCategory> menuCategory = [];

    for (var category in categories) {
      var items = category['items'];
      List<CategoryItem> categoryItems = [];

      for (var item in items) {
        categoryItems.add(
          CategoryItem(
              id: item['id'],
              restaurantId: item['restaurant_id'],
              categoryId: item['category_id'],
              name: item['name'],
              description: item['description'],
              price: item['price'],
              soldOut: item['soldout'],
              position: item['position']
          ),
        );
      }

      menuCategory.add(
        MenuCategory(
          id: category['id'],
          restaurantId: category['restaurant_id'],
          name: category['name'],
          position: category['position'],
          items: categoryItems,
        ),
      );
    }

    menus.add(
        MenuModel(
          id: null,
          name: null,
          startsAt: null,
          endsAt: null,
          isAvailable: null,
          categories: menuCategory,
        ),
    );
    return menus;
  }
}

ListView _menus(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              _tile(data[index].name, Icons.dining),

              GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(1),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                ),
                itemBuilder: (context, index2) =>
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    elevation: 0.0,
                    color: Color(0xffd2d2d2),
                    onPressed: () {
                      print(data[index].categories[index2].items);
                    },
                    child: Center(
                      child: MenuCategoryCard(
                        menuCategory: data[index].categories[index2],
                      ),
                    )
                  ),
                ),
                itemCount: data[index].categories.length,
              ),
            ],
          ),
            // child: _tile(data[index].name, data[index].categories, Icons.work)
        );
      }
  );
}

ListTile _tile(String name, IconData icon) {
  return ListTile(
    title: Text(name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}

ListView _categories(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              _tile(data[index].name, Icons.dining),

              GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(1),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                ),
                itemBuilder: (context, index2) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          elevation: 0.0,
                          color: Color(0xffd2d2d2),
                          onPressed: () {

                          },
                          child: Center(
                            child: Center(
                              child: Text(
                                data[index].items[index2].name,
                              ),
                            )
                          )
                      ),
                    ),
                itemCount: data[index].items.length,
              ),
            ],
          ),
          // child: _tile(data[index].name, data[index].categories, Icons.work)
        );
      }
  );
}