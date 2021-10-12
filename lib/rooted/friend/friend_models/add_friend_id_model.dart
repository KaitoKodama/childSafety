import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/system/inheritance_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


enum SearchedState{
  Initial,
  NotExist,
  HasAlready,
  SendAlready,
  Logout,
  Mine,
  Addable,
}

class AddFriendIdModel extends ChangeNotifier{
  SearchedState searchedState = SearchedState.Initial;

  final docRef = FirebaseFirestore.instance.collection('users');
  String uid = FirebaseAuth.instance.currentUser!.uid;
  UserDetail?targetInfo;
  String? inputText;


  Future copyToClipboard() async{
    final data = ClipboardData(text: uid);
    await Clipboard.setData(data);
  }
  Future searchFriendID(BuildContext context) async{
    await setState();

    switch(searchedState){
      case SearchedState.Initial:
        createResultDialog(context, 'エラー\nフィルタリングに失敗しました。');
        break;
      case SearchedState.NotExist:
        createResultDialog(context, '存在しないIDです。\nIDを再確認し、再度検索を行ってください。');
        break;
      case SearchedState.HasAlready:
        createResultDialog(context, '既に登録済みのIDです。\nフレンドリストを確認ください。');
        break;
      case SearchedState.Mine:
        createResultDialog(context, '自身のIDです。\n自身をフレンドには登録できません。');
        break;
      case SearchedState.SendAlready:
        createResultDialog(context, '既にリクエストを送信済みです。\n承認され次第Shaildニュースに通知が届きます。');
        break;
      case SearchedState.Logout:
        createResultDialog(context, targetInfo!.userName.toString()+'さんは現在ログアウト中です。\nログアウト時はリクエストを送れません。');
        break;
      case SearchedState.Addable:
        createSuccessDialog(context);
        break;
    }
  }
  Future setState() async{
    final getDoc = await docRef.doc(inputText).get();

    if(getDoc.exists){
      if(getDoc.id == uid){
        //自身のIDステートに変更
        searchedState = SearchedState.Mine;
      }else{
        //送信済みステートに変更
        final targetDoc = await docRef.doc(inputText).get();
        List<dynamic> reqField = await targetDoc.get('friend_require');
        reqField.forEach((element) => {if(element.toString() == uid){ searchedState = SearchedState.SendAlready }});

        //登録済みステートに変更
        final ownDoc = await docRef.doc(uid).get();
        List<dynamic> friendList = await ownDoc.get('friend_list');
        friendList.forEach((element) => {if(element.toString() == inputText){ searchedState = SearchedState.HasAlready }});

        //格納可能ステートに変更
        if(searchedState == SearchedState.Initial){
          Map<String, dynamic> mapRef = await getDoc['user_info'];
          this.targetInfo = UserDetail(mapRef);

          if(targetInfo!.isLogout == true){
            //ログアウトステートに変更
            searchedState = SearchedState.Logout;
          }else{
            searchedState = SearchedState.Addable;
          }
        }
      }
    }
    else if(!getDoc.exists){
      //存在しないIDステートに変更
      searchedState = SearchedState.NotExist;
    }
  }


  Future addTargetFriendRequireField(BuildContext context) async{
    await FirebaseFirestore.instance.collection('users').doc(inputText).update({
      'friend_require': FieldValue.arrayUnion([uid]),
    });
    createResultDialog(context, '承認メッセージの送信を完了しました。\n承認され次第shaildニュースに通知が届きます。');
  }

  void createSuccessDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return Container(
          child: AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: 55,
                      height: 55,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: Image.network(targetInfo!.userIconPath.toString()).image,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(targetInfo!.userName.toString()+'さんへ友達申請を送りますか？'),
                  ),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                child: Text('友達申請'),
                style: buttonStyle(),
                onPressed: () async{
                  await addTargetFriendRequireField(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FriendListPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void createResultDialog(BuildContext context, String result){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Text(result),
          actions: [
            OutlinedButton(
              child: Text('OK'),
              style: buttonStyle(),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  ButtonStyle buttonStyle(){
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      primary: Color.fromRGBO(19, 200, 188, 1.0),
      side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}