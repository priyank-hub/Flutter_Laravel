import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/components/categorycard.dart';
import 'package:auth_flutter/components/restaurantcard.dart';
import 'package:auth_flutter/models/category.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/providers/cartProvider.dart';
import 'package:auth_flutter/screens/login.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'checkout.dart';
import 'menu.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var name;
  var restaurants = [];
  var latitude = null;
  var longitude = null;
  var categoryClicked = '';

  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text(
    'Restaurants',
  );

  void initState() {
    _loadUserData();

    // _loadUserPosition();
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
        value: 'BBQ',
        image: 'assets/images/bbq-01.png',
      ),
      Category(
        name: 'Breakfast',
        value: 'Breakfast',
        image: 'assets/images/breakfast-01.png',
      ),
      Category(
        name: 'Burgers',
        value: 'Burgers',
        image: 'assets/images/burgers-01.png',
      ),
      Category(
        name: 'Cafe',
        value: 'Cafe',
        image: 'assets/images/cafe-01.png',
      ),
      Category(
        name: 'Caribbean',
        value: 'Caribbean',
        image: 'assets/images/carribean-01.png',
      ),
      Category(
        name: 'Chinese',
        value: 'Chinese',
        image: 'assets/images/chinese-01.png',
      ),
      Category(
        name: 'Desserts',
        value: 'Dessert',
        image: 'assets/images/desserts-01.png',
      ),
      Category(
        name: 'FastFood',
        value: 'Fast Food',
        image: 'assets/images/fastfood-01.png',
      ),
      Category(
        name: 'Healthy',
        value: 'Healthy',
        image: 'assets/images/healthy-01.png',
      ),
      Category(
        name: 'Japanese',
        value: 'Japanese',
        image: 'assets/images/japanese-01.png',
      ),
      Category(
        name: 'Kosher',
        value: 'Kosher',
        image: 'assets/images/kosher-01.png',
      ),
      Category(
        name: 'Vegetarian',
        value: 'Vegetarian',
        image: 'assets/images/vegetarian-01.png',
      ),
      Category(
        name: 'Vietnamese',
        value: 'Vietnamese',
        image: 'assets/images/vietnamese-01.png',
      ),
      Category(
        name: 'All',
        value: '',
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
                } else {
                  customIcon = Icon(Icons.search);
                  customSearchBar = Text('Dashboard');
                }
              });
            },
            icon: customIcon,
          ),
          Container(
            child: Consumer<CartProvider>(
              builder: (context, model, _) {
                return Badge(
                  badgeContent: Text(
                    model.getCounter().toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  position: const BadgePosition(start: 30, bottom: 30),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Checkout(),
                          ));
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                );
              },
            ),
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
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                        return InkWell(
                          child: Column(
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
                                  width:
                                      MediaQuery.of(context).size.height * 0.15,
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
                          ),
                          onTap: () {
                            print(categories[index].value);
                            setState(() {
                              categoryClicked = categories[index].value;
                            });
                          },
                        );
                      }),
                    )),
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
          )),
    );
  }

  void _logout() async {
    var res = await Network().getData('/userLogout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('service enabled $serviceEnabled');
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     return Future.error('Location permissions are denied');
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   return Future.error(
    //       'Location permissions are permanently denied, we cannot request permissions.');
    // }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  FutureBuilder _restaurantData() {
    print('getting restaurant data...');
    return FutureBuilder<List>(
      future: getRestaurants(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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

    Position currentLocation = await _determinePosition();
    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;

    List restaurants = [];
    var res;
    if (latitude != null && longitude != null) {
      res = await Network().getDataWithoutToken(
          '/restaurants?latitude=$latitude&longitude=$longitude&search=$categoryClicked');
    } else {
      res = await Network()
          .getDataWithoutToken('/restaurants?search=$categoryClicked');
    }

    var body = json.decode(res.body);
    var data = body['restaurants']['data'];
    for (var restaurant in data) {
      restaurants.add(Restaurant(
        id: restaurant['id'],
        name: restaurant['name'],
        image: restaurant['image'],
        mobileBackground: restaurant['mobile_background'],
        // description: restaurant['description'],
        tags: restaurant['tags'],
        isOpenNow: restaurant['isOpenNow'],
        orderTypes: restaurant['order_types'],
        openingHours: restaurant['openingHours'],
      ));
    }
    return restaurants;
  }

  Widget _restaurants(data) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0.0,
              child: Column(
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0)), //add border radius
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
                      )));
            },
          );
        });
  }
}
