import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
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
            TextField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "E-MAIL",
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
              ),
              onSubmitted: (value) {
                _passwordFocusNode.requestFocus();
              },
            ),
            const Divider(),
            TextField(
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
              ),
            ),
            const Divider(),
            ElevatedButton(onPressed: () {}, child: const Text("Login")),
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
