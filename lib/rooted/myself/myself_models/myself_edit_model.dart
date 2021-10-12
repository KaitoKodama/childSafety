import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';



//------------ 格納用列挙 ------------
enum MyselfEditField{
  Name,
  Comment,
  Introduce
}
enum ChildInputState{
  Name,
  Birth,
  Aller,
  FavFood,
  HateFood,
  Person,
  Exe,
}

//------------------- 情報格納(インスタンス化)用クラス --------------------
//ユーザー情報用クラス
class MyselfDetail{
  MyselfDetail(Map<String, dynamic> mapRef){
    this.userName = mapRef['user_name'];
    this.userComment = mapRef['user_comment'];
    this.userExplain = mapRef['user_exp'];
    this.userIconPath = mapRef['user_icon'];
    this.isSaved = true;
  }
  String? userName;
  String? userComment;
  String? userExplain;
  String? userIconPath;
  bool? isSaved;
}
//ユーザーの子供情報用クラス
class MyselfChildDetail{
  MyselfChildDetail(Map<String, dynamic> mapRef){
    this.childIcon = mapRef['child_icon'];
    this.childName = mapRef['child_name'];
    this.childBirth = mapRef['child_birth'];

    this.childFavFood = mapRef['child_fav'];
    this.childHateFood = mapRef['child_hate'];
    this.childAllergy = mapRef['child_aller'];
    this.childPersonality = mapRef['child_person'];
    this.childExe = mapRef['child_exe'];
    this.isSaved = true;
  }
  String? childIcon;
  String? childName;
  String? childBirth;

  String? childFavFood;
  String? childHateFood;
  String? childAllergy;
  String? childPersonality;
  String? childExe;
  bool? isSaved;
}


//------------ 非同期・同期処理(ChangeNotifier)編集メインクラス ---------------
class MySelfDataEditModel extends ChangeNotifier{
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final docSnap = FirebaseFirestore.instance.collection('users');

  MyselfDetail?myselfDetail;
  List<MyselfChildDetail> myselfChildDetail = [];

  bool isLoading = false;
  bool isExistData02 = false;


  //----------------------- メイン処理のメソッド ----------------------------
  Future fetchCurrentData() async{
    isLoading = true;

    final field = await docSnap.doc(userId).get();
    //ユーザー情報を取得・格納
    Map<String, dynamic> userInfo = await field.get('user_info');
    this.myselfDetail = MyselfDetail(userInfo);

    //ユーザーの子供情報を取得・格納
    Map<String, dynamic> childInfo = await field.get('child_info');

    //child_infoに含まれている要素数が2以上なら追加ビルド用真偽をtrueに
    if(childInfo.length > 1){
      this.isExistData02 = true;
    }

    //各、子供情報のインスタンスをリスト化する
    for(var i = 0; i<childInfo.length; i++){
      String expectStr = 'data0'+(i+1).toString();
      Map<String, dynamic> mapRef = childInfo[expectStr];
      final info = MyselfChildDetail(mapRef);
      myselfChildDetail.add(info);
    }
    isLoading = false;

    notifyListeners();
  }

  //--------------- 画像選択・格納用メソッド -----------------
  Future showSelfImagePicker() async{
    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFile = File(pickerFile!.path);

    final snap = await FirebaseStorage.instance.ref().child('users_icon/$userId/').putFile(pickedFile);
    final String downloadUrl = await snap.ref.getDownloadURL();
    myselfDetail!.userIconPath = downloadUrl;
    myselfDetail!.isSaved = false;

    notifyListeners();
  }
  Future showSelfChildImagePicker(int index) async{
    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFile =  File(pickerFile!.path);

    final String folderStr = 'data0'+(index+1).toString();
    final snap = await FirebaseStorage.instance.ref().child('users_icon/children-icon-$userId/$folderStr/').putFile(pickedFile);
    final String downloadUrl = await snap.ref.getDownloadURL();
    myselfChildDetail[index].childIcon = downloadUrl;
    myselfChildDetail[index].isSaved = false;

    notifyListeners();
  }

