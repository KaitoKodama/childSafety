import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/pages/friend/friend_list_page.dart';
import 'package:child_safety01/pages/static/contact_page.dart';
import 'package:child_safety01/pages/static/policy_page.dart';
import 'package:child_safety01/pages/static/usage.dart';
import 'package:child_safety01/pages/user/add_friend_page.dart';
import 'package:child_safety01/pages/user/edit_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../main.dart';
import 'cp_prop.dart';


/* ---------------------------------------
 ヘッダーシンプルウィジェット
---------------------------------------- */
class ApplicationSimpleHead extends StatelessWidget with PreferredSizeWidget {
  ApplicationSimpleHead(this.context);
  final BuildContext context;

  @override
  Size get preferredSize => Size.fromHeight(60.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: HexColor('#F3F7FD'),
        automaticallyImplyLeading: false,
        title: SvgPicture.asset('images/header_icons/logo_head.svg'),
        leading: IconButton(
          icon: SvgPicture.asset('images/header_icons/icon_head_back.svg'),
          onPressed: (){Navigator.pop(context);},
        ),
      ),
    );
  }
}

/* ---------------------------------------
 ヘッダーウィジェット
---------------------------------------- */
class ApplicationHead extends StatelessWidget with PreferredSizeWidget{
  ApplicationHead(this.context);
  final BuildContext context;

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: IconButton(
              icon: SvgPicture.asset('images/header_icons/logo_head.svg'),
              iconSize: 195,
              onPressed: (){
                SplashScreen(context, FriendListPage());
              }
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset('images/header_icons/icon_head_back.svg'),
          onPressed: (){Navigator.pop(context);},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: SizedBox(
              width: 28,
              height: 28,
              child: FutureBuilder(
                  future: switchBellIcon(),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    SvgPicture bellIcon = SvgPicture.asset('images/header_icons/icon_head_bell.svg');
                    if(snapshot.hasData){
                      bellIcon = snapshot.data as SvgPicture;
                    }
                    return IconButton(
                        padding: EdgeInsets.zero,
                        icon: bellIcon,
                        iconSize: 28,
                        onPressed: () {
                          SplashScreen(context, AddFriendIDPage());
                        }
                    );
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset('images/header_icons/icon_head_modal.svg'),
                  iconSize: 28,
                  onPressed: (){buildSettingModalSheet();}
              ),
            ),
          )
        ],
      ),
    );
  }

  void buildSettingModalSheet(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Color(0xFF737373),
        height: MediaQuery.of(context).size.height *0.7,
        child: Container(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.horizontal_rule_rounded,
                size: 50,
                color: Color.fromRGBO(221, 221, 221, 1.0),
              ),
              buildModalItem('icon_edit.svg','プロフィール編集',()=>{
                Navigator.pop(context),
                SplashScreen(context, EditProfilePage()),
              }),
              buildModalItem('icon_show.svg','友達一覧',()=>{
                Navigator.pop(context),
              SplashScreen(context, FriendListPage()),
              }),
              buildModalItem('icon_add.svg','友達追加',()=>{
                Navigator.pop(context),
                SplashScreen(context, AddFriendIDPage()),
              }),
              buildModalItem('icon_contact.svg','お問い合わせ',()=>{
                Navigator.pop(context),
                SplashScreen(context, ContactPage()),
              }),
              buildModalItem('icon_policy.svg','プライバシーポリシー',()=>{
                Navigator.pop(context),
                SplashScreen(context, PolicyPage()),
              }),
              buildModalItem('icon_usage.svg','利用規約',()=>{
                Navigator.pop(context),
                SplashScreen(context, UsagePage()),
              }),
              buildModalItem('icon_logout.svg','ログアウト',()=>{
                Navigator.pop(context),
                buildLogoutModalSheet(),
                requestLogout(),
              }),
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
        ),
      );
    },isScrollControlled: true,
    );
  }
  void buildLogoutModalSheet(){
    Future<void> future =
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Color(0xFF737373),
        height: MediaQuery.of(context).size.height *0.2,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('images/bottom_nav/icon_logout.svg'),
              Text('ログアウトしました')
            ],
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
        ),
      );
    },isScrollControlled: true);
    future.then((void value) => {
      SplashScreen(context, MyHomePage()),
    });
  }

  Container buildModalItem(String iconName, String titleText, Function onTap){
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: const Border(bottom: const BorderSide(color: Colors.black, width: 0.1))
      ),
      child: ListTile(
        leading: SvgPicture.asset('images/bottom_nav/'+iconName),
        title: Text(titleText),
        onTap: (){onTap();},
      ),
    );
  }
  Future<SvgPicture> switchBellIcon() async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final List<dynamic> requestList = await docRef.get('friend_require');
    if(requestList.length == 0){
      return SvgPicture.asset('images/header_icons/icon_head_bell.svg');
    }
    else{
      return SvgPicture.asset('images/header_icons/icon_head_bell_notify.svg');
    }
  }
  Future requestLogout() async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'user_info.is_logout': true,
    });
    await FirebaseAuth.instance.signOut();
  }
}