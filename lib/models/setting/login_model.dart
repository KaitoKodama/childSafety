import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class LoginModel extends ChangeNotifier{
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = '';
  String mail = '';
  String password = '';


  Future loginRequest() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }
    final result = await auth.signInWithEmailAndPassword(
        email: mail,
        password: password
    );
    this.uid = result.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'user_info.is_logout': false,
    });

    notifyListeners();
  }
}