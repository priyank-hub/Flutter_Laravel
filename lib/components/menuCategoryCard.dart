import 'package:auth_flutter/models/menuCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCategoryCard extends StatelessWidget {

  MenuCategoryCard({required this.menuCategory});
  MenuCategory menuCategory;

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
            Text(
              menuCategory.name,
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