import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

/* ---------------------------------------
 列挙型
---------------------------------------- */
//■ 表示ステート
enum DisplayState{
  IsLoading,
  FriendExist,
  FriendDoesNotExist,
}
enum DisplayStateSimple{
  IsDisable,
  IsEnable,
}
//■ 出生順
enum ChildOrder{
  male01,
  male02,
  male03,
  male04,
  male05,
  female01,
  female02,
  female03,
  female04,
  female05,
}


/* ---------------------------------------
 マスター情報一部
---------------------------------------- */
class MasterPartialInfo{
  MasterPartialInfo(Map<String, dynamic> mapRef){
    if(mapRef['user_icon'] != ''){
      this.iconPath = mapRef['user_icon'];
    }
    if(mapRef['user_id'] != ''){
      this._userID = mapRef['user_id'];
    }
    if(mapRef['user_name'] != ''){
      this.userName = mapRef['user_name'];
    }
    if(mapRef['user_comment'] != ''){
      this.userComment = mapRef['user_comment'];
    }
    if(mapRef['is_logout'] != ''){
      this._isLogout = mapRef['is_logout'];
    }
  }

  String _userID = '';
  bool _isLogout = false;

  String get userID => _userID;
  bool get isLogout => _isLogout;

  String iconPath = '';
  String userName = '-';
  String userComment = '-';
  ImageProvider getIconFromPath(){
    ImageProvider _icon;
    if(iconPath != ''){
      _icon = Image.network(iconPath).image;
    }
    else{
      _icon = Image.asset('images/base-icon.png').image;
    }
    return _icon;
  }
}


/* ---------------------------------------
 マスター情報完全
---------------------------------------- */
class MasterCompletedInfo extends MasterPartialInfo{
  MasterCompletedInfo(Map<String, dynamic> mapRef, Map<String, dynamic> childMap) : super(mapRef){
    if(mapRef['user_exp'] != ''){
      this.userExplain = mapRef['user_exp'];
    }
    childMap.forEach((key, value){
      _childInfoList.add(ChildDetail(value, key));
    });
  }

  List<ChildDetail> _childInfoList = [];
  String userExplain = '-';

  List<ChildDetail> get childInfoList => _childInfoList;

  String getLatestID(){
    List<int> childIDList = [];
    _childInfoList.forEach((element) {
      childIDList.add(int.parse(element.childID));
    });
    String latestID = (childIDList.reduce(max)+1).toString();
    return latestID;
  }
  void addChildDetailToList(String targetID){
    _childInfoList.add(ChildDetail({}, targetID));
  }
  void removeChildDetailFromListDueToID(String removeID){
    var removeElement;
    _childInfoList.forEach((element) {
      if(element.childID == removeID){
        removeElement = element;
      }
    });
    if(removeElement != null){
      _childInfoList.remove(removeElement);
    }
  }
}

// ■ お子様情報
class ChildDetail{
  ChildDetail(Map<String, dynamic> mapRef, String childID){
    this.childID = childID;
    if(mapRef.isNotEmpty){
      if(mapRef['child_order'] != ''){
        this._childOrderString = mapRef['child_order'];
      }
      if(mapRef['child_icon'] != ''){
        this.iconPath = mapRef['child_icon'];
      }
      if(mapRef['child_name'] != ''){
        this.name = mapRef['child_name'];
      }
      if(mapRef['child_birth'] != ''){
        this.birth = mapRef['child_birth'];
      }
      if(mapRef['child_fav'] != ''){
        this.favoriteFood = mapRef['child_fav'];
      }
      if(mapRef['child_hate'] != ''){
        this.hateFood = mapRef['child_hate'];
      }
      if(mapRef['child_aller'] != ''){
        this.allergy = mapRef['child_aller'];
      }
      if(mapRef['child_person'] != ''){
        this.personality = mapRef['child_person'];
      }
      if(mapRef['child_exe'] != ''){
        this.etc = mapRef['child_exe'];
      }

      switch(_childOrderString){
        case '長男':
          _orderState = ChildOrder.male01;
          break;
        case '次男':
          _orderState = ChildOrder.male02;
          break;
        case '三男':
          _orderState = ChildOrder.male03;
          break;
        case '四男':
          _orderState = ChildOrder.male04;
          break;
        case '五男':
          _orderState = ChildOrder.male05;
          break;
        case '長女':
          _orderState = ChildOrder.female01;
          break;
        case '次女':
          _orderState = ChildOrder.female02;
          break;
        case '三女':
          _orderState = ChildOrder.female03;
          break;
        case '四女':
          _orderState = ChildOrder.female04;
          break;
        case '五女':
          _orderState = ChildOrder.female05;
          break;
      }
    }
  }

  ChildOrder _orderState = ChildOrder.male01;
  String _childOrderString = '長男';
  String childID = '';
  String iconPath = '';
  String name = '-';
  String birth = '-';
  String favoriteFood = '-';
  String hateFood = '-';
  String allergy = '-';
  String personality = '-';
  String etc = '-';


  ChildOrder get orderState => _orderState;
  String get childOrderString => _childOrderString;
  ImageProvider getIconFromPath(){
    ImageProvider _icon = Image.asset('images/base-icon.png').image;
    if(iconPath != ''){
      _icon = Image.network(iconPath).image;
    }
    return _icon;
  }
  void setChildOrderState(ChildOrder order){
    this._orderState = order;
    switch(order){
      case ChildOrder.male01:
        this._childOrderString = '長男';
        break;
      case ChildOrder.male02:
        this._childOrderString = '次男';
        break;
      case ChildOrder.male03:
        this._childOrderString = '三男';
        break;
      case ChildOrder.male04:
        this._childOrderString = '四男';
        break;
      case ChildOrder.male05:
        this._childOrderString = '五男';
        break;
      case ChildOrder.female01:
        this._childOrderString = '長女';
        break;
      case ChildOrder.female02:
        this._childOrderString = '次女';
        break;
      case ChildOrder.female03:
        this._childOrderString = '三女';
        break;
      case ChildOrder.female04:
        this._childOrderString = '四女';
        break;
      case ChildOrder.female05:
        this._childOrderString = '五女';
        break;
    }
  }
}

/* ---------------------------------------
 ユーザー情報
---------------------------------------- */
class UserDetail{
  UserDetail(Map<String, dynamic> mapRef){
    this.userID = mapRef['user_id'];
    this.userName = mapRef['user_name'];
    this.userComment = mapRef['user_comment'];
    this.userExplain = mapRef['user_exp'];
    this.userIconPath = mapRef['user_icon'];
    this.isLogout = mapRef['is_logout'];
    this.isSaved = true;
  }
  String? userID;
  String? userName;
  String? userComment;
  String? userExplain;
  String? userIconPath;
  bool? isLogout;
  bool? isSaved;
}



/* ---------------------------------------
 ドキュメントフィールドの更新
---------------------------------------- */
class FitDocumentField{
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Future updateRequire() async{
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
}


/* ---------------------------------------
 ニュースページ(削除予定)
---------------------------------------- */
class MyselfIncNews{
  MyselfIncNews(Map<String, dynamic> mapRef){
    this.title = mapRef['title'];
    this.content = mapRef['content'];
  }
  String? title;
  String? content;
}