import 'package:chat_app/models/userprofile.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late AuthService _authService;
  CollectionReference? _users;
  void setUp() {
    _users = _db.collection('users').withConverter<UserProfile>(
          fromFirestore: (snapshots, _) => UserProfile.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (userProfile, _) => userProfile.toJson(),
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
}
