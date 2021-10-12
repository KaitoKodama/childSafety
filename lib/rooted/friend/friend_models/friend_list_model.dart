import 'package:child_safety01/system/inheritance_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../friend_list_page.dart';


class FriendListModel extends ChangeNotifier{
  String userid = FirebaseAuth.instance.currentUser!.uid;
  final docSnap = FirebaseFirestore.instance.collection('users');

  List friend = [];
  List<UserDetail> friendInformation = [];

  bool isLoading = true;


  Future fetchFriends() async{
    final field = await docSnap.doc(userid).get();
    this.friend = field.get('friend_list').toList();

    //取得した値を保持するリストを生成する
    for(var i = 0; i <friend.length; i++){
      DocumentSnapshot docRef = await FirebaseFirestore.instance.collection('users').doc(friend[i]).get();
      //ドキュメントが存在する場合のみ追加
      if(docRef.data() != null){
        Map<String, dynamic> mapRef = docRef['user_info'];
        final info = UserDetail(mapRef);
        friendInformation.add(info);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  //フレンドリストからターゲットを削除
  Future deleteFriendFromList(int index) async{
    String removeTarget = friendInformation[index].userID.toString();
    await docSnap.doc(userid).update({
      'friend_list': FieldValue.arrayRemove([removeTarget]),
    });
  }

}


class FriendListSearch extends SearchDelegate<String>{
  FriendListSearch(this.model): super(searchFieldLabel: '検索');
  FriendListModel model;

  List<int> displayIndex = [];
  List nameList = [];

  void setupBuildVariable(){
    displayIndex = [];
    nameList = [];

    model.friendInformation.forEach((element) => {
      nameList.add(element.userName),
    });

    if(query.isNotEmpty){
      //クエリに文字列ある場合はそれを含む要素のみを表示
      for(var i = 0; i<nameList.length; i++){
        if(nameList[i].toString().contains(query)){
          displayIndex.add(i);
        }
      }
    }
    else{
      //クエリが空の場合は全要素を表示
      for(var i = 0; i<nameList.length; i++){
        displayIndex.add(i);
      }
    }
  }


  //--------- オーバーライド ---------
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            query = '';
          }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left),
      onPressed: (){
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if(displayIndex.length <= 0){
      return Container(
        alignment: Alignment.center,
        child: Text(
          'お名前は見つかりませんでした',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'MPlus',
          ),
        ),
      );
    }
    else{
      setupBuildVariable();
      return FriendListPageState().createSearchedFriendList(displayIndex, model);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    setupBuildVariable();
    return FriendListPageState().createSearchedFriendList(displayIndex, model);
  }
}