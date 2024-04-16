import 'dart:io';

import 'package:chat_app/const.dart';
import 'package:chat_app/models/userprofile.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:chat_app/services/dta_serveice.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/services/strage_service.dart';
import 'package:chat_app/widgets/formField.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerformKey = GlobalKey();
  late NavigationService _navigationService;
  late MediaService _mediaService;
  late AuthService _authService;
  late AlertService _alertService;
  late StorageService _storageService;
  late DataService _dataService;
  @override
  void initState() {
    super.initState();
    _navigationService = GetIt.instance.get<NavigationService>();
    _mediaService = GetIt.instance.get<MediaService>();
    _authService = GetIt.instance.get<AuthService>();
    _alertService = GetIt.instance.get<AlertService>();
    _storageService = GetIt.instance.get<StorageService>();
    _dataService = GetIt.instance.get<DataService>();
  }

  String? email, password, name;
  File? pfp;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: uiBuild(),
    );
  }

  Widget uiBuild() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 20.0,
        ),
        child: Column(
          children: [
            header(),
            if (!isLoading) registerForm(),
            if (!isLoading) footerText(),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to Chat App',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Register to continue',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.62,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _registerformKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pfpselector(),
            Formfield(
              hintText: "Enter Your Name",
              labelText: "Name",
              regExp: NAME_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            Formfield(
              hintText: "Enter Your Email",
              labelText: "Email",
              regExp: EMAIL_VALIDATION_REGEX,
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            Formfield(
              hintText: "Enter Your Password",
              labelText: "Password",
              regExp: PASSWORD_VALIDATION_REGEX,
              isObscure: true,
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            regButton(),
          ],
        ),
      ),
    );
  }

  Widget pfpselector() {
    return GestureDetector(
      onTap: () async {
        File? pf = await _mediaService.getImage();
        if (pf != null) {
          setState(() {
            pfp = pf;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.15,
        backgroundImage: pfp != null
            ? FileImage(pfp!)
            : NetworkImage(DEFAULT_PFP) as ImageProvider,
      ),
    );
  }

  Widget regButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if (_registerformKey.currentState?.validate() ?? false) {
              _registerformKey.currentState?.save();
              bool result = await _authService.register(email!, password!);
              if (result) {
                String? url = await _storageService.uploadFile(
                  file: pfp!,
                  uid: _authService.currentUser!.uid,
                );
                if(url!=null){
                  await _dataService.addUser(
                    userProfile: UserProfile(
                      uid: _authService.currentUser!.uid,
                      name: name!,
                      pfpURL: url,
                    ),
                  );
                  _alertService.showSnackBar(
                    message: "Registration Success",
                    icon: Icons.check,
                    color: Colors.green,
                  );
                  _navigationService.goback();
                  _navigationService.pushReplacementNamed("/home");
                }
               else{
                throw Exception("Failed to upload user profile image");
               }
              } else {
                _alertService.showSnackBar(
                  message: "Registration Failed",
                  icon: Icons.error,
                  color: Colors.red,
                );
                _navigationService.goback();
              }
            }
          } catch (e) {
            print(e);
            _alertService.showSnackBar(
              message: "Registration Failed",
              icon: Icons.error,
              color: Colors.red,
            );
          }
          setState(() {
            isLoading = false;
          });
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget footerText() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('Have an account?'),
        GestureDetector(
          onTap: () {
            _navigationService.goback();
          },
          child: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ));
  }
}
