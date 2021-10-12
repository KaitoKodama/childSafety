import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//新規登録用モデル
class SignUpModel extends ChangeNotifier {
  final Connectivity connectivity = Connectivity();
  ConnectivityResult?connectivityResult;

  String mail = '';
  String password = '';
  bool isOffline = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp() async {
    if (mail.isEmpty) {
      throw ('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw ('パスワードを入力してください');
    }

    connectivityResult = await connectivity.checkConnectivity();
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      isLoading = true;
      final user = (await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      ))
          .user;
      final email = user!.email;

      //初期値
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'version': '0.1',
        'email': email,
        'friend_list': [],
        'friend_require':[],
        'part_news':[],
        'user_info': {
          'user_comment': '',
          'user_exp': '',
          'user_icon': '',
          'user_name': '',
          'user_id': user.uid,
          'is_logout': false,
        },
        'child_info': {
          'data01':{
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
    }else{
      isOffline = true;
      notifyListeners();
    }
  }
}