  //--------------------------- 更新系メソッド ---------------------------
  //自身のデータを格納更新するメソッド
  Future updateSelfField() async{
    myselfDetail!.isSaved = true;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'user_info.user_comment': myselfDetail!.userComment,
      'user_info.user_exp': myselfDetail!.userExplain,
      'user_info.user_name': myselfDetail!.userName,
      'user_info.user_icon': myselfDetail!.userIconPath,
    });
    notifyListeners();
  }
  //自身の子供のデータをインデックス番号毎に更新するメソッド
  Future updateChildField(int index) async{
    myselfChildDetail[index].isSaved = true;
    //child_infoのキーとの整合性をここで補完
    String targetMapKey = 'data0'+(index+1).toString();
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'child_info.'+targetMapKey+'.child_name' : myselfChildDetail[index].childName,
      'child_info.'+targetMapKey+'.child_aller' : myselfChildDetail[index].childAllergy,
      'child_info.'+targetMapKey+'.child_birth' : myselfChildDetail[index].childBirth,
      'child_info.'+targetMapKey+'.child_exe' : myselfChildDetail[index].childExe,
      'child_info.'+targetMapKey+'.child_fav' : myselfChildDetail[index].childFavFood,
      'child_info.'+targetMapKey+'.child_hate' : myselfChildDetail[index].childHateFood,
      'child_info.'+targetMapKey+'.child_person' : myselfChildDetail[index].childPersonality,
      'child_info.'+targetMapKey+'.child_icon' : myselfChildDetail[index].childIcon,
    });
    notifyListeners();
  }


  //--------------------------- 追加・削除メソッド -----------------------------
  //追加
  Future addChildMap(int index) async{
    String nextKeyName = 'data0'+(index+2).toString();
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'child_info.'+nextKeyName: {
        'child_icon':'',
        'child_name':'',
        'child_birth':'',
        'child_fav': '',
        'child_hate': '',
        'child_aller': '',
        'child_person': '',
        'child_exe': '',
      },
    });
  }
  //削除
  void removeChildMap(int index){
    if(index >= 1){
      String removeKeyName = 'data0'+(index+1).toString();
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'child_info.'+removeKeyName: FieldValue.delete()
      });
    }
  }


  //---------------- 特定の値を格納メソッド ---------------------
  void setMyselfDetailText(MyselfEditField state, String inputText){
    myselfDetail!.isSaved = false;
    switch(state){
      case MyselfEditField.Name:
        myselfDetail!.userName = inputText;
        break;
      case MyselfEditField.Comment:
        myselfDetail!.userComment = inputText;
        break;
      case MyselfEditField.Introduce:
        myselfDetail!.userExplain = inputText;
        break;
      default:
    }
  }
  String getMyselfDetailText(MyselfEditField state){
    switch(state){
      case MyselfEditField.Name:
        return myselfDetail!.userName.toString();
      case MyselfEditField.Comment:
        return myselfDetail!.userComment.toString();
      case MyselfEditField.Introduce:
        return myselfDetail!.userExplain.toString();
    }
  }

  void setSpecificChildFieldStr(int index,  String changedTxt, ChildInputState state){
    myselfChildDetail[index].isSaved = false;
    switch (state){
      case ChildInputState.Name:
        myselfChildDetail[index].childName = changedTxt;
        break;
      case ChildInputState.Exe:
        myselfChildDetail[index].childExe = changedTxt;
        break;
      case ChildInputState.HateFood:
        myselfChildDetail[index].childHateFood = changedTxt;
        break;
      case ChildInputState.FavFood:
        myselfChildDetail[index].childFavFood = changedTxt;
        break;
      case ChildInputState.Birth:
        myselfChildDetail[index].childBirth = changedTxt;
        break;
      case ChildInputState.Aller:
        myselfChildDetail[index].childAllergy = changedTxt;
        break;
      case ChildInputState.Person:
        myselfChildDetail[index].childPersonality = changedTxt;
        break;
    }
  }
  String getSpecificChildFieldStr(int index, ChildInputState state){
    switch (state){
      case ChildInputState.Name:
        return myselfChildDetail[index].childName.toString();
      case ChildInputState.Exe:
        return myselfChildDetail[index].childExe.toString();
      case ChildInputState.HateFood:
        return myselfChildDetail[index].childHateFood.toString();
      case ChildInputState.FavFood:
        return myselfChildDetail[index].childFavFood.toString();
      case ChildInputState.Birth:
        return myselfChildDetail[index].childBirth.toString();
      case ChildInputState.Aller:
        return myselfChildDetail[index].childAllergy.toString();
      case ChildInputState.Person:
        return myselfChildDetail[index].childPersonality.toString();
    }
  }
}