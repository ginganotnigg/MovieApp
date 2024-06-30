import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<bool> doesUserExist() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> startCollection() async {
    bool condition = await doesUserExist();
    if (condition == false) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(
            FirebaseAuth.instance.currentUser!.uid,
          )
          .set({
        "email": FirebaseAuth.instance.currentUser!.email,
        "watchlist": [],
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        startCollection();
      });

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
