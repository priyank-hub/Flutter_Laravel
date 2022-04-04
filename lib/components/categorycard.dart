import 'package:auth_flutter/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.2,
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
              image: AssetImage(category.image),
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