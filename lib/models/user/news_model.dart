import 'package:child_safety01/utility/master.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class NewsModel extends ChangeNotifier{
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final newsDoc = FirebaseFirestore.instance.collection('news');
  List<NewsUnit> newsUnitList = [];
  bool isLoading = true;

  Future initNewsModel() async{
    final DocumentSnapshot newsSnap = await newsDoc.doc('inc').get();
    final List<dynamic> newsList = await newsSnap.get('inc_news');

    for(var news in newsList.reversed){
      newsUnitList.add(new NewsUnit(news));
    }
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'user_info.latest_news': newsUnitList.length,
    });
    isLoading = false;
    notifyListeners();
  }
}