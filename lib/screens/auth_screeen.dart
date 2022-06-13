import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


import '../widgets/sign_in.dart';
import '../widgets/sign_up.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true;

  void _toggleSignIn() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: LayoutBuilder(builder: (context, constraint) {
        final height = constraint.maxHeight * 0.7;
        final width = constraint.maxWidth * 0.8;
        return _isSignIn
            ? SignInWidget(
                toggleSignIn: _toggleSignIn,
                height: height,
                width: width,
              )
            : SignUpWidget(
                toggleSignIn: _toggleSignIn, height: height, width: width);
      }),
    ));
  }
}
