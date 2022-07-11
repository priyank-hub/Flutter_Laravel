

import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
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

  // _getRestaurantMenu() async {
  //   print('getting menus...');
  //   var res = await Network().getDataWithoutToken('/restaurants/$res_id/menu');
  //   var body = json.decode(res.body);
  //   var data = body['data'][0];
  //
  //   this.menu = MenuModel(
  //       id: data['id'],
  //       name: data['name'],
  //       startsAt: data['startsAt'],
  //       endsAt: data['endsAt'],
  //       isAvailable: data['isAvailable'],
  //       // categories: data['categories']
  //     );
  // }

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
        return _menus(data);
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
  var res = await Network().getDataWithoutToken('/restaurants/$id/menus');
  var body = json.decode(res.body);
  var data = body['data'];

  for (var menu in data) {
    menus.add(
          MenuModel(
            id: menu['id'],
            name: menu['name'],
            startsAt: menu['startsAt'],
            endsAt: menu['endsAt'],
            isAvailable: menu['isAvailable'],
            // categories: data['categories']
          )
      );
  }

  return menus;
}

ListView _menus(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
            child: _tile(data[index].name, Icons.work)
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