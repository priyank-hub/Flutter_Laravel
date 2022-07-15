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
              child: Image.network(
                restaurant.image,
                fit: BoxFit.cover,
                height: 120,
              ),
            ),
            Flexible(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 0.0, right: 0.0, bottom: 0.0),
                  child: Text(
                    restaurant.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
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
}