import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignInWidget extends StatefulWidget {
  SignInWidget({
    Key? key,
    required this.toggleSignIn,
    required this.height,
    required this.width,
  }) : super(key: key);

  VoidCallback toggleSignIn;
  final double height;
  final double width;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  late FocusNode _passwordFocusNode;
  late FocusNode _signInButtonFocusNode;
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _signInButtonFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _signInButtonFocusNode.dispose();
    super.dispose();
  }

  String? _emailValidator(email) {
    if (email == null || email.isEmpty) {
      return "Please Enter Your E-Mail.";
    }

    final emailValidRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (!emailValidRegex.hasMatch(email)) {
      return "Invalid E-mail Adress.";
    }

    return null;
  }

  String? _passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Password.";
    }

    if (value.length < 8) {
      return 'Password shoud not be less than 8 characters.';
    }

    return null;
  }

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await Provider.of<Auth>(context, listen: false)
          .signIn(_email!, _password!);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Sign In Success!",
        textAlign: TextAlign.center,
      )));
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
              decoration: InputDecoration(
                hintText: "E-MAIL",
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
              ),
              onFieldSubmitted: (value) {
                _passwordFocusNode.requestFocus();
              },
              onSaved: (value) {
                _email = value;
              },
            ),
            const Divider(),
            TextFormField(
              focusNode: _passwordFocusNode,
              validator: _passwordValidator,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
              ),
              onFieldSubmitted: (value) {
                _signInButtonFocusNode.requestFocus();
              },
              onSaved: (value) {
                _password = value;
              },
            ),
            const Divider(),
            ElevatedButton(
                focusNode: _signInButtonFocusNode,
                onPressed: _onSubmit,
                child: const Text("Login")),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  widget.toggleSignIn();
                },
                child: const Text('Sign Up'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
