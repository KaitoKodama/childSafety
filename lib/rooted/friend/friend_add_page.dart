import 'package:child_safety01/system/common.dart';
import 'package:child_safety01/system/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'friend_models/friend_add_model.dart';


class FriendAddPage extends StatefulWidget{
  @override
  FriendAddPageState createState() => FriendAddPageState();
}
class FriendAddPageState extends State<FriendAddPage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<FriendAddModel>(
      create: (_) => FriendAddModel(context)..initFriendRequire(),
      child: Scaffold(
        appBar: ApplicationHead(context),
        body: Consumer<FriendAddModel>(
          builder: (context, model, child) {
            switch(model.displayState){
              case DisplayStateSimple.IsDisable:
                return buildDisableWidget();
              case DisplayStateSimple.IsEnable:
                return buildEnableWidget(model);
            }
          },
        ),
        bottomNavigationBar: ApplicationFoot(),
      ),
    );
  }

  Widget buildDisableWidget(){
    return BuildWidget().buildLoadingDialog(context);
  }
  Widget buildEnableWidget(FriendAddModel model){
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text('MAPAKOにフレンドを追加する', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 18)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('ユーザーIDで検索・追加', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#1595B9'), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset('images/icon_search.svg'),
                      ),
                      Expanded(
                        child: TextFormField(
                          onChanged: (text)=>{ model.searchText = text },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(bottom: 10),
                            labelStyle: TextStyle(fontSize: 14, color: HexColor('#AAAAAA'),fontFamily: 'MPlusR'),
                            hintStyle: TextStyle(fontSize: 14, color: HexColor('#AAAAAA'),fontFamily: 'MPlusR'),
                            hintText: '検索',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text('マイID', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 12)),
                    ),
                    Text(model.uid, style: TextStyle(color: HexColor('#AAAAAA'), fontFamily: 'MPlusR', fontSize: 12)),
                    InkWell(
                      child: Icon(Icons.copy_all_outlined),
                      onTap: () {
                        model.copyToClipboard();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton(
                    child: Text('フレンド申請を送信', style: TextStyle(color: HexColor('#FFFFFF'), fontFamily: 'MPlus', fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: HexColor('#1595B9'),
                      side: BorderSide(color: HexColor('#1595B9')),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    ),
                    onPressed: () async {
                      await model.searchFriendID();
                      if(model.requestState == RequestState.Accept){
                        BuildWidget().buildDialog('フレンド申請', model.requireLog, '送信する', context, (){
                          model.sendRequestMessage();
                          Navigator.of(context).pop();
                          BuildWidget().buildDialog('フレンド申請を完了しました', '承認を受けるまでお待ちください', '戻る', context, (){
                            Navigator.of(context).pop();
                          });
                        });
                      }
                      else{
                        BuildWidget().buildDialog('フレンド申請', model.requireLog, '戻る', context, ()=>{
                          Navigator.of(context).pop(),
                        });
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('以下のオプションも使用可能です', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 12)),
              ),
              OutlinedButton(
                child: Text('QRスキャン'),
                onPressed: (){
                  // TODO QRコードページへの遷移
                  //Utility().onFadeNavigator(context, )
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: model.myRequireList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Text(model.myRequireList[index].userName),
                      OutlinedButton(
                        child: Text('承認'),
                        onPressed: () async{
                          await model.acceptAddFriendList(index);
                        },
                      )
                    ],
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}