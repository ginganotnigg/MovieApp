import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/pages/login_page.dart';
import 'package:movie_app/pages/main_page.dart';

class AuthRoutePage extends StatelessWidget {
  const AuthRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        });
  }
}
