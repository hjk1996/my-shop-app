import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SignUpWidget extends StatefulWidget {
  SignUpWidget({
    Key? key,
    required this.toggleSignIn,
    required this.height,
    required this.width,
  }) : super(key: key);

  VoidCallback toggleSignIn;
  final double height;
  final double width;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _confirmPassword;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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

  String? _confirmPasswordVaildator(value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Confirm Password.";
    }

    if (value != _password) {
      return "Confirm Password Doesn't match.";
    }

    return null;
  }

  Future<void> _onSubmit() async {
    _formKey.currentState!.save();

    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_email!, _password!);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Sign Up Success!")));
        widget.toggleSignIn();
      } catch (error) {
        print(error);
      }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                validator: _emailValidator,
                onSaved: (value) {
                  _email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "E-MAIL",
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                onFieldSubmitted: (value) {
                  _passwordFocusNode.requestFocus();
                  _formKey.currentState!.save();
                },
              ),
              const Divider(),
              TextFormField(
                focusNode: _passwordFocusNode,
                validator: _passwordValidator,
                onSaved: (value) {
                  _password = value;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                onFieldSubmitted: (value) {
                  _confirmPasswordFocusNode.requestFocus();
                  _formKey.currentState!.save();
                },
              ),
              const Divider(),
              TextFormField(
                focusNode: _confirmPasswordFocusNode,
                validator: _confirmPasswordVaildator,
                onSaved: (value) {
                  _confirmPassword = value;
                },
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor)),
                ),
                onFieldSubmitted: (value) {
                  _formKey.currentState!.save();
                },
              ),
              const Divider(),
              ElevatedButton(onPressed: _onSubmit, child: const Text("Submit")),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    widget.toggleSignIn();
                  },
                  child: const Text('Sign In'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
