import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'enum.dart';
import 'master.dart';


class System{
  final docRef = FirebaseFirestore.instance.collection('users');
  final uid = FirebaseAuth.instance.currentUser!.uid;

  //ドキュメントフィールドのリセット
  Future resetDocumentField() async{
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'user_info': {
        'user_comment': '',
        'user_exp': '',
        'user_icon': '',
        'user_name': '',
        'user_id': uid,
        'is_logout': false,
      },
      'child_info': {
        '0':{
          'child_order':'',
          'child_icon':'',
          'child_name':'',
          'child_birth':'',
          'child_fav': '',
          'child_hate': '',
          'child_aller': '',
          'child_person': '',
          'child_exe': '',
        }
      },
    });
  }

  //フレンドリクエストの状態を取得
  Future<RequestUnit> getRequestState(List<dynamic> myFriendList, List<dynamic> myRequireList, String searchID) async {
    var targetDoc = await docRef.doc(searchID).get();
    if(!targetDoc.exists){
      return RequestUnit("ユーザーIDが見つかりませんでした", RequestState.IsNotExist);
    }
    if(targetDoc.id == uid){
      return RequestUnit("自身をフレンドリストには追加できません", RequestState.IsSelfID);
    }
    final targetFriendRequireList = await targetDoc.get('friend_require');
    for(var target in targetFriendRequireList){
      if(target.toString() == uid){
        return RequestUnit("申請済みです。承認をお待ちください", RequestState.IsMultipleRequire);
      }
    }
    for(var target in myRequireList){
      if(target.toString() == uid){
        return RequestUnit("申請済みです。承認をお待ちください", RequestState.IsMultipleRequire);
      }
    }
    for(var myFriend in myFriendList){
      if(myFriend.toString() == searchID){
        return RequestUnit("フレンドリストに追加されています", RequestState.IsInFriendList);
      }
    }
    final requestTarget = MasterPartialInfo(await targetDoc.get('user_info'));
    if(requestTarget.isLogout){
      return RequestUnit("ログアウト中のユーザーには申請を行えません", RequestState.IsLogout);
    }

    String name = requestTarget.userName;
    return RequestUnit("$nameさんへフレンド申請を行いますか？", RequestState.Accept);
  }
}
class RequestUnit{
  RequestUnit(this.logMessage, this.requestState);
  late String logMessage;
  late RequestState requestState;
}