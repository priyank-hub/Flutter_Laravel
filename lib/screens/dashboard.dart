import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/restaurant.dart';

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

    var restaurants = [
      Restaurant(
          name: 'Test 1',
          image: 'assets/images/1.jpg',
      ),
      Restaurant(
          name: 'Test 2',
          image: 'assets/images/2.jpeg',
      ),
      Restaurant(
          name: 'Test 3',
          image: 'assets/images/3.jpg',
      ),
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.teal,
        elevation: 0,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return Opacity(
                    opacity: currentPage == index ? 1.0 : 0.8,
                    child: CarouselCard(
                      restaurant: restaurants[index],
                    ),
                  );
                },
                itemCount: restaurants.length,
                controller: PageController(initialPage: 0, viewportFraction: 0.75),
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
            ),
          ],
        ),
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

class CarouselCard extends StatelessWidget {
  CarouselCard({required this.restaurant});

  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: 32.0,
          left: 8.0,
          right: 8.0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white54,
                offset: Offset(0, 20),
                blurRadius: 10.0,
              )
            ],

            image: DecorationImage(
              image: NetworkImage(restaurant.image),
              fit: BoxFit.cover,
            ),
          ),

          child: Column(

          ),
        ),
      ),
    );
  }

}