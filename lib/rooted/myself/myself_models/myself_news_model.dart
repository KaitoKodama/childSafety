import 'package:child_safety01/system/inheritance_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class MyselfNewsModel extends ChangeNotifier{
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List<MyselfIncNews> newsList = [];
  List<UserDetail> requireList = [];
  List friendNotifyList = [];


  Future fetchNewsVariable() async{
    //会社からユーザーに向けたニュースをフェッチ
    final incDoc = await FirebaseFirestore.instance.collection('news').doc('inc').get();
    List<dynamic> incNews = await incDoc.get('inc_news');
    for(var i = 0; i<incNews.length; i++){
      Map<String, dynamic> mapRef = incNews[i];
      final info = MyselfIncNews(mapRef);
      this.newsList.add(info);
    }
    //ユーザーの未承認リストを元にデータをフェッチ
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<dynamic> reqUser = await userDoc.get('friend_require');
    if(reqUser.isNotEmpty){
      for(var i = 0; i<reqUser.length; i++){
        final targetDoc = await FirebaseFirestore.instance.collection('users').doc(reqUser[i]).get();
        final targetInfo = await targetDoc.get('user_info');
        Map<String, dynamic> mapRef = targetInfo;
        final info = UserDetail(mapRef);
        this.requireList.add(info);
      }
    }
    //個人に向けたフレンド通知をフェッチ
    this.friendNotifyList = await userDoc.get('part_news');
    notifyListeners();
  }

  //承諾ボタンのクリックイベント
  Future acceptFriendShip(int index) async {
    DocumentSnapshot docRef = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> mapRef = docRef['user_info'];
    final info = UserDetail(mapRef);
    String myName = info.userName.toString();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friend_list': FieldValue.arrayUnion([requireList[index].userID]),
    });
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friend_require': FieldValue.arrayRemove([requireList[index].userID]),
    });
    await FirebaseFirestore.instance.collection('users').doc(
        requireList[index].userID).update({
      'part_news': FieldValue.arrayUnion(['$myNameさんがフレンド申請を承認しました\nフレンドリストに追加します']),
      'friend_list': FieldValue.arrayUnion([uid]),
    });
  }

  //拒否ボタンのクリックイベント
  Future rejectFriendShip(int index) async{
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friend_require': FieldValue.arrayRemove([requireList[index].userID]),
    });
  }

  //フレンド通知の削除
  Future removeFriendNotify(int index) async{
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'part_news': FieldValue.arrayRemove([friendNotifyList[index]]),
    });
  }
}