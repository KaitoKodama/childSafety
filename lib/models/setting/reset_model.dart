import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetModel extends ChangeNotifier{
  FirebaseAuth auth = FirebaseAuth.instance;
  String mail = '';

  Future requireResetPassword() async{
    await auth.sendPasswordResetEmail(email: mail);
    notifyListeners();
  }
}