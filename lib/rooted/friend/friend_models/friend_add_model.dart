import 'package:child_safety01/system/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


enum RequestState{
  IsNotExist,
  IsMultipleRequire,
  IsInFriendList,
  IsLogout,
  Accept,
}
class FriendAddModel extends ChangeNotifier{
  FriendAddModel(BuildContext context){
    this.context = context;
  }
  final docRef = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late MasterPartialInfo requestTarget;
  late BuildContext context;

  RequestState requestState = RequestState.IsNotExist;
  DisplayStateSimple displayState = DisplayStateSimple.IsDisable;
  List<MasterPartialInfo> myRequireList = [];
  List<MasterPartialInfo> myFriendList = [];
  String searchText = '';
  String requireLog = '';


  Future initFriendRequire() async{
    DocumentSnapshot myDocumentSnap = await docRef.doc(uid).get();
    final myFriendListSnap = await myDocumentSnap.get('friend_list');
    final myRequireListSnap = await myDocumentSnap.get('friend_require');

    for(int i=0; i<myFriendListSnap.length; i++){
      String elemID = myFriendListSnap[i].toString();
      DocumentSnapshot snapshot = await docRef.doc(elemID).get();
      if(snapshot.data() != null){
        Map<String, dynamic> mapRef = snapshot['user_info'];
        myFriendList.add(MasterPartialInfo(mapRef));
      }
    }

    for(int i=0; i<myRequireListSnap.length; i++){
      String elemID = myRequireListSnap[i].toString();
      DocumentSnapshot snapshot = await docRef.doc(elemID).get();
      if(snapshot.data() != null){
        Map<String, dynamic> mapRef = snapshot['user_info'];
        myRequireList.add(MasterPartialInfo(mapRef));
      }
    }

    displayState = DisplayStateSimple.IsEnable;
    notifyListeners();
  }

  Future acceptAddFriendList(int index) async {
    await docRef.doc(uid).update({
      'friend_list': FieldValue.arrayUnion([myRequireList[index].userID]),
    });
    await docRef.doc(uid).update({
      'friend_require': FieldValue.arrayRemove([myRequireList[index].userID]),
    });
    await docRef.doc(myRequireList[index].userID).update({
      'friend_list': FieldValue.arrayUnion([uid]),
    });

    myRequireList.removeAt(index);
    notifyListeners();
  }


  Future copyToClipboard() async{
    final data = ClipboardData(text: uid);
    await Clipboard.setData(data);
  }

  Future searchFriendID() async {
    requestState = RequestState.IsNotExist;
    requireLog = 'ユーザーIDが見つかりませんでした';

    if(searchText != ''){
      var getDoc = await docRef.doc(searchText).get();
      if (getDoc.exists && getDoc.id != uid) {
        var targetDoc = await docRef.doc(searchText).get();
        List<dynamic> targetRequireList = await targetDoc.get('friend_require');
        targetRequireList.forEach((element){
          if (element.toString() == uid) {
            requestState = RequestState.IsMultipleRequire;
            requireLog = '申請済みです。承認をお待ちください';
            return;
          }
        });

        myFriendList.forEach((element) {
          if(element.toString() == searchText){
            requestState = RequestState.IsInFriendList;
            requireLog = 'フレンドリストに追加されています';
            return;
          }
        });

        if (requestState != RequestState.IsMultipleRequire && requestState != RequestState.IsInFriendList){
          Map<String, dynamic> targetMap = await getDoc['user_info'];
          requestTarget = MasterPartialInfo(targetMap);
          if (requestTarget.isLogout) {
            requestState = RequestState.IsLogout;
            requireLog = 'ログアウト中のユーザーには申請を行えません';
          }
          else {
            requestState = RequestState.Accept;
            requireLog = requestTarget.userName+'さんへフレンド申請を行いますか';
          }
        }
      }
    }
    notifyListeners();
  }

  Future sendRequestMessage() async{
    await docRef.doc(searchText).update({
      'friend_require': FieldValue.arrayUnion([uid]),
    });
  }
}