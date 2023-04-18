import 'package:flutter/material.dart';
import 'package:rmb/Model/ChatModel.dart';
import 'package:rmb/Pages/CameraPage.dart';
import 'package:rmb/Pages/ChatPage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen(
      {super.key, required this.chatModels, required this.sourceChat});
  final List<ChatModel> chatModels;
  final ChatModel sourceChat;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
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
            Text('Status'),
            Text('Call'),
          ],
        ),
      ),
    );
  }
}
