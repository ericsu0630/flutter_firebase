import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/home_page.dart';
import 'package:flutter_firebase_app/pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: initialize(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //do something
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Firebase',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: startPage(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }

  Future<FirebaseApp> initialize() async {
    final FirebaseApp _initialization = await Firebase.initializeApp();
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('${user.displayName} is signed in!');
      }
    });
    return _initialization;
  }

  Widget startPage() {
    if (FirebaseAuth.instance.currentUser == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
