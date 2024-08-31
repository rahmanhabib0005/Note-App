import 'package:fetch_apis/add_title.dart';
import 'package:fetch_apis/registration_page.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  State<Loginpage> createState() => LoginState();
}

class LoginState extends State<Loginpage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getValue();
  }

  // void getValue() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token');
  //   print(token);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
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
                InkWell(
                  child: const Text("Create an account?"),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()));
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

                      var email = emailController.text.toString();
                      var password = passwordController.text.toString();

                      var response = await UserApi.loginUser(email, password);

                      dynamic token;
                      if (response != null && response['success'] == true) {
                        var getToken = response['token']['token'];
                        token = getToken;
                      }

                      if (token != null) {
                        var prefs = await SharedPreferences.getInstance();
                        // prefs.setBool(SplashState.KEYLOGIN, true);
                        prefs.setString('token', token);
                        prefs.setString(
                            'loggedinUser', response['user']['id'].toString());
                        UserApi.setToken(token);
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddTitle()));
                      } else {
                        Navigator.of(context).pop();

                        dynamic text;
                        if (response != null) {
                          text = response['message'];
                        }

                        UserApi.dialogBox(context, text);
                      }
                    },
                    child: const Text('Login')),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }
}
