import 'dart:convert';

import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/screens/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../api/api.dart';
import '../models/menuModel.dart';

class RestaurantCard extends StatelessWidget {

  RestaurantCard({required this.restaurant});
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0), //add border radius
              child: Image.asset(
                'assets/images/default-image.png',
                fit:BoxFit.cover,
              ),
            ),
            Text(
              restaurant.name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: Menu(
                      restaurant: restaurant,
                    )
                )
            );
        },
      ),
    );
  }

  // Future<MenuModel> _getMenus() async {
  //   MenuModel menus;
  //   var id = restaurant.id;
  //   var res = await Network().getDataWithoutToken('/restaurants/$id/menu');
  //   var body = json.decode(res.body);
  //   var data = body['data'][0];
  //
  //   menus = MenuModel(
  //     id: data['id'],
  //     name: data['name'],
  //     startsAt: data['startsAt'],
  //     endsAt: data['endsAt'],
  //     isAvailable: data['isAvailable'],
  //     // categories: data['categories']
  //   );
  //
  //   return menus;
  // }
}