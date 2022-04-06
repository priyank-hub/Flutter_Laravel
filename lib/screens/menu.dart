

import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/models/restaurant.dart';
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
  _MenuState(Restaurant restaurant) {
    this.res_name = restaurant.name;
  }

  @override
  Widget build(BuildContext context) {
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

      body: Center(
        child: Text(
          'I am Menu on Page of $res_name!!'
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