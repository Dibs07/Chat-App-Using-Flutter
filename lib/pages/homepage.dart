import 'package:chat_app/models/userprofile.dart';
import 'package:chat_app/pages/chatpage.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:chat_app/services/dta_serveice.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/widgets/chattile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DataService _dataService;
  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _dataService = _getIt.get<DataService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              bool result = await _authService.logout();
              if (result) {
                _alertService.showSnackBar(
                  message: "Logout Successful",
                  icon: Icons.check,
                  color: Colors.green,
                );
                _navigationService.pushReplacementNamed("/login");
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: uiBuild(),
    );
  }

  Widget uiBuild() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 20.0,
        ),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
      stream: _dataService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Unable to load"),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserProfile userProfile = users[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Chattile(
                    userProfile: userProfile,
                    ontap: () async {
                      final chatexists = await _dataService.checkChatexists(
                        _authService.user!.uid,
                        userProfile.uid!,
                      );
                      if (chatexists) {
                        _navigationService.push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatPage(user: userProfile);
                            },
                          ),
                        );
                      } else {
                        await _dataService.createChat(
                          _authService.user!.uid,
                          userProfile.uid!,
                        );
                      }
                    },
                  ),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
