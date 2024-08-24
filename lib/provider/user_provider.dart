import 'package:flutter/material.dart';

class Userprovider extends ChangeNotifier {
  String? name;

  Userprovider({this.name = "Flutter Api's"});

  void changeName({required String newName}) async {
    name = newName;
    notifyListeners();
  }
}
