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
  bool isSent = false;
  late DB db;
  late IO.Socket socketPub;
  List<KeyModel> keys = [];

  @override
  void initState() {
    super.initState();
    db = DB();
    connectServer();
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

  void connectServer() {
    // print("Now I'm executing connect() function");
    socketPub = IO.io(
      // 'http://10.10.55.145:5000',
      'http://192.168.43.180:5000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socketPub.connect();
    socketPub.onConnect((data) {
      print("Connected");
      getKeys();
    });

    socketPub.onConnectError((data) {
      print("Error while establishing connection...");
    });

    if (!socketPub.connected) {
      print("Not connected. Retying...");
      socketPub.connect();
    }
    print(socketPub.connected);
    socketPub.emit("signin", widget.sourceChat.id);
  }

  void getKeys() async {
    db.getKey().then((value) {
      print("value: ");
      print(value[0].publicKey);
      keys = value;
      if (keys.isNotEmpty && !isSent) {
        try {
          socketPub.emit("pubKey", {
            "userID": widget.sourceChat.id,
            "PublicKey": keys[0].publicKey,
          });
          isSent = true;
          socketPub.disconnect();
          socketPub.destroy();
        } catch (e) {
          print(e);
        }
      }
    });
    // print(user[0].username);
  }
}
