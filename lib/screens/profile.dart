import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(
                    Icons.chevron_left,
                    color: Colors.white
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                  primary: Color(0xffae4ad9), // <-- Button color

                ),
              ),
            ),

            Container(
              // height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: Text(
                  'I am on the Profile Page!',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}