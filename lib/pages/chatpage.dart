import 'dart:io';

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/messages.dart';
import 'package:chat_app/models/userprofile.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:chat_app/services/dta_serveice.dart';
import 'package:chat_app/services/media_service.dart';

import 'package:chat_app/services/strage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
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
  late DataService _dataService;
  late MediaService _mediaService;
  late StorageService _storageService;
  ChatUser? currentuser, otheruser;

  @override
  void initState() {
    super.initState();
    _authService = GetIt.instance.get<AuthService>();
    currentuser = ChatUser(
        id: _authService.user!.uid, firstName: _authService.user!.displayName);
    otheruser = ChatUser(
        id: widget.user.uid!,
        firstName: widget.user.name,
        profileImage: widget.user.pfpURL!);
    _dataService = GetIt.instance.get<DataService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _storageService = GetIt.instance.get<StorageService>();
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
    return StreamBuilder(stream: _dataService.getChats(currentuser!.id, otheruser!.id), builder: (context,snapshot){
      Chat? chat= snapshot.data?.data();
      List<ChatMessage> messages = chat?.messages?.map((e) {
  if (e.messageType == MessageType.Text) {
    return ChatMessage(
      text: e.content!,
      user: e.senderID == currentuser!.id ? currentuser! : otheruser!,
      createdAt: e.sentAt!.toDate(),
    );
  } else {

    return ChatMessage(
      medias: [
        ChatMedia(
          url: e.content!,
          fileName: 'Image',
          type: MediaType.image,
        )
      ],
      user: e.senderID == currentuser!.id ? currentuser! : otheruser!,
      createdAt: e.sentAt!.toDate(),
    );
  }
}).toList() ?? [];

      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return DashChat(
      messageOptions: const MessageOptions(
        showOtherUsersAvatar: true,
        showTime: true,
        
      ),
      inputOptions:InputOptions(
        alwaysShowSend: true,
        sendOnEnter: true,
        trailing: [
          mediaButton(),
        ],
      ),
      
      currentUser: currentuser!,
      onSend: sendMessage,
      messages: messages,
    );
    });
  }

  Future<void> sendMessage(ChatMessage chatmessage) async {
    Message message = Message(
      senderID: currentuser!.id,
      content: chatmessage.text,
      messageType: MessageType.Text,
      sentAt: Timestamp.fromDate(chatmessage.createdAt),
    );
    await _dataService.addMessage(currentuser!.id, otheruser!.id, message);
  }
  Widget mediaButton(){
    return IconButton(
      icon: const Icon(Icons.attach_file),
      onPressed: () async{
        File? img =await _mediaService.getImage();
        if(img!=null){
          String? url = await _storageService.uploadChatImg(file: img, chatId: currentuser!.id);
          if(url!=null){
            Message message = Message(
              senderID: currentuser!.id,
              content: url,
              messageType: MessageType.Image,
              sentAt: Timestamp.now(),
            );
            await _dataService.addMessage(currentuser!.id, otheruser!.id, message);
          }
        }
      },
    );
  }
}
