import 'package:child_safety01/system/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LoginState{
  Disconnected,
  RequireLogin,
  CompletedLogin,
}
class MainModel extends ChangeNotifier{
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance.collection('users');

  FirebaseAuth auth = FirebaseAuth.instance;
  Connectivity connectivity = Connectivity();
  String mail = '';
  LoginState loginState = LoginState.RequireLogin;

  Future checkLoginState() async{
    ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      if(auth.currentUser != null){
        mail = FirebaseAuth.instance.currentUser!.email.toString();
        loginState = LoginState.CompletedLogin;
      }
      else{
        loginState = LoginState.RequireLogin;
      }
    }
    else{
      loginState = LoginState.Disconnected;
    }
    notifyListeners();
  }


  Future onDocumentFieldCheck() async{
    final DocumentSnapshot docSnap = await docRef.doc(userId).get();
    final Map<String, dynamic> userMap = await docSnap.get('user_info');
    final Map<String, dynamic> childMap = await docSnap.get('child_info');
    MasterCompletedInfo(userMap, childMap);
  }

  Future requireResetPassword() async{
    await auth.sendPasswordResetEmail(email: mail);
    notifyListeners();
  }
}