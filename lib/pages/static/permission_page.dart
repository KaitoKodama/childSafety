import 'package:child_safety01/component/cp_button.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget{
  @override
  PermissionPageState createState() => PermissionPageState();
}

class PermissionPageState extends State<PermissionPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: ApplicationHead(context),
      body: buildScreenWidget(),
      bottomNavigationBar: ApplicationFoot(),
    );
  }

  Widget buildScreenWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 45),
            child: Icon(Icons.lock_outline, size: 90),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text('このAppには写真およびカメラへのアクセス権がありません。', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 45),
            child: Text('「プライバシー設定」でアクセスを有効にできます', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          ),
          StyledButton('設定に移動する', HexColor('#1595B9'), Theme.of(context).canvasColor, Theme.of(context).canvasColor, ()=>{
            openAppSettings(),
          }),
          StyledButton('キャンセル', HexColor('#707070'), Theme.of(context).canvasColor, Theme.of(context).canvasColor, ()=>{
            Navigator.of(context).pop(),
          }),
        ],
      ),
    );
  }
}