import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/components/categorycard.dart';
import 'package:auth_flutter/components/restaurantcard.dart';
import 'package:auth_flutter/models/category.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/screens/login.dart';
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
  void initState(){
    _loadUserData();
    super.initState();
  }
  _loadUserData() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if(user != null) {
      setState(() {
        name = user['name'];
      });
    }
  }

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

    var restaurants = [
      Restaurant(
        name: 'Test 11',
        image: 'assets/images/1.jpg',
      ),
      Restaurant(
        name: 'Test 2',
        image: 'assets/images/2.jpg',
      ),
      Restaurant(
        name: 'Test 3',
        image: 'assets/images/3.jpg',
      ),
      Restaurant(
        name: 'Test 1',
        image: 'assets/images/1.jpg',
      ),
      Restaurant(
        name: 'Test 2',
        image: 'assets/images/2.jpg',
      ),
      Restaurant(
        name: 'Test 3',
        image: 'assets/images/3.jpg',
      ),
      Restaurant(
        name: 'Test 3',
        image: 'assets/images/3.jpg',
      ),
      Restaurant(
        name: 'Test 2',
        image: 'assets/images/2.jpg',
      ),
      Restaurant(
        name: 'Test 3',
        image: 'assets/images/3.jpg',
      ),
      Restaurant(
        name: 'Test 3',
        image: 'assets/images/3.jpg',
      ),
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xffae4ad9),
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

      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView (
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
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
                  controller: PageController(initialPage: 0, viewportFraction: 0.35),
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'Restaurants',
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10.0),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(1),

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2
                  ),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)
                      ),
                      elevation: 0.0,
                      color: Color(0xffd78df7),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: Menu(
                                  restaurant: restaurants[index],
                                )
                            )
                        );
                      },
                      child: RestaurantCard(
                        restaurant: restaurants[index],
                      ),
                    ),
                  ),
                  itemCount: restaurants.length,
                ),
              )
            ],
          ),
        )

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