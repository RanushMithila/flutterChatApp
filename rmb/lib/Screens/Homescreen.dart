import 'package:flutter/material.dart';
import 'package:rmb/Model/ChatModel.dart';
import 'package:rmb/Pages/CameraPage.dart';
import 'package:rmb/Pages/ChatPage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:pointycastle/pointycastle.dart';

import '../sqlite/Database.dart';
import '../sqlite/KeyModel.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({
    super.key,
    required this.chatModels,
    required this.sourceChat,
  });
  final List<ChatModel> chatModels;
  final ChatModel sourceChat;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late DB db;
  late IO.Socket socket;
  List<KeyModel> keys = [];

  @override
  void initState() {
    super.initState();
    db = DB();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('RMB'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                print(value);
              },
              itemBuilder: (BuildContext context) {
                //in here I change little bit
                //https://youtu.be/7H7i1TBIB7E?t=168
                return {
                  'New Group',
                  'New Broadcast',
                  'WhatsApp Web',
                  'Starred Messages',
                  'Settings'
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CameraPage(),
            ChatPage(
              chatModels: widget.chatModels,
              sourceChat: widget.sourceChat,
            ),
            Center(child: Text('Status')),
            Center(child: Text('Call')),
          ],
        ),
      ),
    );
  }

  void connect() {
    // print("Now I'm executing connect() function");
    socket = IO.io(
      'http://192.168.43.180:5000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket.connect();
    socket.onConnect((data) {
      print("Connected");
      getKeys();
    });

    socket.onConnectError((data) {
      print("Error while establishing connection...");
    });

    if (!socket.connected) {
      print("Not connected. Retying...");
      socket.connect();
    }
    print(socket.connected);
    socket.emit("signin", widget.sourceChat.id);
  }

  void getKeys() async {
    db.getKey().then((value) {
      print("value: ");
      print(value[0].publicKey);
      keys = value;
      if (keys.isNotEmpty) {
        try {
          socket.emit("pubKey", {
            "userID": widget.sourceChat.id,
            "PublicKey": keys[0].publicKey,
          });
          socket.disconnect();
        } catch (e) {
          print(e);
        }
      }
    });
    // print(user[0].username);
  }
}
