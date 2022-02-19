import 'package:child_safety01/system/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class FriendDetailModel extends ChangeNotifier{
  late MasterCompletedInfo friendCompletedInfo;
  DisplayStateSimple displayState = DisplayStateSimple.IsDisable;

  Future initFriendDetail(String targetId) async{
    final targetDoc = await FirebaseFirestore.instance.collection('users').doc(targetId).get();
    final Map<String, dynamic> targetMap = await targetDoc.get('user_info');
    final Map<String, dynamic> targetChildMap = await targetDoc.get('child_info');
    friendCompletedInfo = new MasterCompletedInfo(targetMap, targetChildMap);

    displayState = DisplayStateSimple.IsEnable;
    notifyListeners();
  }

  //現在選択しているターゲットIDをフレンドリストから削除
  Future deleteSelectedFriend(String targetId) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friend_list': FieldValue.arrayRemove([targetId]),
    });
  }
}