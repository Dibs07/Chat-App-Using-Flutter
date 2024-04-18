import 'package:chat_app/models/userprofile.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserProfile user;
  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late AuthService _authService;
  ChatUser? currentuser, otheruser;
  
  @override
  void initState() {
    super.initState();
    _authService = GetIt.instance.get<AuthService>();
    currentuser = ChatUser(
        uid: _authService.user!.uid, firstName: _authService.user!.displayName);
    otheruser = ChatUser(uid: widget.user.uid, firstName: widget.user.name, avatar: widget.user.pfpURL!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.user.pfpURL!),
              ),
            ),
            Text(widget.user.name!),
          ],
        ),
      ),
      body: buildUi(),
    );
  }

  Widget buildUi() {
    return Container();
  }
}
