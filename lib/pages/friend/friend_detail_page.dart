import 'package:child_safety01/component/cp_item.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/component/cp_screen.dart';
import 'package:child_safety01/models/friend/friend_detail_model.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'friend_list_page.dart';


class FriendDetailPage extends StatelessWidget{
  FriendDetailPage(this.targetId);
  final String targetId;

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<FriendDetailModel>(
      create: (_) => FriendDetailModel()..initFriendDetail(targetId),
      child: Scaffold(
        appBar: ApplicationHead(context),
        body: Consumer<FriendDetailModel>(
          builder: (context, model, child) {
            if(!model.isLoading) return buildScreenWidget(context, model);
            else return LoadingScreen();
          },
        ),
        bottomNavigationBar: ApplicationFoot(),
      ),
    );
  }

  Widget buildScreenWidget(BuildContext context, FriendDetailModel model){
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: CircleIconItem(60, model.friendCompletedInfo.getIconFromPath()),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            model.friendCompletedInfo.userName,
                            style: TextStyle(fontSize: 13,fontFamily: 'MPlus',color: HexColor('#333333')),
                          ),
                          Text(
                            model.friendCompletedInfo.userComment,
                            style: TextStyle(fontSize: 12,fontFamily: 'MPlus',color: HexColor('#8E8E8E')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  child: Text(
                    model.friendCompletedInfo.userExplain,
                    style: TextStyle(fontSize: 13,fontFamily: 'MPlusR',color: HexColor('#333333')),
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: model.friendCompletedInfo.childInfoList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: HexColor('#58C1DF'),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5, left: 15),
                              child: SvgPicture.asset('images/icon_smile.svg'),
                            ),
                            Text(
                              'お子さま情報',
                              style: TextStyle(fontSize: 16, fontFamily: 'MPlusR', color: HexColor('#FFFFFF')),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleIconItem(95, model.friendCompletedInfo.childInfoList[index].getIconFromPath()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          child: Text(
                              model.friendCompletedInfo.childInfoList[index].orderUnitList.selectUnit.name,
                              style: TextStyle(fontSize: 14, fontFamily: 'MPlusR', color: HexColor('#FFFFFF'))),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: HexColor('#1595B9'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25, left: 20, right: 20),
                      child: Text(
                        model.friendCompletedInfo.childInfoList[index].name,
                        style: TextStyle(fontSize: 16, fontFamily: 'MPlus', color: HexColor('#333333')),
                      ),
                    ),
                    buildChildItem(
                        '好きな食べ物',
                        model.friendCompletedInfo.childInfoList[index].favoriteFood
                    ),
                    buildChildItem(
                        '嫌いな食べ物',
                        model.friendCompletedInfo.childInfoList[index].hateFood
                    ),
                    buildChildItem(
                        'アレルギー',
                        model.friendCompletedInfo.childInfoList[index].allergy
                    ),
                    buildChildItem(
                        '性格',
                        model.friendCompletedInfo.childInfoList[index].personality
                    ),
                    buildChildItem(
                        'その他',
                        model.friendCompletedInfo.childInfoList[index].etc
                    ),
                  ],
                ),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: SizedBox(
              width: 200,
              child: OutlinedButton(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13, bottom: 13),
                  child: Text(
                    'フレンドリスト削除',
                    style: TextStyle(fontSize: 14, fontFamily: 'MPlusR', color: HexColor('#FFFFFF')),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: HexColor('#1595B9'),
                  side: BorderSide(color: HexColor('#1595B9')),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                ),
                onPressed: (){
                  DisplayDialog(
                      'フレンドリスト削除',
                      model.friendCompletedInfo.userName+'さんをフレンドリストから削除します。よろしいですか？',
                      '削除する',
                      context,
                      (){
                        Navigator.of(context).pop();
                        SplashScreen(context, FriendListPage());
                        model.deleteSelectedFriend(targetId);
                      }
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChildItem(String title, String content){
    return Container(
      child: Column(
        children: [
          DottedLine(
            dashLength: 5,
            dashGapLength: 5,
            dashColor: HexColor('#58C1DF'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 20, left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 115,
                    child: Text(title,style: TextStyle(fontSize: 14, fontFamily: 'MPlus', color: HexColor('#333333')))
                ),
                Expanded(
                  child: Text(content,style: TextStyle(fontSize: 14, fontFamily: 'MPlusR', color: HexColor('#333333'))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}