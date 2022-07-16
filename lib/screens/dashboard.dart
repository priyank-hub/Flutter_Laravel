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
  var restaurants = [];

  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text('Restaurants');

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

  @override
  Widget build(BuildContext context) {
    // final ButtonStyle style = TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    int currentPage = 0;

    var categories = [
      Category(
        name: 'BBQ',
        image: 'assets/images/bbq-01.png',
      ),
      Category(
        name: 'Breakfast',
        image: 'assets/images/breakfast-01.png',
      ),
      Category(
        name: 'Burgers',
        image: 'assets/images/burgers-01.png',
      ),
      Category(
        name: 'Cafe',
        image: 'assets/images/cafe-01.png',
      ),
      Category(
        name: 'Caribbean',
        image: 'assets/images/carribean-01.png',
      ),
      Category(
        name: 'Chinese',
        image: 'assets/images/chinese-01.png',
      ),
      Category(
        name: 'Desserts',
        image: 'assets/images/desserts-01.png',
      ),
      Category(
        name: 'FastFood',
        image: 'assets/images/fastfood-01.png',
      ),
      Category(
        name: 'Healthy',
        image: 'assets/images/healthy-01.png',
      ),
      Category(
        name: 'Japanese',
        image: 'assets/images/japanese-01.png',
      ),
      Category(
        name: 'Kosher',
        image: 'assets/images/kosher-01.png',
      ),
      Category(
        name: 'Vegetarian',
        image: 'assets/images/vegetarian-01.png',
      ),
      Category(
        name: 'Vietnamese',
        image: 'assets/images/vietnamese-01.png',
      ),
    ];

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
                  customIcon = Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    // leading: Icon(
                    //   Icons.search,
                    //   color: Colors.white,
                    //   size: 28,
                    // ),
                    title: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        border: InputBorder.none,
                        hintText: 'search for restaurant...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
                else {
                  customIcon = Icon(Icons.search);
                  customSearchBar = Text('Dashboard');
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(categories.length, (int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 0.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.15,
                              child: Image.asset(
                                categories[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            categories[index].name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    }),
                  )
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
          mobileBackground: restaurant['mobile_background'],
          // description: restaurant['description'],
          tags: restaurant['tags'],
          isOpenNow: restaurant['isOpenNow'],
          orderTypes: restaurant['order_types'],
          openingHours: restaurant['openingHours'],
        )
    );
  }
  return restaurants;
}

Widget _restaurants(data) {

  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount:data.length,
    itemBuilder: (context,index){
      return  InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0.0,
          child: Column(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)), //add border radius
                  child: Image.network(
                    data[index].image,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              ListTile(
                title: Text(data[index].name),
                subtitle: Text(data[index].tags),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: Menu(
                    restaurant: data[index],
                  )
              )
          );
        },
      );
    }
  );
}