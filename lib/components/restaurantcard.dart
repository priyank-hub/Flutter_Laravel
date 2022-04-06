import 'package:auth_flutter/models/restaurant.dart';
import 'package:auth_flutter/screens/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantCard extends StatelessWidget {

  RestaurantCard({required this.restaurant});
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        restaurant.name,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }

}