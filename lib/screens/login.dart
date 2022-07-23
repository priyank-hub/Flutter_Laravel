import 'dart:convert';

import 'package:auth_flutter/api/api.dart';
import 'package:auth_flutter/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_flutter/screens/dashboard.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email;
  var password;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );

    // _scaffoldKey.currentState?.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 0.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.40,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Container(
                                child: TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onSaved: (String? value) {
                                    email = value;
                                  },
                                  validator: (String? value) {
                                    return EmailValidator.validate(value)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  style: TextStyle(color: Color(0xFF000000)),
                                  cursorColor: Color(0xFF9b9b9b),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.grey,
                                    ),
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF9b9b9b),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onSaved: (String? value) {
                                    password = value;
                                  },
                                  validator: (String? value) {
                                    return (value!.length > 7)
                                        ? null
                                        : "Password must contain atleast 8 characters";
                                  },
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                child: TextButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8,
                                        bottom: 8,
                                        left: 10,
                                        right: 10),
                                    child: Text(
                                      'Login',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Color(0xff5E5BFF),
                                    onSurface: Colors.grey,
                                  ),
//                                      color: Color(0xff7c4ad9),
//                                      disabledColor: Colors.grey,
//                                      shape: new RoundedRectangleBorder(
//                                          borderRadius: new BorderRadius.circular(10.0),
//                                      ),
                                  onPressed: () {
                                    _login();
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => Register()));
                                  },
                                  child: Text(
                                    'Create new Account',
                                    style: TextStyle(
                                      color: Color(0xff5E5BFF),
                                      fontSize: 15.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.validate();
    _formKey.currentState!.save();

    var data = {
      'email': email,
      'password': password,
      'device_name': 'ios',
    };

    var res = await Network().authData(data, '/userLogin');
    var body = json.decode(res.body);
    print(body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
