import 'package:child_safety01/component/cp_item.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/pages/friend/friend_detail_page.dart';
import 'package:child_safety01/utility/enum.dart';
import 'package:child_safety01/utility/master.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


/* ---------------------------------------
 フレンドリストモデル
---------------------------------------- */
class FriendListModel extends ChangeNotifier{
  String userid = FirebaseAuth.instance.currentUser!.uid;
  final docSnap = FirebaseFirestore.instance.collection('users');
  List<MasterPartialInfo> friendList = [];
  DisplayState displayState = DisplayState.IsLoading;


  Future initFriendList() async{
    final document = await docSnap.doc(userid).get();
    final docList = document.get('friend_list').toList();

    for(int i=0; i<docList.length; i++){
      DocumentSnapshot docRef = await FirebaseFirestore.instance.collection('users').doc(docList[i]).get();
      if(docRef.data() != null){
        Map<String, dynamic> mapRef = docRef['user_info'];
        friendList.add(MasterPartialInfo(mapRef));
      }
    }
    if(friendList.length != 0){
      displayState = DisplayState.FriendExist;
    }
    else{
      displayState = DisplayState.FriendDoesNotExist;
    }
    notifyListeners();
  }

  //フレンドリストからターゲットを削除
  Future deleteFriendFromList(int index) async{
    String removeTarget = friendList[index].userID.toString();
    await docSnap.doc(userid).update({
      'friend_list': FieldValue.arrayRemove([removeTarget]),
    });

    friendList.removeAt(index);
    notifyListeners();
  }
}


/* ---------------------------------------
 検索結果デリゲート
---------------------------------------- */
class FriendSearch extends SearchDelegate<String?>{
  FriendSearch(List<MasterPartialInfo> friendList) :super(
      searchFieldLabel: "検索",
      searchFieldStyle: TextStyle(fontSize: 16, fontFamily: 'MPlusR', color: HexColor('#AAAAAA')))
  {
    _friendList = friendList;
    friendList.forEach((element) {
      _nameList.add(element.userName);
    });
  }
  List<MasterPartialInfo> _friendDisplayExpectList = [];
  List<MasterPartialInfo> _friendList = [];
  final List<String> _nameList = [];

  //■ 処理の書き換え
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      OutlinedButton(
        child: Text('キャンセル',style: TextStyle(fontSize: 15, fontFamily: 'MPlusR', color: HexColor('#1595B9'))),
        style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).canvasColor, width: 0)),
        onPressed: ()=>{ Navigator.of(context).pop() },
      ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return OutlinedButton(
      child: SvgPicture.asset('images/icon_search.svg'),
      style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).canvasColor, width: 0)),
      onPressed: ()=>{ showResults(context) },
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    observeQueryExist();
    if(_friendDisplayExpectList.length != 0){
      return buildFriendListView();
    }
    else{
      return Center(
        child: Container(
          child: Text('一致する検索結果はありませんでした'),
        ),
      );
    }
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    observeQueryExist();
    if(_friendDisplayExpectList.length != 0){
      return buildFriendListView();
    }
    else{
      return Center(
        child: Container(
          child: Text('検索したいユーザーネームを入力してください'),
        ),
      );
    }
  }


  Widget buildFriendListView(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _friendDisplayExpectList.length,
            itemBuilder: (context, index){
              return StyledFriendItem(
                  _friendDisplayExpectList[index].getIconFromPath(),
                  _friendDisplayExpectList[index].userName,
                  _friendDisplayExpectList[index].userComment,
                  (){
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FriendDetailPage(_friendDisplayExpectList[index].userID)));
                  }
              );
            }
        ),
      ),
    );
  }
  void observeQueryExist(){
    _friendList.forEach((element) {
      if(query != ''){
        if(element.userName.contains(query) && !_friendDisplayExpectList.contains(element)){
          _friendDisplayExpectList.add(element);
        }
        else if(!element.userName.contains(query) && _friendDisplayExpectList.contains(element)){
          _friendDisplayExpectList.remove(element);
        }
      }
      else{
        _friendDisplayExpectList.remove(element);
      }
    });
  }
}