import 'dart:io';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/utility/system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRScanModel extends ChangeNotifier{
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance.collection('users');
  late final List<dynamic> myFriendList;
  late final List<dynamic> myFriendRequireList;
  late final QRViewController controller;
  String scanBarcode = '';
  bool isLoading = true;

  Future initQRScanModel(BuildContext context) async{
    final myDocSnap = await docRef.doc(uid).get();
    myFriendList = await myDocSnap.get('friend_list');
    myFriendRequireList = await myDocSnap.get('friend_require');

    var accept = await PermissionManager().isAcceptThePermission(Permission.mediaLibrary);
    if(!accept){
      DisplayDialog('利用許可がありません', '設定画面からカメラの利用を許可してください', '設定画面へ', context, (){
        openAppSettings();
      });
    }
    isLoading = false;
    notifyListeners();
  }

  Future saveUIDToBothField() async{
    docRef.doc(uid).update({
      'friend_list': FieldValue.arrayUnion([scanBarcode]),
    });
    docRef.doc(scanBarcode).update({
      'friend_list': FieldValue.arrayUnion([uid]),
    });
  }

  Future resumeCamera(QRViewController controller) async{
    this.controller = controller;
    if(Platform.isAndroid){
      await controller.pauseCamera();
    }
    else if(Platform.isIOS){
      await controller.resumeCamera();
    }
  }
  Future closeCameraAndStream() async{
    controller.dispose();
    await controller.stopCamera();
  }
}