import 'package:auth_flutter/models/restaurant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantCard extends StatelessWidget {

  RestaurantCard({required this.restaurant});
  Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.0,
      color: Colors.teal[100],
      child: Center(
        child: Text(
          restaurant.name,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      // child: Padding(
      //   padding: EdgeInsets.all(4.0),
      //   child: Container(
      //     padding: const EdgeInsets.all(8),
      //     child: Text(
      //         restaurant.name
      //     ),
      //   ),
      // ),
    );
  }

}