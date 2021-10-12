import 'package:child_safety01/rooted/friend/friend_models/add_friend_id_model.dart';
import 'package:child_safety01/system/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';



class AddFriendIdPage extends StatefulWidget{
  @override
  _AddFriendIdPageState createState() => _AddFriendIdPageState();
}

//フレンドリスト表示ページ
class _AddFriendIdPageState extends State<AddFriendIdPage>{

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<AddFriendIdModel>(
      create: (_) => AddFriendIdModel(),
      child: Scaffold(
        appBar: Header(context),
        body: Consumer<AddFriendIdModel>(
          builder: (context, model, child){
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: WidgetBase().initialDecoration('友達のIDで検索'),
                          onChanged: (text){
                            model.inputText = text;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              SmallPartsBase().textStyledBoolean('マイID：'+model.uid, '', ColorBase().SubGray(), 14),
                              InkWell(
                                child: SizedBox(width: 30, height: 30, child: Icon(Icons.copy_all_outlined)),
                                onTap: () {
                                  model.copyToClipboard();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 8),
                    child: OutlinedButton(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text('検索'),
                      ),
                      style: buttonStyle(),
                      onPressed: (){
                        model.searchFriendID(context);
                      },
                    ),
                  ),
                ],
              ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}