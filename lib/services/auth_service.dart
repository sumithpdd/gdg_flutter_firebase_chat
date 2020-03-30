import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:gdg_flutter_firebase_chat/helpers/constants.dart'; 

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Stream<FirebaseUser> get user => _firebaseAuth.onAuthStateChanged;

  Future<void> signup(String name, String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (authResult.user != null) {
        String token = await _firebaseMessaging.getToken();
        usersRef.document(authResult.user.uid).setData({
          'name': name,
          'email': email, 
          'profileImageUrl': '',
          'bio': '',
          'token': token,
        });
        print('Signup complete');
      }
    } on PlatformException catch (error) {
      throw (error);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
          print('login complete');
    } on PlatformException catch (error) {
      throw (error);
    }
  }

  Future<void> logout() {
    Future.wait([_firebaseAuth.signOut()]);
  }
}
