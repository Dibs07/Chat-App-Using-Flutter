import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  User? get currentUser{
    return user;
  }
  AuthService() {
    _auth.authStateChanges().listen(authStateStreamChange);
  } 
  Future<bool> register(String email, String password) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user != null) {
        user=credentials.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
  Future<bool> login(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user != null) {
        user=credentials.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
  Future<bool> logout () async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
  void authStateStreamChange(User? userc) {
    user = userc;
  }
}
