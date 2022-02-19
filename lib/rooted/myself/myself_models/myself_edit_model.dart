import 'dart:io';
import 'package:child_safety01/system/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';


class MySelfDataEditModel extends ChangeNotifier{
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance.collection('users');
  late MasterCompletedInfo userCompletedInfo;

  DisplayStateSimple displayState = DisplayStateSimple.IsDisable;

  Future initUserData() async{

    final DocumentSnapshot docSnap = await docRef.doc(userId).get();
    final Map<String, dynamic> userMap = await docSnap.get('user_info');
    final Map<String, dynamic> childMap = await docSnap.get('child_info');

    userCompletedInfo = MasterCompletedInfo(userMap, childMap);
    displayState = DisplayStateSimple.IsEnable;
    notifyListeners();
  }

  // ■ ユーザーアイコンの選択・保存
  Future getImageProviderFromPickedImage() async{
    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFile = File(pickerFile!.path);

    final snap = await FirebaseStorage.instance.ref().child('users_icon/$userId/').putFile(pickedFile);
    final String downloadUrl = await snap.ref.getDownloadURL();
    userCompletedInfo.iconPath = downloadUrl;

    docRef.doc(userId).update({
      'user_info.user_icon': userCompletedInfo.iconPath,
    });
    notifyListeners();
  }
  // ■ チャイルドアイコンの選択・保存
  Future getChildImageProviderFromPickedImage(int index) async{
    final picker = ImagePicker();
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    final pickedFile =  File(pickerFile!.path);

    String childID = userCompletedInfo.childInfoList[index].childID;
    final snap = await FirebaseStorage.instance.ref().child('users_icon/children-icon-$userId/$childID').putFile(pickedFile);
    final String downloadUrl = await snap.ref.getDownloadURL();
    userCompletedInfo.childInfoList[index].iconPath = downloadUrl;

    docRef.doc(userId).update({
      'child_info.$childID.child_icon' : downloadUrl,
    });
    notifyListeners();
  }

  // ■ ユーザー入力内容の保存
  Future updateSelfField() async{
    await docRef.doc(userId).update({
      'user_info.user_comment': userCompletedInfo.userComment,
      'user_info.user_exp': userCompletedInfo.userExplain,
      'user_info.user_name': userCompletedInfo.userName,
      'user_info.user_icon': userCompletedInfo.iconPath,
    });
  }
  // ■ チャイルド入力内容の保存
  Future updateChildField(int index) async{
    String childID = userCompletedInfo.childInfoList[index].childID;
    await docRef.doc(userId).update({
      'child_info.$childID.child_order' : userCompletedInfo.childInfoList[index].childOrderString,
      'child_info.$childID.child_name' : userCompletedInfo.childInfoList[index].name,
      'child_info.$childID.child_aller' : userCompletedInfo.childInfoList[index].allergy,
      'child_info.$childID.child_birth' : userCompletedInfo.childInfoList[index].birth,
      'child_info.$childID.child_exe' : userCompletedInfo.childInfoList[index].etc,
      'child_info.$childID.child_fav' : userCompletedInfo.childInfoList[index].favoriteFood,
      'child_info.$childID.child_hate' : userCompletedInfo.childInfoList[index].hateFood,
      'child_info.$childID.child_person' : userCompletedInfo.childInfoList[index].personality,
      'child_info.$childID.child_icon' : userCompletedInfo.childInfoList[index].iconPath,
    });
  }

  // ■ チャイルドの追加
  Future addChildMap() async{
    String newChildID = userCompletedInfo.getLatestID();
    await docRef.doc(userId).update({
      'child_info.$newChildID':{
        'child_order':'',
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
    userCompletedInfo.addChildDetailToList(newChildID);
    notifyListeners();
  }
  // ■ チャイルドの削除
  Future removeChildMap(int index) async{
    String childID = userCompletedInfo.childInfoList[index].childID;
    if(isEnableToRemoveChild()){
      await docRef.doc(userId).update({
        'child_info.$childID' : FieldValue.delete()
      });
      userCompletedInfo.removeChildDetailFromListDueToID(childID);
      notifyListeners();
    }
  }


  bool isEnableToRemoveChild(){
    int childLength = userCompletedInfo.childInfoList.length;
    if(childLength > 1){
      return true;
    }
    else return false;
  }
}