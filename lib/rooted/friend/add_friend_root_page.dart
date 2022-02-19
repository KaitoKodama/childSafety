import 'package:child_safety01/rooted/friend/add_friend_id_page.dart';
import 'package:child_safety01/rooted/friend/add_friend_qr_page.dart';
import 'package:child_safety01/system/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class AddFriendRootPage extends StatefulWidget{
  @override
  _AddFriendRootPageState createState() => _AddFriendRootPageState();
}

class _AddFriendRootPageState extends State<AddFriendRootPage>{

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: ApplicationHead(context),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              children: [
                buttonWidget('ID検索', Icon(Icons.search_outlined), AddFriendIdPage()),
                buttonWidget('QR検索', Icon(Icons.qr_code_2_outlined), AddFriendQRPage()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmallPartsBase().textStyledBoolean('ID検索またはQR検索機能を用いて、友達を登録できます。', '', ColorBase().SubGray(), 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(String btnTtl, Icon icon, Widget route){
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 10, top: 30, bottom: 10),
      child: SizedBox(
        width: 80,
        height: 80,
        child: OutlinedButton(
          style: buttonStyle(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(btnTtl),
              icon,
            ],
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          },
        ),
      ),
    );
  }
  ButtonStyle buttonStyle(){
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      primary: Color.fromRGBO(19, 200, 188, 1.0),
      side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
    );
  }
}