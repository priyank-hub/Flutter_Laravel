import 'package:auth_flutter/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({required this.category});

  Category category;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8.0,
          right: 8.0,
        ),
        child: Column(
          children: [
            Container(
              child: Image(
                image: AssetImage(category.image),
                fit: BoxFit.cover,
                height: 130.0,
              ),
            ),

            Text(
              category.name,
              style: GoogleFonts.poppins(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}