import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'enum.dart';


/* ---------------------------------------
 マスター情報
---------------------------------------- */
class MasterPartialInfo{
  MasterPartialInfo(Map<String, dynamic> mapRef){
    virtualInitFixRequireOnlySelfID('user_icon', iconPath,()=>{
      if(mapRef['user_icon'] != '') this.iconPath = mapRef['user_icon']
    });
    virtualInitFixRequireOnlySelfID('user_id', userID,()=>{
      if(mapRef['user_id'] != '') this.userID = mapRef['user_id']
    });
    virtualInitFixRequireOnlySelfID('user_name', userName,()=>{
      if(mapRef['user_name'] != '') this.userName = mapRef['user_name']
    });
    virtualInitFixRequireOnlySelfID('user_comment', userComment,()=>{
      if(mapRef['user_comment'] != '') this.userComment = mapRef['user_comment']
    });
    virtualInitFixRequireOnlySelfID('user_exp', userExplain,()=>{
      if(mapRef['user_exp'] != '') this.userExplain = mapRef['user_exp']
    });
    virtualInitFixRequireOnlySelfID('latest_news', latestNewsID,()=>{
      if(mapRef['latest_news'] != '') this.latestNewsID = mapRef['latest_news']
    });
    virtualInitFixRequireOnlySelfID('is_logout', isLogout,()=>{
      if(mapRef['is_logout'] != '') this.isLogout = mapRef['is_logout']
    });
  }
  final uid = FirebaseAuth.instance.currentUser!.uid;
  String userID = '';
  String iconPath = '';
  String userName = '-';
  String userComment = '-';
  String userExplain = '-';
  int latestNewsID = 0;
  bool isLogout = false;
  bool isProviding = false;

  ImageProvider getIconFromPath(){
    if(iconPath != '') return Image.network(iconPath, filterQuality: FilterQuality.low).image;
    else return Image.asset('images/base-icon.png').image;
  }
  Future virtualInitFixRequireOnlySelfID(String targetField, dynamic targetValue, Function tryAction) async{
    try{ tryAction(); }
    catch(exe){
      if(uid == userID && userID != ''){
        await FirebaseFirestore.instance.collection('users').doc(userID).update({
          'user_info.$targetField': targetValue,
        });
      }
    }
  }
}


/* ---------------------------------------
 マスター情報モジュール
---------------------------------------- */
class MasterCompletedInfo extends MasterPartialInfo{
  MasterCompletedInfo(Map<String, dynamic> mapRef, Map<String, dynamic> childMap) : super(mapRef){
    childMap.forEach((childID, map){
      childInfoList.add(ChildDetail(map, childID));
    });
  }
  List<ChildDetail> childInfoList = [];
  String getLatestID(){
    List<int> childIDList = [];
    childInfoList.forEach((element) {
      childIDList.add(int.parse(element.childID));
    });
    String latestID = (childIDList.reduce(max)+1).toString();
    return latestID;
  }

  void addChildDetailToList(String targetID){
    childInfoList.add(ChildDetail({}, targetID));
  }
  void removeChildDetailFromListDueToID(String removeID){
    var removeElement;
    childInfoList.forEach((element) {
      if(element.childID == removeID){
        removeElement = element;
      }
    });
    if(removeElement != null){
      childInfoList.remove(removeElement);
    }
  }
}

/* ---------------------------------------
 お子様情報
---------------------------------------- */
class ChildDetail{
  ChildDetail(Map<String, dynamic> mapRef, String childID){
    this.childID = childID;
    if(mapRef.isNotEmpty){
      if(mapRef['child_order'] != '') orderUnitList.initSelectUnit(mapRef['child_order']);
      if(mapRef['child_icon'] != '') this.iconPath = mapRef['child_icon'];
      if(mapRef['child_name'] != '') this.name = mapRef['child_name'];
      if(mapRef['child_birth'] != '') this.birth = mapRef['child_birth'];
      if(mapRef['child_fav'] != '') this.favoriteFood = mapRef['child_fav'];
      if(mapRef['child_hate'] != '') this.hateFood = mapRef['child_hate'];
      if(mapRef['child_aller'] != '') this.allergy = mapRef['child_aller'];
      if(mapRef['child_person'] != '') this.personality = mapRef['child_person'];
      if(mapRef['child_exe'] != '') this.etc = mapRef['child_exe'];
    }
  }
  ChildOrderUnitList orderUnitList = new ChildOrderUnitList();
  String childID = '';
  String iconPath = '';
  String name = '-';
  String birth = '-';
  String favoriteFood = '-';
  String hateFood = '-';
  String allergy = '-';
  String personality = '-';
  String etc = '-';
  bool isProviding = false;

  ImageProvider getIconFromPath(){
    ImageProvider _icon;
    if(iconPath != ''){
      _icon = Image.network(iconPath, filterQuality: FilterQuality.low).image;
    }
    else{
      _icon = Image.asset('images/base-icon.png').image;
    }
    return _icon;
  }
}


/* ---------------------------------------
 続き柄ユニット情報
---------------------------------------- */
class ChildOrderUnitList{
  List<ChildOrderUnit> unitList=[
    ChildOrderUnit('長男', ChildOrder.male01),
    ChildOrderUnit('次男', ChildOrder.male02),
    ChildOrderUnit('三男', ChildOrder.male03),
    ChildOrderUnit('四男', ChildOrder.male04),
    ChildOrderUnit('五男', ChildOrder.male05),
    ChildOrderUnit('長女', ChildOrder.female01),
    ChildOrderUnit('次女', ChildOrder.female02),
    ChildOrderUnit('三女', ChildOrder.female03),
    ChildOrderUnit('四女', ChildOrder.female04),
    ChildOrderUnit('五女', ChildOrder.female05),
  ];
  ChildOrderUnit selectUnit = ChildOrderUnit('長男', ChildOrder.male01);

  void initSelectUnit(String name){
    for(var unit in unitList){
      if(unit.name == name){
        selectUnit = unit;
        return;
      }
    }
  }
  void setUnitFromEnum(ChildOrder order){
    for(var unit in unitList){
      if(unit.order == order){
        selectUnit = unit;
        return;
      }
    }
  }
}
class ChildOrderUnit{
  ChildOrderUnit(this.name, this.order);
  String name;
  ChildOrder order;
}


/* ---------------------------------------
 ニュースユニット情報
---------------------------------------- */
class NewsUnit{
  NewsUnit(dynamic newsSnap){
    if(newsSnap['time'] != null) timeStamp = newsSnap['time'];
    if(newsSnap['title'] != null) title = newsSnap['title'];
    if(newsSnap['content'] != null) content = newsSnap['content'];
  }
  String timeStamp = '';
  String title = '';
  String content = '';
}