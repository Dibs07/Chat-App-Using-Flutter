import 'package:chat_app/const.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_Service.dart';
import 'package:chat_app/services/navigation_service.dart';

import 'package:chat_app/widgets/formField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _loginformKey = GlobalKey();
  late NavigationService _navigationService;
  late AuthService _authService;
  late AlertService _alertService;

  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
  }

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
        horizontal: 15.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          header(),
          loginForm(),
          footerText(),
        ],
      ),
    ));
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
            'Login to continue',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget loginForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.3,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _loginformKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          if (_loginformKey.currentState?.validate() ?? false) {
            _loginformKey.currentState?.save();
            bool result = await _authService.login(email!, password!);

            if (result) {
              _alertService.showSnackBar(
                message: "Login Successful",
                icon: Icons.check,
                color: Colors.green,
              );
              _navigationService.pushReplacementNamed("/home");
            } else {
              _alertService.showSnackBar(
                message: "Invalid Email or Password",
                icon: Icons.error,
                color: Colors.red,
              );
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          'Login',
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
        Text('Don\'t have an account?'),
        GestureDetector(
          onTap: () {
            _navigationService.pushNamed("/register");
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ));
  }
}
