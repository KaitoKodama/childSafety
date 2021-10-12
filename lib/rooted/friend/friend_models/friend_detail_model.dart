import 'package:child_safety01/system/inheritance_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FriendDetailModel extends ChangeNotifier{
  String myId = FirebaseAuth.instance.currentUser!.uid;
  UserDetail?friendUserDetail;
  List<UserChildDetail> friendChildDetail = [];

  bool isLoading = false;


  Future fetchFriendDetail(String targetId) async{
    isLoading = true;
    final field = await FirebaseFirestore.instance.collection('users').doc(targetId).get();

    //ユーザー情報を取得・格納
    Map<String, dynamic> userInfo = await field.get('user_info');
    this.friendUserDetail = UserDetail(userInfo);

    //ユーザーの子供情報を取得・格納
    Map<String, dynamic> childInfo = await field.get('child_info');

    //各、子供情報のインスタンスをリスト化する
    for(var i = 0; i<childInfo.length; i++){
      String expectStr = 'data0'+(i+1).toString();
      Map<String, dynamic> mapRef = childInfo[expectStr];
      final info = UserChildDetail(mapRef);
      friendChildDetail.add(info);
    }

    isLoading = false;
    notifyListeners();
  }

  //現在選択しているターゲットIDをフレンドリストから削除
  Future deleteSelectedFriend(String targetId) async{
    await FirebaseFirestore.instance.collection('users').doc(myId).update({
      'friend_list': FieldValue.arrayRemove([targetId]),
    });
  }
}