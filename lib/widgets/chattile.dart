import 'package:chat_app/models/userprofile.dart';
import 'package:flutter/material.dart';

class Chattile extends StatelessWidget {
  final UserProfile userProfile;
  final Function ontap;
  const Chattile({super.key, required this.userProfile, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        ontap();
      },
      dense: false,
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(userProfile.pfpURL!),
      ),
      title: Text(userProfile.name!),

    );
  }
}