import 'dart:async';
import 'package:fetch_apis/chatroom/chatroom.dart';
import 'package:fetch_apis/chatroom/chooseroom.dart';
import 'package:fetch_apis/login_page.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Center(
            child: Icon(
          Icons.account_circle,
          size: 100,
          color: Colors.white70,
        )),
      ),
    );
  }

  void fetchUser() async {
    // await UserApi.checkInternetConnnection();
    var prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    var tokenValue = prefs.getString('token');

    if (tokenValue != "null" || tokenValue == null) {
      UserApi.setToken(tokenValue);
    }

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => tokenValue == "null" || tokenValue == null
                  ? Loginpage()
                  // ? const Chatroom()
                  : const Chooseroom()
                  // : const Chatroom()
              // : const AddTitle()

              ));
    });
  }
}
