import 'dart:io';
import 'package:child_safety01/rooted/friend/add_friend_id_page.dart';
import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/system/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddFriendQRPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AddFriendQRPageState();
}

class _AddFriendQRPageState extends State<AddFriendQRPage>{
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docSnap = FirebaseFirestore.instance.collection('users');
  dynamic friendList = [];
  String? targetID;
  String? targetName;
  String? targetIcon;
  bool isExist = false;
  bool doOnce = false;

  //QR関連フィールド
  Barcode? barcode;
  QRViewController? controller;
  final qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    initFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              child: buildQrView(context)
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'QRコードをスキャンして\n友達追加機能を利用することができます。',
                  style: TextStyle(
                    fontFamily: 'MPlusR',
                    fontSize: 14,
                    color: ColorBase().SubGray(),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: 100,
                  child: OutlinedButton(
                    child: Text('ID検索'),
                    onPressed: (){
                      this.closeCameraAndStream().then((value) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddFriendIdPage()),
                        ),
                      });
                    },
                    style: buttonStyle(),
                  ),
                ),
                Container(
                  width: 100,
                  child: OutlinedButton(
                    child: Text('マイQR'),
                    onPressed: (){
                      buildMyQRModal();
                    },
                    style: buttonStyle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  //----------------------- ウィジェットビルド ----------------------------
  void buildMyQRModal(){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height *0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: uid,
              size: 200,
              backgroundColor: Colors.white,
            ),
            Container(
              width: 150,
              child: OutlinedButton(
                child: Text('キャンセル'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
                style: buttonStyle(),
              ),
            ),
          ],
        ),
      );
    },isScrollControlled: true
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

  //QRViewウィジェット
  Widget buildQrView(BuildContext context) => QRView(
    key: qrKey,
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      borderRadius: 10,
      borderWidth: 10,
      cutOutSize: MediaQuery.of(context).size.width*0.8,
    ),
  );


  //---------------------- フレンド追加処理 ---------------------------
  initFriendList() async{
    final field = await docSnap.doc(uid).get();
    friendList = field.get('friend_list');
  }

  //スキャン完了時に呼び出される
  void scanCompleted(BuildContext context, String targetId) async{
    this.targetID = targetId;
    isExist = false;

    friendList.forEach((element) => {if(element == targetID){isExist = true}});
    if(!isExist){
      final field = await docSnap.doc(targetID).get();
      Map<String, dynamic> mapRef = await field['user_info'];
      this.targetName = mapRef['user_name'];
      this.targetIcon = mapRef['user_icon'];
      buildTargetAcceptModal(context, targetName, targetIcon);
    }
  }

  //許可のモーダルウィンドウを表示
  void buildTargetAcceptModal(BuildContext context, String? targetName, String? targetIcon){
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 55,
              height: 55,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: Image.network(targetIcon.toString()).image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('$targetNameさんを友達に追加しますか？'),
            ),
            Container(
              width: 150,
              child: OutlinedButton(
                child: Text('友達追加'),
                style: buttonStyle(),
                onPressed: (){
                  //サーバーに保存
                  docSnap.doc(uid).update({
                    'friend_list': FieldValue.arrayUnion([targetID]),
                  });
                  docSnap.doc(targetID).update({
                    'friend_list': FieldValue.arrayUnion([uid]),
                  });
                  //閉じてから遷移
                  this.closeCameraAndStream().then((value) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FriendListPage()),
                    ),
                  });
                },
              ),
            ),
            Container(
              width: 150,
              child: OutlinedButton(
                child: Text('キャンセル'),
                style: buttonStyle(),
                onPressed: (){
                  this.closeCameraAndStream().then((value) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFriendQRPage()),
                    ),
                  });
                },
              ),
            ),
          ],
        ),
      );
    },isScrollControlled: true
    );
  }

  //--------------------- QRスキャン処理 -----------------------
  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }
  @override
  void reassemble() async{
    super.reassemble();
    if(Platform.isAndroid){
      await controller!.pauseCamera();
    }
    else if(Platform.isIOS){
      await controller!.resumeCamera();
    }
  }
  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        if(!doOnce){
          doOnce = true;
          this.barcode = barcode;
          scanCompleted(context, barcode.code);
        }
      });
    });
  }

  Future closeCameraAndStream() async{
    controller!.dispose();
    await controller!.stopCamera();
    controller = null;
  }
}