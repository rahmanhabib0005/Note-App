import 'package:fetch_apis/chatroom/customAppBar.dart';
import 'package:fetch_apis/model/chat.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({super.key, this.chatRoomId});

  final dynamic chatRoomId;

  @override
  State<Chatroom> createState() => ChatroomState();
}

class ChatroomState extends State<Chatroom> {
  List<Chat> chats = [];
  final TextEditingController _controller = TextEditingController();
  late final String userID;


  // websocket codes
  // final WebsocketService _webSocketService = WebsocketService(
  //     'ws://localhost:8765');
  // Update with your WebSocket server URL

  @override
  void initState() {
    super.initState();
    callApi();
  }

  

  // @override
  // void dispose() {
  //   _webSocketService.dispose();
  //   super.dispose();
  // }


  void callApi() async {
    try {
      // Fetch chats from API
      var prefs = await SharedPreferences.getInstance();
      userID = prefs.getString('loggedinUser')!;
      List<Chat> fetchedChats =
          await UserApi.fetchChats(widget.chatRoomId.toString());

      // _webSocketService.stream.listen((message) {
      //   final newChat = Chat(
      //     message: message,
      //     userName: userID == "2" ? 'Habibur Rahman' : "Habibur",
      //     chatroomId: widget.chatRoomId.toString(),
      //     userId: userID == "2" ? "1" : "2",
      //     isSent: false, // Mark as received message
      //   );
      //   setState(() {
      //     // Only add messages that are not from the current user
      //     if (!newChat.isSent) {
      //       chats.add(newChat);
      //     }
      //   });
      // });

      setState(() {
        chats = fetchedChats;
      });
    } catch (error) {
      print('Error fetching chats: $error');
    }
  }

  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      try {
        // Add the new chat message
        setState(() {
          chats.add(Chat(
              message: message,
              userName: 'Habibur',
              chatroomId: widget.chatRoomId.toString(),
              userId: userID,
              isSent: true));
        });

        // _webSocketService.sendMessage(message);

        // Store the new chat message
        await UserApi.storeChat(widget.chatRoomId.toString(), message);
        _controller.clear();
      } catch (error) {
        print('Error sending message: $error');
      }
    }
  }

  // @override
  // void dispose() {
  //   _pusherService.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Customappbar.appBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final message = chat.message;
                final name = chat.userName;

                final isUserMessage = chat.userId ==
                    userID; // Example condition to distinguish messages

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  alignment: isUserMessage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (!isUserMessage) // Show name only for messages not from the current user
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                              color:
                                  isUserMessage ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
