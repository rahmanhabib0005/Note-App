import 'dart:async';
import 'dart:convert';
import 'package:fetch_apis/model/chat.dart';
import 'package:fetch_apis/model/note.dart';
import 'package:fetch_apis/model/rooms.dart';
import 'package:fetch_apis/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  static const baseUrl = "https://dev.bitbirds.net/habib/api/";
  // static const baseUrl = "http://192.168.0.111/react-api/public/api/";

  static String? token;

  static void setToken(tokenValue) {
    if (tokenValue != null) {
      token = tokenValue.toString();
    }
  }

  static Future checkInternetConnnection() async {
    try {
      final url = Uri.parse("https://google.com");
      final response = await http.get(url);
      final data = response.body;
      return data;
    } catch (e) {
      print(e);
    }
  }

  static Future fetchUsers() async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

      final uri = Uri.parse("${baseUrl}users");
      final response = await http.get(uri, headers: headers);
      final body = response.body;
      final json = jsonDecode(body);
      dynamic transformed;

      if (json is Map<String, dynamic> && json.containsKey('users')) {
        final results = json['users'] as List<dynamic>;

        transformed = results.map((e) {
          return User(email: e['email'], name: e['name']);
        }).toList();
      } else {
        transformed = [];
      }

      return transformed;
    } catch (e) {
      print(e);
    }
  }

  static Future loginUser(username, password) async {
    try {
      final url = Uri.parse("${baseUrl}v1/login");
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      };

      final body =
          jsonEncode(<String, String>{'email': username, 'password': password});
      final response = await http.post(url, headers: headers, body: body);
      final data = response.body;

      // if (jsonDecode(data)['success'] == true) {
      //   var getToken = jsonDecode(data)['token']['token'];
      //   token = getToken;
      //   return token;
      // }

      return jsonDecode(data);
    } catch (e) {
      print(e);
    }
  }

  static Future logout() async {
    try {
      final url = Uri.parse("${baseUrl}v1/logout");
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

      bool status = false;

      final response = await http.post(url, headers: headers);
      final data = response.body;

      if (jsonDecode(data)['success'] == true) {
        var prefs = await SharedPreferences.getInstance();
        prefs.clear();
        status = true;
      }

      return status;
    } catch (e) {
      print(e);
    }
  }

  static Future register(name, username, password, cPassword) async {
    try {
      final url = Uri.parse("${baseUrl}v1/register");
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
      };

      final body = jsonEncode(<String, String>{
        'name': name,
        'email': username,
        'password': password,
        'password_confirmation': cPassword
      });
      final response = await http.post(url, headers: headers, body: body);
      final data = response.body;

      // if (jsonDecode(data)['success'] == true) {
      //   var getToken = jsonDecode(data)['token']['token'];
      //   token = getToken;
      //   return token;
      // }

      return jsonDecode(data);
    } catch (e) {
      print(e);
    }
  }

  // static Future<List<Note>> fetchNotes() async {
  static Future fetchNotes() async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

      final uri = Uri.parse("${baseUrl}v1/note");
      final response = await http.get(uri, headers: headers);
      final body = response.body;
      final json = jsonDecode(body);

      final results = json['notes'] as List<dynamic>;
      dynamic transformed;
      transformed = results.map((e) {
        final noteUser =
            NoteUser(userName: e['user']['name'], email: e['user']['email']);
        return Note(
            note: e['note'],
            userName: noteUser.userName,
            email: noteUser.email);
      }).toList();

      return transformed;
    } catch (e) {
      print(e);
    }
    // return results;
  }

  // static Future<bool> addNote(note) async {
  static Future addNote(note) async {
    try {
      final url = Uri.parse("${baseUrl}v1/note/store");
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

      final body = jsonEncode(<String, String>{'note': note});

      final response = await http.post(url, headers: headers, body: body);
      final data = response.body;

      if (jsonDecode(data)['status'] == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

// ==========================================

  static dialogBox(BuildContext context, text) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              // minHeight: 200, // Minimum height
              maxWidth: 300, // Maximum width (you can adjust this as needed)
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
                            color:
                                Colors.orange, // Optional: color for the icon
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              text.isEmpty ? 'API didn\'t respond!' : text,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center, // Center-align text
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

  /// Flutter ChatRooms Chattings Api's

  static Future makeChatroom(name) async {
    try {
      final url = Uri.parse("${baseUrl}v1/chatroom/store");
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

      dynamic chatroomRes;
      final body = jsonEncode(<String, String>{'name': name});

      final response = await http.post(url, headers: headers, body: body);
      final data = response.body;

      if (jsonDecode(data)['status'] == 200) {
        return chatroomRes = jsonDecode(data)['chatroom'];
      }
      return chatroomRes;
    } catch (e) {
      print(e);
    }
  }

  static Future storeChat(chatroomId, message) async {
    try {
      final url = Uri.parse("${baseUrl}v1/chats/store");
      final headers = <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      };

      dynamic messageRes;
      final body = jsonEncode(
          <String, String>{'chatroom_id': chatroomId, 'message': message});

      final response = await http.post(url, headers: headers, body: body);
      final data = response.body;

      if (jsonDecode(data)['status'] == 200) {
        return messageRes = jsonDecode(data)['message'];
      }
      return messageRes;
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Chat>> fetchChats(chatroomId) async {
    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    final uri = Uri.parse("${baseUrl}v1/chats/${chatroomId.toString()}");

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final body = response.body;
        final Map<String, dynamic> json = jsonDecode(body);

        // Check if 'messages' is a List
        final List<dynamic> messagesJson = json['messages'];

        // Convert JSON list to List<Chat>
        final List<Chat> chats = messagesJson.map((e) {
          return Chat.fromJson(e);
        }).toList();

        return chats;
      } else {
        // Handle the case where the server responds with an error
        throw Exception('Failed to load chats: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching chats: $e');
      return [];
    }
  }

  static Future<List<Rooms>> fetchRooms() async {
    print('ok');
    final headers = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    final uri = Uri.parse("${baseUrl}v1/chatroom");

    try {
      final response = await http.get(uri, headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        final body = response.body;
        print(body);
        final Map<String, dynamic> json = jsonDecode(body);

        // Check if 'messages' is a List
        final List<dynamic> messagesJson = json['rooms'];
        final List<Rooms> rooms = messagesJson.map((e) {
          return Rooms.fromJson(e);
        }).toList();

        return rooms;
      } else {
        // Handle the case where the server responds with an error
        throw Exception('Failed to load chatroms: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching chats: $e');
      return [];
    }
  }
}
