

import 'dart:convert';
import 'dart:math';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/components/categoryImages.dart';
import 'package:auth_flutter/components/menuCategoryCard.dart';
import 'package:auth_flutter/models/categoryItem.dart';
import 'package:auth_flutter/models/menuCategory.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/models/menuModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  int _currentIndex=0;
  var images = [
    'assets/images/bbq-01.png',
    'assets/images/breakfast-01.png',
    'assets/images/burgers-01.png',
    'assets/images/cafe-01.png',
    'assets/images/carribean-01.png',
    'assets/images/chinese-01.png',
    'assets/images/desserts-01.png',
    'assets/images/fastfood-01.png',
    'assets/images/healthy-01.png',
    'assets/images/japanese-01.png',
    'assets/images/kosher-01.png',
    'assets/images/vegetarian-01.png',
    'assets/images/vietnamese-01.png',
  ];
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
        title: Text(res_name),
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
      backgroundColor: Color(0xffeeeeee),
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
          var items = category['items'], p = 0;
          List<CategoryItem> categoryItems = [];

          for (var item in items) {
            var img = 'https://app.taliuptesting.com/images/default-image.png';
            if (item['media'] != null) {
              img = item['media']?.length > 0 ?? ('https://app.taliuptesting.com/storage/' + item['media'][0]['id'].toString() + '/' + item['media'][0]['file_name']);
            }
            categoryItems.add(
              CategoryItem(
                  id: item['id'],
                  restaurantId: item['restaurant_id'],
                  categoryId: item['category_id'],
                  name: item['name'],
                  description: item['description'],
                  price: item['price'],
                  soldOut: item['soldout'],
                  position: item['position'],
                  image: img,
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
              image: images[p],
            ),
          );
          p++;
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

      var categories = data['categories'], p=0;
      List<MenuCategory> menuCategory = [];

      for (var category in categories) {
        var items = category['items'];
        List<CategoryItem> categoryItems = [];

        for (var item in items) {
          var img = item['media']?.length > 0 ? ('https://app.taliuptesting.com/storage/' + item['media'][0]['id'].toString() + '/' + item['media'][0]['file_name'])
                                            : 'https://app.taliuptesting.com/images/default-image.png';

          categoryItems.add(
            CategoryItem(
                id: item['id'],
                restaurantId: item['restaurant_id'],
                categoryId: item['category_id'],
                name: item['name'],
                description: item['description'],
                price: item['price'],
                soldOut: item['soldout'],
                position: item['position'],
                image: img,
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
            image: images[p],
          ),
        );
        p++;
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
      title: Text(
        name,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      // leading: Icon(
      //   icon,
      //   color: Colors.blue[500],
      // ),
    );
  }

  Container _categories(data) {
    return Container(
      child: Column(
        children: [
          _categoriesSlider(data),

          Flexible(
            child: ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: [
                        _tile(data[index].name, Icons.dining),

                        _items(data[index].items),

                        // GridView.builder(
                        //   scrollDirection: Axis.vertical,
                        //   shrinkWrap: true,
                        //   primary: false,
                        //   padding: const EdgeInsets.all(1),
                        //
                        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 3
                        //   ),
                        //   itemBuilder: (context, index2) =>
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: _item(data[index].items[index2]),
                        //         // child: RaisedButton(
                        //         //     shape: RoundedRectangleBorder(
                        //         //         borderRadius: BorderRadius.circular(12.0)
                        //         //     ),
                        //         //     elevation: 0.0,
                        //         //     color: Color(0xffd2d2d2),
                        //         //     onPressed: () {
                        //         //
                        //         //     },
                        //         //     child: Center(
                        //         //         child: Center(
                        //         //           child: Text(
                        //         //             data[index].items[index2].name,
                        //         //           ),
                        //         //         )
                        //         //     )
                        //         // ),
                        //       ),
                        //   itemCount: data[index].items.length,
                        // ),
                      ],
                    ),
                    // child: _tile(data[index].name, data[index].categories, Icons.work)
                  );
                }
            ),
          ),

          // ScrollSpy(),
        ],
      ),
    );
  }

  Padding _categoriesSlider(data) {
    var res = [];
    for (var category in data) {
      res.add(
          _carouselItem(category),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 0.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 140.0,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          aspectRatio: 3.10,
          viewportFraction: 0.35,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: res.map((card){
          return Builder(
              builder:(BuildContext context){
                return Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: card,
                    elevation: 0.0,
                  ),
                );
              }
          );
        }).toList(),
      ),
    );
  }

  Widget _carouselItem(item) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            item.image,
            height: MediaQuery.of(context).size.height*0.10,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0, bottom: 0.0),
            child: Text(
                item.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.normal
                ),
                textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(items) {

    return ListView.builder(
      primary: false,
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (content, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      width: 100.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0), //add border radius
                        child: Image.network(
                          items[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 0.0, right: 8.0, bottom: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index].name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                padding: EdgeInsets.only(right: 0.0),
                                child: Text(
                                  items[index].description.substring(0, 60) + '...',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black26,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ),

                            ],
                          ),
                        )
                    ),
                  ],
                ),
              )
            ),
          ),
        );
      },
    );
  }
}