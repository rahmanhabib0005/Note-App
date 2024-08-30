import 'package:fetch_apis/chatroom/customAppBar.dart';
import 'package:fetch_apis/model/chat.dart';
import 'package:fetch_apis/services/user_api.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({super.key, this.chatRoomId});

  final dynamic chatRoomId;

  @override
  State<Chatroom> createState() => ChatroomState();
}

class ChatroomState extends State<Chatroom> {
  List<Chat> chats = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    callApi();
  }

  void callApi() async {
    try {
      // Fetch chats from API
      List<Chat> fetchedChats =
          await UserApi.fetchChats(widget.chatRoomId.toString());
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
              userId: "2"));
        });

        // Store the new chat message
        await UserApi.storeChat(widget.chatRoomId.toString(), message);
        _controller.clear();
      } catch (error) {
        print('Error sending message: $error');
      }
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
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final message = chat.message;
                final name = chat.userName;

                final isUserMessage = chat.userId ==
                    "2"; // Example condition to distinguish messages

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
