import 'package:fetch_apis/notes.dart';
import 'package:fetch_apis/provider/user_provider.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => AddNotesState();
}

class AddNotesState extends State<AddNote> {
  var noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Userprovider()),
      ],
      child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                context.watch<Userprovider>().name.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.blue,
          ),
          body: Center(
            child: Container(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.name,
                    controller: noteController,
                    maxLength: 255,
                    decoration: InputDecoration(
                        label: const Text("Write a Note..."),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        fillColor: Colors.amber),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });

                        saveNote();
                      },
                      child: const Text('Save Note'))
                ],
              ),
            ),
          )),
    );
  }

  void saveNote() async {
    var note = noteController.text.toString();
    var status = await UserApi.addNote(note);

    if (status == true) {
      var response = await UserApi.fetchNotes();
      Navigator.of(context).pop();
      if (response.isNotEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Notes(response)));
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
        //                   style: TextStyle(fontSize: 20, color: Colors.red),
        //                 ),
        //               ]),
        //         ),
        //       );
        //     });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                color: Colors.white,
                width: 300,
                height: 200,
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                      ),
                      Text(
                        'Api didn\'t respond! ',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ]),
              ),
            );
          });
    }
    Navigator.of(context).pop();
  }
}
