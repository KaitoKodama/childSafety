import 'package:child_safety01/utility/master.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class FriendDetailModel extends ChangeNotifier{
  late MasterCompletedInfo friendCompletedInfo;
  bool isLoading = true;

  //TODO 例外処理：Exceptionを検知した場合に違うページ(アップデートしてないよ)に遷移
  Future initFriendDetail(String targetId) async{
    final targetDoc = await FirebaseFirestore.instance.collection('users').doc(targetId).get();
    final Map<String, dynamic> targetMap = await targetDoc.get('user_info');
    final Map<String, dynamic> targetChildMap = await targetDoc.get('child_info');
    friendCompletedInfo = new MasterCompletedInfo(targetMap, targetChildMap);

    isLoading = false;
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