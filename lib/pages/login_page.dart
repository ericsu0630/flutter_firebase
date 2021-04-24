import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/home_page.dart';
import 'package:flutter_firebase_app/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  final usernameEdit = TextEditingController();
  final pwdEdit = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: pageBody(),
    );
  }

  Widget pageBody() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameEdit,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'username',
              ),
            ),
            TextField(
              controller: pwdEdit,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                loginWithEmailAndPassword();
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void loginWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameEdit.text,
        password: pwdEdit.text,
      );
      print('login success');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }
}
