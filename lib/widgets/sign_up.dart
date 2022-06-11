import 'package:flutter/material.dart';

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
              onSubmitted: (value) {
                _confirmPasswordFocusNode.requestFocus();
              },
            ),
            const Divider(),
            TextField(
              focusNode: _confirmPasswordFocusNode,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor)),
              ),
            ),
            const Divider(),
            ElevatedButton(onPressed: () {}, child: const Text("Submit")),
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
    );
  }
}
