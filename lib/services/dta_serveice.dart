import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/messages.dart';
import 'package:chat_app/models/userprofile.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:chat_app/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late AuthService _authService;
  CollectionReference? _users;
  CollectionReference? _chats;
  void setUp() {
    _users = _db.collection('users').withConverter<UserProfile>(
          fromFirestore: (snapshots, _) => UserProfile.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );
    _chats = _db.collection('chats').withConverter<Chat>(
          fromFirestore: (snapshots, _) => Chat.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (chat, _) => chat.toJson(),
        );
  }

  DataService() {
    setUp();
    _authService = GetIt.instance.get<AuthService>();
  }
  Future<void> addUser({required UserProfile userProfile}) async {
    try {
      await _users?.doc(userProfile.uid).set(userProfile);
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<UserProfile>> getUsers() {
    return _users
        ?.where('uid', isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatexists(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
   final res = await _chats?.doc(chatId).get();
   if(res!=null){
     return res.exists;
   }
    return false;
  }
  Future<void> createChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final chat = Chat(
      id: chatId,
      participants: [uid1, uid2],
      messages: [],
    );
    await _chats!.doc(chatId).set(chat);
  }

  Future<void> addMessage(String uid1,String uid2, Message message) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    await _chats!.doc(chatId).update({
      'messages': FieldValue.arrayUnion([message.toJson()])
    });
  }

  Stream<DocumentSnapshot<Chat>> getChats(String uid1, String uid2) {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return _chats!
        .doc(chatId)
        .snapshots() as Stream<DocumentSnapshot<Chat>>;
  }
}