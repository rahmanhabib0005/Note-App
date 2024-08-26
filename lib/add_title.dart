import 'package:fetch_apis/login_page.dart';
import 'package:fetch_apis/main.dart';
import 'package:fetch_apis/notes.dart';
import 'package:fetch_apis/provider/user_provider.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTitle extends StatefulWidget {
  const AddTitle({super.key});

  @override
  State<AddTitle> createState() => AddTitleState();
}

class AddTitleState extends State<AddTitle> {
  var titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Userprovider())],
      child: Scaffold(
        appBar: AppBar(
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
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return Center(
                    //         child: Container(
                    //           color: Colors.white,
                    //           width: 300,
                    //           height: 200,
                    //           child: const Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Icon(
                    //                   Icons.warning,
                    //                   size: 50,
                    //                 ),
                    //                 Text(
                    //                   'Api didn\'t respond! ',
                    //                   style: TextStyle(
                    //                       fontSize: 20, color: Colors.red),
                    //                 ),
                    //               ]),
                    //         ),
                    //       );
                    //     });
                  }
                },
              )
            ],
          )),
        ),
        body: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  keyboardType: TextInputType.name,
                  controller: titleController,
                  decoration: InputDecoration(
                      label: const Text("Set Title"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      fillColor: Colors.amber),
                ),
                const SizedBox(
                  height: 11,
                ),
                ElevatedButton(
                    onPressed: () {
                      var title = titleController.text.toString();
                      context.read<Userprovider>().changeName(newName: title);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage()));
                    },
                    child: const Text('Save Title'))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
            setNotes();
          },
          child: const Icon(Icons.network_cell),
        ),
      ),
    );
  }

  void setNotes() async {
    var response = await UserApi.fetchNotes();
    Navigator.of(context).pop();
    if (response != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Notes(response)));
    } else {
      UserApi.dialogBox(context, 'Api didn\'t respond! ');
      
    }
  }
}
