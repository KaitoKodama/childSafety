import 'package:child_safety01/component/cp_button.dart';
import 'package:child_safety01/component/cp_item.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/component/cp_screen.dart';
import 'package:child_safety01/pages/user/qr_scan_page.dart';
import 'package:child_safety01/utility/enum.dart';
import 'package:child_safety01/utility/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../models/user/add_friend_model.dart';


class AddFriendIDPage extends StatefulWidget{
  @override
  AddFriendIDPageState createState() => AddFriendIDPageState();
}
class AddFriendIDPageState extends State<AddFriendIDPage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<FriendAddModel>(
      create: (_) => FriendAddModel(context)..initFriendRequire(),
      child: Scaffold(
        appBar: ApplicationHead(context),
        body: Consumer<FriendAddModel>(
          builder: (context, model, child) {
            if(!model.isLoading) return buildScreenWidget(model);
            else return LoadingScreen();
          },
        ),
        bottomNavigationBar: ApplicationFoot(),
      ),
    );
  }


  Widget buildScreenWidget(FriendAddModel model){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      if(model.requestUnit.requestState == RequestState.Accept){
                        DisplayDialog('フレンド申請', model.requestUnit.logMessage, '送信する', context, (){
                          model.sendRequestMessage();
                          Navigator.of(context).pop();
                          DisplayDialog('フレンド申請を完了しました', '承認を受けるまでお待ちください', '戻る', context, (){
                            Navigator.of(context).pop();
                          });
                        });
                      }
                      else{
                        DisplayDialog('フレンド申請', model.requestUnit.logMessage, '戻る', context, ()=>{
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
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  child: Row(
                    children: [
                      SvgPicture.asset('images/qr_icon.svg', width: 40),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('QRスキャン', style: TextStyle(color: HexColor('#000000'), fontSize: 10, fontFamily: 'MPlusR')),
                              Text('ライブラリ内のQRコード、またはカメラを使って、フレンドを追加できます', style: TextStyle(color: HexColor('#707070'), fontSize: 10, fontFamily: 'MPlusR')),
                            ],
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 15, color: HexColor('#707070')),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('#F3F7FD'),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    side: BorderSide(color: HexColor('#F3F7FD')),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onPressed: (){
                    PermissionManager(context, Permission.camera).permissionHandle((){
                      SplashScreen(context, QRScanPage());
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('承認待ちの申請 - ${model.myPartialRequireList.length}', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 12)),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: model.myPartialRequireList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: CircleIconItem(60, model.myPartialRequireList[index].getIconFromPath()),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(model.myPartialRequireList[index].userName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,fontFamily: 'MPlus',color: HexColor('#333333'))),
                              Text('フレンド申請を承認待ち', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,fontFamily: 'MPlus',color: HexColor('#8E8E8E'))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: StyledIconButton(Icon(Icons.person_add_alt_1_rounded, color: Colors.white), 25, HexColor('#1595B9'), ()async{
                            await model.acceptAddFriendList(index);
                          }),
                        ),
                        StyledIconButton(Icon(Icons.person_remove_alt_1_rounded, color: Colors.white), 25, HexColor('#1595B9'), ()async{
                          await model.rejectAddFriendList(index);
                        }),
                      ],
                    ),
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