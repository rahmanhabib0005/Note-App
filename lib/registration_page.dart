import 'dart:convert';

import 'package:fetch_apis/add_title.dart';
import 'package:fetch_apis/login_page.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => RegisterState();
}

class RegisterState extends State<RegistrationPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(21.0),
                  child: Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      label: const Text('Name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                      fillColor: Colors.amber),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      label: const Text('E-mail'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                      fillColor: Colors.amber),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                      label: const Text('Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                      fillColor: Colors.amber),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cPasswordController,
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                      label: const Text('Confirm Password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                      fillColor: Colors.amber),
                ),
                InkWell(
                  child: const Text("Back to Login?"),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Loginpage()));
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });

                      var name = nameController.text.toString();
                      var email = emailController.text.toString();
                      var password = passwordController.text.toString();
                      var cPassword = cPasswordController.text.toString();

                      var response = await UserApi.register(
                          name, email, password, cPassword);

                      dynamic token;
                      if (response != null && response['success'] == true) {
                        var getToken = response['token']['token'];
                        token = getToken;
                      }

                      if (token != null) {
                        var prefs = await SharedPreferences.getInstance();
                        // prefs.setBool(SplashState.KEYLOGIN, true);
                        prefs.setString('token', token);
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddTitle()));
                      } else {
                        Navigator.of(context).pop();

                        dynamic text;
                        final errors =
                            response['errors'] as Map<String, dynamic>;
                        text = errors.entries
                            .map((entry) => entry.value is List
                                ? (entry.value as List).join('\n')
                                : entry.value)
                            .join('\n\n');

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 250, // Minimum height
                                  maxWidth:
                                      300, // Maximum width (you can adjust this as needed)
                                ),
                                child: Material(
                                  color: Colors
                                      .transparent, // This ensures the background color is set properly
                                  child: Container(
                                    color: Colors.white,
                                    child: Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.warning,
                                                size: 50,
                                                color: Colors
                                                    .orange, // Optional: color for the icon
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Text(
                                                  text.isEmpty
                                                      ? 'API didn\'t respond!'
                                                      : text,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign
                                                      .center, // Center-align text
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      // var prefs = await SharedPreferences.getInstance();
                      // prefs.setString('token', token);

                      // Navigator.of(context).pop();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const AddTitle()));
                    },
                    child: const Text('Submit')),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }
}
