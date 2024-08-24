import 'package:fetch_apis/add_note.dart';
import 'package:fetch_apis/model/note.dart';
import 'package:fetch_apis/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notes extends StatefulWidget {
  const Notes(this.notes, {super.key});

  final List<Note> notes;
  @override
  State<Notes> createState() => NotesState();
}

class NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Userprovider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.watch<Userprovider>().name.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
            itemCount: widget.notes.length,
            itemBuilder: (context, index) {
              final noteList = widget.notes[index];
              final note = noteList.note;
              final name = noteList.userName;
              return ListTile(
                leading: CircleAvatar(
                  // child: Image.network(image),
                  child: Text("${index + 1}"),
                ),
                subtitle: Text("Note: $note"),
                title: Text(name),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNote()));
          },
          child: const Icon(Icons.note),
        ),
      ),
    );
  }
}
