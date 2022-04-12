import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/pages/friend/friend_list_page.dart';
import 'package:child_safety01/pages/user/add_friend_page.dart';
import 'package:child_safety01/pages/user/edit_profile_page.dart';
import 'package:child_safety01/pages/user/news_page.dart';
import 'package:child_safety01/utility/master.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cp_prop.dart';


/* ---------------------------------------
 フッターウィジェット
---------------------------------------- */
enum FootNavItem{ ItemShow, ItemEdit, ItemAdd, ItemNews, }
class ApplicationFoot extends StatefulWidget {
  const ApplicationFoot();
  @override
  _ApplicationFoot createState() => _ApplicationFoot();
}
class _ApplicationFoot extends State {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final userDoc = FirebaseFirestore.instance.collection('users');
  final newsDoc = FirebaseFirestore.instance.collection('news');

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/footer_icons/icon_list.png'),
          ),
          label: '友達一覧',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/footer_icons/icon_edit.png'),
          ),
          label: 'プロフ編集',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/footer_icons/icon_add.png'),
          ),
          label: '友達追加',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: FutureBuilder(
                future: switchNewsIconPath(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                  Image newsIcon = Image.asset('images/footer_icons/icon_news.png');
                  if(snapshot.hasData){
                    newsIcon = Image.asset(snapshot.data as String);
                  }
                  return newsIcon;
                }
            ),
          ),
          label: 'お知らせ',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: HexColor('#333333'),
      unselectedItemColor: HexColor('#333333'),
      onTap: onTap,
    );
  }
  void onTap(int index){
    Widget route;
    switch(FootNavItem.values[index]){
      case FootNavItem.ItemShow:
        route = FriendListPage();
        break;
      case FootNavItem.ItemEdit:
        route = EditProfilePage();
        break;
      case FootNavItem.ItemAdd:
        route = AddFriendIDPage();
        break;
      case FootNavItem.ItemNews:
        route = NewsPage();
        break;
    }
    SplashScreen(context, route);
  }

  Future<String> switchNewsIconPath() async{
    final DocumentSnapshot userSnap = await userDoc.doc(userId).get();
    final DocumentSnapshot newsSnap = await newsDoc.doc('inc').get();
    final Map<String, dynamic> userMap = await userSnap.get('user_info');
    final List<dynamic> newsList = await newsSnap.get('inc_news');
    final masterInfo = MasterPartialInfo(userMap);

    if(masterInfo.latestNewsID != newsList.length){
      return 'images/footer_icons/icon_news_notify.png';
    }
    return 'images/footer_icons/icon_news.png';
  }
}