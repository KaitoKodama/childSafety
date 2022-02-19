import 'package:child_safety01/main.dart';
import 'package:child_safety01/rooted/friend/friend_add_page.dart';
import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/rooted/myself/myself_edit_page.dart';
import 'package:child_safety01/rooted/setting/contact.dart';
import 'package:child_safety01/rooted/setting/policy.dart';
import 'package:child_safety01/rooted/setting/usage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


//--------------- 共通ウィジェット作成クラス ---------------
class WidgetBase{

  //region initialフォルダで複数使われるウィジェット
  //入力エリアの共通デコレーション
  InputDecoration initialDecoration(String hintText){
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      labelStyle: TextStyle(
        color: ColorBase().MainBlue(),
      ),
      hintStyle: TextStyle(
        color: ColorBase().MainBlue(),
      ),
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10),
        borderSide: BorderSide(
          color: ColorBase().MainBlue(),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: new BorderRadius.circular(20),
        borderSide: BorderSide(
            color: ColorBase().MainBlue(),
        ),
      ),
    );
  }
  //endregion
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class SmallPartsBase{
  Text textStyledBoolean(String text, String unsetTxt, Color txtColor, double fontSize){
    return Text(
      (text.isNotEmpty)?text: unsetTxt,
      style: TextStyle(
        color: txtColor,
        fontFamily: 'MPlusR',
        fontSize: fontSize
      ),
    );
  }

  TextStyle childBarStyle(){
    return TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontFamily: 'MPlusR',
    );
  }
  TextStyle mainTextStyle(){
    return TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontFamily: 'MPlusR',
    );
  }
}

class ColorBase{
  Color MainBlue(){
    return Color.fromRGBO(19, 200, 188, 1.0);
  }
  Color SubGray(){
    return Color.fromRGBO(142, 142, 142, 1.0);
  }
  Color BackGroundColor(BuildContext context){
    return Theme.of(context).canvasColor;
  }
  Color BorderColor(){
    return Color.fromRGBO(238, 238, 238, 1.0);
  }
}

class CommonUsage{
  String checkIsStringEmpty(String searchStr, String emptyStr){
    String expectStr = '';
    if(searchStr.isEmpty) {
      expectStr = emptyStr;
    }else{
      expectStr = searchStr;
    }
    return expectStr;
  }
}


