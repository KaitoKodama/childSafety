import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


//ログイン用モデル
class LoginModel extends ChangeNotifier{
  final Connectivity connectivity = Connectivity();
  ConnectivityResult?connectivityResult;
  final docRef = FirebaseFirestore.instance.collection('users');

  String mail = '';
  String password = '';
  bool isOffline = false;
  bool isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future fetchLoginState() async{
    isOffline = false;
    isLoading = false;
    final isLogin = auth.currentUser;
    if(isLogin != null){
      mail = auth.currentUser!.email.toString();
    }
    notifyListeners();
  }

  Future login() async{
    if(mail.isEmpty){
      throw ('メールアドレスを入力してください');
    }
    if(password.isEmpty){
      throw ('パスワードを入力してください');
    }

    connectivityResult = await connectivity.checkConnectivity();
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      isLoading = true;
      notifyListeners();

      final result = await auth.signInWithEmailAndPassword(
          email: mail,
          password: password
      );
      final uid = result.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'user_info.is_logout': false,
      });

    }else{
      isOffline = true;
      notifyListeners();
    }
  }
}