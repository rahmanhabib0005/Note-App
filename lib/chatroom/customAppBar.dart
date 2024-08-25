import 'package:fetch_apis/login_page.dart';
import 'package:fetch_apis/provider/user_provider.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customappbar {
  static appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Center(
          child: Column(
        children: [
          Text(
            context.watch<Userprovider>().name.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          InkWell(
            child: const Icon(Icons.logout),
            onTap: () async {
              var isTrue = await UserApi.logout();
              if (isTrue == true) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Loginpage()));
              } else {
                UserApi.dialogBox(context, 'Api didn\'t respond! ');
              }
            },
          )
        ],
      )),
    );
  }
}