/* ---------------------------------------
 ヘッダーシンプルウィジェット
---------------------------------------- */
class ApplicationSimpleHead extends StatelessWidget with PreferredSizeWidget {
  ApplicationSimpleHead(this.context);
  final BuildContext context;
  final paddingTop = 25.0;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight+paddingTop);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: HexColor('#F3F7FD'),
        automaticallyImplyLeading: false,
        title: SvgPicture.asset('images/logo_head.svg'),
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).canvasColor,
      automaticallyImplyLeading: false,
      title: Container(
        alignment: Alignment.center,
        child: IconButton(
          icon: SvgPicture.asset('images/logo_head.svg'),
          iconSize: 195,
          onPressed: (){
            Utility().onFadeNavigator(context, FriendListPage());
          }
        ),
      ),
      leading: IconButton(
        icon: SvgPicture.asset('images/icon_head_back.svg'),
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
                SvgPicture bellIcon = SvgPicture.asset('images/icon_head_bell.svg');
                if(snapshot.hasData){
                  bellIcon = snapshot.data as SvgPicture;
                }
                return IconButton(
                    padding: EdgeInsets.zero,
                    icon: bellIcon,
                    iconSize: 28,
                    onPressed: () {
                      Utility().onFadeNavigator(context, FriendAddPage());
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
                icon: SvgPicture.asset('images/icon_head_modal.svg'),
                iconSize: 28,
                onPressed: (){buildSettingModalSheet();}
            ),
          ),
        )
      ],
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
                Utility().onFadeNavigator(context, MySelfEditPage()),
              }),
              buildModalItem('icon_show.svg','友達一覧',()=>{
                Navigator.pop(context),
                Utility().onFadeNavigator(context, FriendListPage()),
              }),
              buildModalItem('icon_add.svg','友達追加',()=>{
                Navigator.pop(context),
                Utility().onFadeNavigator(context, FriendAddPage()),
              }),
              buildModalItem('icon_contact.svg','お問い合わせ',()=>{
                Navigator.pop(context),
                Utility().onFadeNavigator(context, ContactPage()),
              }),
              buildModalItem('icon_policy.svg','プライバシーポリシー',()=>{
                Navigator.pop(context),
                Utility().onFadeNavigator(context, PolicyPage()),
              }),
              buildModalItem('icon_usage.svg','利用規約',()=>{
                Navigator.pop(context),
                Utility().onFadeNavigator(context, UsagePage()),
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
      Utility().onFadeNavigator(context, MyHomePage()),
    });
  }

  Container buildModalItem(String iconName, String titleText, Function onTap){
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: const Border(
          bottom: const BorderSide(
            color: Colors.black,
            width: 0.1,
          )
        )
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
      return SvgPicture.asset('images/icon_head_bell.svg');
    }
    else{
      return SvgPicture.asset('images/icon_head_bell_notify.svg');
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


/* ---------------------------------------
 共通ウィジェット
---------------------------------------- */
class BuildWidget {
  // ■ いい感じのダイアログ
  void buildDialog(
      String titleText, String contentText, String buttonText,
      BuildContext context, Function actionTap,) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(25),
            contentPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
            actionsPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
            buttonPadding: const EdgeInsets.all(0),
            backgroundColor: HexColor('#F3F7FD'),
            title: Text(titleText,style: TextStyle(fontSize: 14, fontFamily: 'MPlus')),
            content: Text(contentText,style: TextStyle(fontSize: 14, fontFamily: 'MPlusR')),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: HexColor('#1595B9'),
                    side: BorderSide(color: HexColor('#1595B9')),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                  ),
                  child: Text(buttonText, style: TextStyle(color: HexColor('#FFFFFF'),fontSize: 16,fontFamily: 'MPlusR')),
                  onPressed: () { actionTap();},
                ),
              ),
            ],
          );
        }
    );
  }


  // ■ いい感じのボタン
  Widget styledButton(String text, Color textColor, Color backgroundColor,
      Color borderColor, Function onClick) {
    return SizedBox(
      width: 300,
      height: 50,
      child: OutlinedButton(
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontFamily: 'MPlusR'),),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
        ),
        onPressed: () async {
          onClick();
        },
      ),
    );
  }

  // ■ テキストフォーム
  Widget buildTextFormFieldWidget(Color textColor, Color borderColor,
      String hintText, String defaultText,
      Function onChanged) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextFormField(
        onChanged: (text) => {onChanged(text)},
        initialValue: defaultText,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: textColor,fontFamily: 'MPlusR',),
          hintStyle: TextStyle(color: textColor,fontFamily: 'MPlusR',),
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor,width: 2,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor,width: 2,),
          ),
        ),
      ),
    );
  }

  // ■ 各友達一覧
  Widget buildFriendItem(BuildContext context, ImageProvider iconProvider, String mainText, subText, Function onPressed){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor('#FFE33F'), width: 1),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: iconProvider,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mainText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13,fontFamily: 'MPlus',color: HexColor('#333333')),
                  ),
                  Text(
                    subText,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12,fontFamily: 'MPlus',color: HexColor('#8E8E8E')),
                  ),
                ],
              ),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            side: BorderSide(color: Theme.of(context).canvasColor)
        ),
        onPressed: (){ onPressed(); },
      ),
    );
  }

  // ■ ローディング画面
  Widget buildLoadingDialog(BuildContext context) {
    return Container(
      color: HexColor('#F3F7FD'),
      width: double.infinity,
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/top_logo.svg'),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/* ---------------------------------------
 共通ユーティリティ
---------------------------------------- */
class Utility{
  void onFadeNavigator(BuildContext context, Widget route){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => route,
        transitionsBuilder: (context, animation, secondaryAnimation, child){
          return FadeTransition(child: child, opacity: animation);
        },
      ),
    );
  }
}


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
        route = MySelfEditPage();
        break;
      case FootNavItem.ItemAdd:
        route = FriendAddPage();
        break;
    }
    Utility().onFadeNavigator(context, route);
  }
}