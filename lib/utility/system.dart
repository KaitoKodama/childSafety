import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/pages/static/permission_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'enum.dart';
import 'master.dart';


/*--------------------------------------
データの初期化
---------------------------------------*/
class ResetManager{
  final docRef = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future resetDocumentField() async{
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'child_info': {
        '0':{
          'child_order':'',
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
  }
}


/*--------------------------------------
フレンド要請のユニット
---------------------------------------*/
class RequestUnitManager{
  final docRef = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<RequestUnit> getRequestState(List<dynamic> myFriendList, List<dynamic> myRequireList, String searchID) async {
    var targetDoc = await docRef.doc(searchID).get();
    if(!targetDoc.exists){
      return RequestUnit("ユーザーIDが見つかりませんでした", RequestState.IsNotExist);
    }
    if(targetDoc.id == uid){
      return RequestUnit("自身をフレンドリストには追加できません", RequestState.IsSelfID);
    }
    final targetFriendRequireList = await targetDoc.get('friend_require');
    for(var target in targetFriendRequireList){
      if(target.toString() == uid){
        return RequestUnit("申請済みです。承認をお待ちください", RequestState.IsMultipleRequire);
      }
    }
    for(var target in myRequireList){
      if(target.toString() == uid){
        return RequestUnit("申請済みです。承認をお待ちください", RequestState.IsMultipleRequire);
      }
    }
    for(var myFriend in myFriendList){
      if(myFriend.toString() == searchID){
        return RequestUnit("同一ユーザーが既にフレンドリストに追加されています", RequestState.IsInFriendList);
      }
    }
    final requestTarget = MasterPartialInfo(await targetDoc.get('user_info'));
    if(requestTarget.isLogout){
      return RequestUnit("ログアウト中のユーザーには申請を行えません", RequestState.IsLogout);
    }

    String name = requestTarget.userName;
    return RequestUnit("$nameさんへフレンド申請を行いますか？", RequestState.Accept);
  }
}
class RequestUnit{
  RequestUnit(this.logMessage, this.requestState);
  late String logMessage;
  late RequestState requestState;
}


/*--------------------------------------
デバイスの許可確認
---------------------------------------*/
class PermissionManager{
  PermissionManager(this.context, this.permission, this.enable){
    _permissionHandle();
  }
  final BuildContext context;
  final Permission permission;
  final Function enable;

  Future _permissionHandle() async {
    var status = await permission.request();
    if(status.isDenied || status.isPermanentlyDenied){
      Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionPage()));
    }
    else{
      enable();
    }
  }
}