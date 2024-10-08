import 'package:fetch_apis/chatroom/chatroom.dart';
import 'package:fetch_apis/chatroom/customAppBar.dart';
import 'package:fetch_apis/main.dart';
import 'package:fetch_apis/model/rooms.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';

class Chooseroom extends StatefulWidget {
  const Chooseroom({super.key});

  @override
  State<Chooseroom> createState() => ChooseroomState();
}

class ChooseroomState extends State<Chooseroom> {
  List<Rooms> rooms = [];

  @override
  void initState() {
    super.initState();
    callApi();
  }

  void callApi() async {
    try {
      // Fetch chats from API
      List<Rooms> fetchedChats = await UserApi.fetchRooms();
      setState(() {
        rooms = fetchedChats;
      });
    } catch (error) {
      print('Error fetching chats: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Customappbar.appBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final name = room.roomName;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chatroom(
                                  chatRoomId: room.roomId,
                                )));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      // child: Image.network(image),
                      child: Text("${index + 1}"),
                    ),
                    title: Text(name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MyHomePage()));
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
