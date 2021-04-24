import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  final phoneEdit = TextEditingController();
  final usernameEdit = TextEditingController();
  final emailEdit = TextEditingController();
  final pwdEdit = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            TextField(
              controller: phoneEdit,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'phone number',
              ),
            ),
            TextField(
              controller: emailEdit,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'email',
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
                registerWithFirebase();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void registerWithFirebase() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailEdit.text,
        password: pwdEdit.text,
      );
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1 234-567-8900', //phoneEdit.text
        verificationCompleted: (PhoneAuthCredential credential) {
          print('verify complete');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verify failed');
        },
        codeSent: (String verificationId, int resendToken) async {
          print('verify code sent');

          await FirebaseAuth.instance.currentUser.linkWithCredential(
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: '123456'));
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: usernameEdit.text);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('verify timeout');
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }
}
