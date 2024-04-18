
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class StorageService {
  StorageService() {}
  Future<String?> uploadFile({
    required File file,
    required String uid,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref('users/pfps')
          .child('$uid${p.extension(file.path)}');
      UploadTask uploadTask = ref.putFile(file);
      return uploadTask.then((p) {
        if (p.state == TaskState.success) {
          return ref.getDownloadURL();
        }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
  Future<String?> uploadChatImg({required File file, required String chatId}) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref('chats/$chatId')
          .child('${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}');
      UploadTask uploadTask = ref.putFile(file);
      return uploadTask.then((p) {
        if (p.state == TaskState.success) {
          return ref.getDownloadURL();
        }
      });
    } catch (e) {
      print(e);
    }
    return null;
  }
}
