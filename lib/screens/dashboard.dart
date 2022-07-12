import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/components/categorycard.dart';
import 'package:auth_flutter/components/restaurantcard.dart';
import 'package:auth_flutter/models/category.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/screens/login.dart';
import 'package:auth_flutter/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'menu.dart';



class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var name;
  var restaurants = [];

  void initState() {
    _loadUserData();
    // _getRestaurants();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        name = user['name'];
      });
    }
  }

  // _getRestaurants() async {
  //   print('getting restaurants...');
  //   var res = await Network().getDataWithoutToken('/restaurants');
  //   var body = json.decode(res.body);
  //   for (var restaurant in body['restaurants']['data']) {
  //     restaurants.add(
  //       Restaurant(
  //         id: restaurant['id'],
  //         name: restaurant['name'],
  //         image: restaurant['image'],
  //       ),
  //     );
  //     // print(restaurant);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final ButtonStyle style = TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    int currentPage = 0;

    var categories = [
      Category(
        name: 'Test 1',
        image: 'assets/images/bbq-01.png',
      ),
      Category(
        name: 'Test 2',
        image: 'assets/images/breakfast-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/burgers-01.png',
      ),
      Category(
        name: 'Test 1',
        image: 'assets/images/cafe-01.png',
      ),
      Category(
        name: 'Test 2',
        image: 'assets/images/carribean-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/chinese-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/desserts-01.png',
      ),
      Category(
        name: 'Test 2',
        image: 'assets/images/fastfood-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/healthy-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/japanese-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/kosher-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/vegetarian-01.png',
      ),
      Category(
        name: 'Test 3',
        image: 'assets/images/vietnamese-01.png',
      ),
    ];

    Icon customIcon = const Icon(Icons.search);
    Widget customSearchBar = Text('Dashboard');

    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff7c4ad9),
        elevation: 10,
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.person,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         PageTransition(
          //             type: PageTransitionType.rightToLeft,
          //             child: Profile(),
          //         )
          //     );
          //   },
          // ),

          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  print('search bar');
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = const ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                        hintText: 'search for restaurant...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('Dashboard');
                }
              });
            },
            icon: customIcon,
          ),

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
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),

      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  width: double.infinity,
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      return Opacity(
                        opacity: 0.8,
                        child: CategoryCard(
                          category: categories[index],
                        ),
                      );
                    },
                    itemCount: categories.length,
                    controller: PageController(
                        initialPage: 1, viewportFraction: 0.40),
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    bottom: 15.0,
                  ),
                  child: Text(
                    'Restaurants',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _restaurantData(),

                // GridView.builder(
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   primary: false,
                //   padding: const EdgeInsets.all(1),
                //
                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2
                //   ),
                //   itemBuilder: (context, index) =>
                //       // Padding(
                //       //   padding: const EdgeInsets.all(8.0),
                //       //   child: RaisedButton(
                //       //     shape: RoundedRectangleBorder(
                //       //         borderRadius: BorderRadius.circular(12.0)
                //       //     ),
                //       //     elevation: 0.0,
                //       //     color: Color(0xff7c4ad9),
                //       //     onPressed: () {
                //       //       Navigator.push(
                //       //           context,
                //       //           PageTransition(
                //       //               type: PageTransitionType.rightToLeft,
                //       //               child: Menu(
                //       //                 restaurant: restaurants[index],
                //       //               )
                //       //           )
                //       //       );
                //       //     },
                //       //     child: RestaurantCard(
                //       //       restaurant: restaurants[index],
                //       //     ),
                //       //   ),
                //       // ),
                //     RestaurantCard(
                //     restaurant: restaurants[index],
                //   ),
                //   itemCount: restaurants.length,
                // )
              ],
            ),
          )

      ),
    );
  }

  void _logout() async {
    var res = await Network().getData('/userLogout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login())
      );
    }
  }
}

FutureBuilder _restaurantData(){
  return FutureBuilder<List>(
    future: getRestaurants(),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot){
      if (snapshot.hasData) {
        List? data = snapshot.data;
        return _restaurants(data);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}

Future<List> getRestaurants() async {
  print('getting restaurants...');
  List restaurants = [];
  var res = await Network().getDataWithoutToken('/restaurants');
  var body = json.decode(res.body);
  var data = body['restaurants']['data'];
  for (var restaurant in data) {
    restaurants.add(
        Restaurant(
          id: restaurant['id'],
          name: restaurant['name'],
          image: restaurant['image'],
        )
    );
  }
  return restaurants;
}

GridView _restaurants(data) {
  return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(1),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
      ),
      itemBuilder: (context, index) {
        return RestaurantCard(
            restaurant: data[index],
        );
      }
  );
}