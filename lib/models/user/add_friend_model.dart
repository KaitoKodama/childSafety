import 'package:child_safety01/utility/system.dart';
import 'package:child_safety01/utility/master.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';



class FriendAddModel extends ChangeNotifier{
  FriendAddModel(BuildContext context){
    this.context = context;
  }
  final docRef = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late RequestUnit requestUnit;
  late BuildContext context;
  bool isLoading = true;

  List<MasterPartialInfo> myPartialRequireList = [];
  List<MasterPartialInfo> myPartialFriendList = [];
  List<dynamic> myFriendList = [];
  List<dynamic> myFriendRequireList = [];
  String searchText = '';


  Future initFriendRequire() async{
    final myDocSnap = await docRef.doc(uid).get();
    myFriendList = await myDocSnap.get('friend_list');
    myFriendRequireList = await myDocSnap.get('friend_require');

    for(int i=0; i<myFriendList.length; i++){
      String elemID = myFriendList[i].toString();
      DocumentSnapshot snapshot = await docRef.doc(elemID).get();
      if(snapshot.data() != null){
        Map<String, dynamic> mapRef = snapshot['user_info'];
        myPartialFriendList.add(MasterPartialInfo(mapRef));
      }
    }

    for(int i=0; i<myFriendRequireList.length; i++){
      String elemID = myFriendRequireList[i].toString();
      DocumentSnapshot snapshot = await docRef.doc(elemID).get();
      if(snapshot.data() != null){
        Map<String, dynamic> mapRef = snapshot['user_info'];
        myPartialRequireList.add(MasterPartialInfo(mapRef));
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future acceptAddFriendList(int index) async {
    await docRef.doc(uid).update({
      'friend_list': FieldValue.arrayUnion([myPartialRequireList[index].userID]),
    });
    await docRef.doc(uid).update({
      'friend_require': FieldValue.arrayRemove([myPartialRequireList[index].userID]),
    });
    await docRef.doc(myPartialRequireList[index].userID).update({
      'friend_list': FieldValue.arrayUnion([uid]),
    });

    myPartialRequireList.removeAt(index);
    notifyListeners();
  }

  Future rejectAddFriendList(int index) async{
    await docRef.doc(uid).update({
      'friend_require': FieldValue.arrayRemove([myPartialRequireList[index].userID]),
    });

    myPartialRequireList.removeAt(index);
    notifyListeners();
  }



  Future copyToClipboard() async{
    final data = ClipboardData(text: uid);
    await Clipboard.setData(data);
  }

  Future searchFriendID() async {
    requestUnit = await System().getRequestState(myFriendList, myFriendRequireList, searchText);
    notifyListeners();
  }

  Future sendRequestMessage() async{
    await docRef.doc(searchText).update({
      'friend_require': FieldValue.arrayUnion([uid]),
    });
  }
}