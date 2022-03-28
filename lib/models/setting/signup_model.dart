import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  Future requestSighup() async{
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }
    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    )).user;
    final email = user!.email;
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': email,
      'friend_list': [],
      'friend_require':[],
      'user_info': {
        'user_comment': '',
        'user_exp': '',
        'user_icon': '',
        'user_name': '',
        'user_id': user.uid,
        'is_logout': false,
      },
      'child_info': {
        '0':{
          'child_icon':'',
          'child_name':'',
          'child_birth':'',
          'child_fav': '',
          'child_hate': '',
          'child_aller': '',
          'child_person': '',
          'child_exe': '',
        }
      },
    });
    notifyListeners();
  }
}