import 'package:child_safety01/main.dart';
import 'package:child_safety01/rooted/friend/add_friend_root_page.dart';
import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/rooted/friend/add_friend_qr_page.dart';
import 'package:child_safety01/rooted/myself/mysefl_news_page.dart';
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
  Color TopBackGroundBlue(){
    return Color.fromRGBO(248, 252, 255, 1.0);
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



//------------- AppBar(Header)用クラス ------------
class Header extends StatelessWidget with PreferredSizeWidget{
  //下層ページ真偽値のコンストラクタ
  Header(this.context);
  BuildContext context;

  bool isOpen = false;
  double height = 100;
  int newsCount = 0;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  //------------ メイン --------------
  @override
  Widget build(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).canvasColor,
      automaticallyImplyLeading: false,
      title: Text('まぱこ', style: TextStyle(fontFamily: 'MPlus', fontWeight: FontWeight.bold, fontSize: 30, color: Color.fromRGBO(19, 200, 188, 1.0)),),
      actions: [
        IconButton(
          icon: SvgPicture.asset('images/friend_list_icon.svg'),
          onPressed: (){_selectedTransition(FriendListPage());},
        ),
        IconButton(
          icon: SvgPicture.asset('images/qr_icon.svg'),
          onPressed: (){_selectedTransition(AddFriendQRPage());},
        ),
        IconButton(
          icon: SvgPicture.asset('images/setting_icon.svg'),
          onPressed: () async{
            this.newsCount = await getNewsCount();
            _onButtonPressed();
          },
        ),
      ],
    );
  }

  //-------------- モーダルウィジェット ----------------
  void _onButtonPressed(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Color(0xFF737373),
        height: MediaQuery.of(context).size.height *0.9,
        child: Container(
          child: _buildBottomNavigationMenu(),
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
  void _onLogoutButtonPressed(){
    Future<void> future =
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        color: Color(0xFF737373),
        height: MediaQuery.of(context).size.height *0.2,
        child: Container(
          child: _buildBottomLogoutNotify(),
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
    future.then((void value) => onLogoutCloseCallback());
  }

  //--------------- モーダルコンテンツ -----------------
  Column _buildBottomNavigationMenu(){
    return Column(
      children: <Widget>[
        Icon(
          Icons.horizontal_rule_rounded,
          size: 50,
          color: Color.fromRGBO(221, 221, 221, 1.0),
        ),
        _buildBottomNavigationItem('icon_prof.svg', 'プロフィール編集', MySelfEditPage()),
        _buildBottomNavigationItem('icon_friend_list.svg', '友達一覧', FriendListPage()),
        _buildBottomNavigationItem('icon_add_friend.svg', '友達追加', AddFriendRootPage()),
        _buildBottomNavigationNews(),
        _buildBottomNavigationItem('icon_contact.svg', 'お問い合わせ', ContactPage()),
        _buildBottomNavigationItem('icon_policy.svg', 'プライバシーポリシー', PolicyPage()),
        _buildBottomNavigationItem('icon_usage.svg', '利用規約', UsagePage()),
        Container(
          width: double.infinity,
          height: 50,
          child: ListTile(
            leading: SvgPicture.asset('images/bottom_nav/icon_logout.svg'),
            title: Text('ログアウト'),
            onTap: () => {
              Navigator.pop(context),
              onLogout(),
              _onLogoutButtonPressed(),
            },
          ),
        ),
      ],
    );
  }

  Row _buildBottomLogoutNotify(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('images/bottom_nav/icon_logout.svg'),
        Text('ログアウトしました')
      ],
    );
  }

  //---------------- モーダルコンテンツアイテム -------------------
  Container _buildBottomNavigationItem(String iconName, String title, Widget location){
    return Container(
      width: double.infinity,
      height: 50,
      child: ListTile(
        leading: SvgPicture.asset('images/bottom_nav/'+iconName),
        title: Text(title),
        onTap: () => {
          Navigator.pop(context),
          _selectedTransition(location),
        }
      ),
      decoration: BoxDecoration(
        border: const Border(
          bottom: const BorderSide(
            color: Colors.black,
            width: 0.1,
          ),
        ),
      ),
    );
  }
  Container _buildBottomNavigationNews(){
    return Container(
      width: double.infinity,
      height: 50,
      child: ListTile(
        leading: SvgPicture.asset('images/bottom_nav/icon_news.svg'),
        title: Row(
          children: [
            Text('まぱこニュース'),
            switchNotifyNum(),
          ],
        ),
        onTap: () => _selectedTransition(MySelfNewsPage()),
      ),
      decoration: BoxDecoration(
        border: const Border(
          bottom: const BorderSide(
            color: Colors.black,
            width: 0.1,
          ),
        ),
      ),
    );
  }


  //-------------- メソッド --------------
  void _selectedTransition(Widget location){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => location),
    );
  }
  Future<int> getNewsCount() async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<dynamic> newsFld = await docRef.get('part_news');
    List<dynamic> reqFld = await docRef.get('friend_require');
    int newsCount = newsFld.length+reqFld.length;

    return newsCount;
  }
  Future onLogout() async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'user_info.is_logout': true,
    });
    await FirebaseAuth.instance.signOut();
  }
  void onLogoutCloseCallback(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  Widget switchNotifyNum(){
    if(newsCount>0){
      return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: SizedBox(
          width: 25,
          height: 25,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.circle, color: ColorBase().MainBlue()),
              Text(
                newsCount.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      return SizedBox(width: 0, height: 0);
    }
  }
}