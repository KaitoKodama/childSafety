import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/pages/friend/friend_list_page.dart';
import 'package:child_safety01/pages/user/add_friend_page.dart';
import 'package:child_safety01/pages/user/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'cp_prop.dart';


/* ---------------------------------------
 フッターウィジェット
---------------------------------------- */
enum FootNavItem{ ItemHome, ItemShow, ItemEdit, ItemAdd, }
class ApplicationFoot extends StatefulWidget {
  const ApplicationFoot();
  @override
  _ApplicationFoot createState() => _ApplicationFoot();
}
class _ApplicationFoot extends State {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/foot_icon_home.png'),
          ),
          label: 'ホーム',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/foot_icon_show.png'),
          ),
          label: '友達一覧',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/foot_icon_edit.png'),
          ),
          label: 'プロフ編集',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 25,
            height: 25,
            child: Image.asset('images/foot_icon_add.png'),
          ),
          label: '友達追加',
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
      case FootNavItem.ItemHome:
        route = MyHomePage();
        break;
      case FootNavItem.ItemShow:
        route = FriendListPage();
        break;
      case FootNavItem.ItemEdit:
        route = EditProfilePage();
        break;
      case FootNavItem.ItemAdd:
        route = AddFriendIDPage();
        break;
    }
    SplashScreen(context, route);
  }
}