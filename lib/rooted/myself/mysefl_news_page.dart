import 'package:child_safety01/rooted/myself/myself_news_detail_page.dart';
import 'package:child_safety01/system/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myself_models/myself_news_model.dart';


class MySelfNewsPage extends StatefulWidget{
  @override
  _MySelfNewsPageState createState() => _MySelfNewsPageState();
}


class _MySelfNewsPageState extends State<MySelfNewsPage>{
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<MyselfNewsModel>(
      create: (_) => MyselfNewsModel()..fetchNewsVariable(),
      child: Scaffold(
        appBar: Header(context),
        body: Consumer<MyselfNewsModel>(
          builder: (context, model, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText01(model),
                createReqFriendList(model),
                titleText02(model),
                createFriendAcceptList(model),
                titleText03(model),
                createIncNewsList(model),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget createIncNewsList(MyselfNewsModel model){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.newsList.length,
        itemBuilder: (context, index) {
          return Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12),),
            ),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorBase().BackGroundColor(context)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CommonUsage().checkIsStringEmpty(model.newsList[index].title.toString(), 'タイトル'),
                    style: TextStyle(
                      fontFamily: 'MPlusR', fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    CommonUsage().checkIsStringEmpty(model.newsList[index].content.toString(), '内容'),
                    style: TextStyle(
                      fontFamily: 'MPlusR', fontSize: 13, color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MySelfNewsDetailPage(model.newsList[index].title.toString(), model.newsList[index].content.toString())),
                );
              },
            ),
          );
        }
    );
  }

  Widget createReqFriendList(MyselfNewsModel model){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.requireList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(model.requireList[index].toString()),
            direction: DismissDirection.none,
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12),),
              ),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: SizedBox(
                          width: 55,
                          height: 55,
                          child: CircleAvatar(
                              radius: 40,
                              backgroundImage: (model.requireList[index].userIconPath!.isNotEmpty)?
                                Image.network(model.requireList[index].userIconPath.toString()).image:
                                Image.asset('images/base-icon.png').image,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(CommonUsage().checkIsStringEmpty(model.requireList[index].userName.toString(), '名無し'),
                          style: TextStyle(
                            fontFamily: 'MPlusR', fontSize: 13, color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: OutlinedButton(
                          child: Text('承認'),
                          onPressed: () async{
                            await model.acceptFriendShip(index);
                            createAcceptDialog(model.requireList[index].userName.toString());
                            setState(() {
                              model.requireList.removeAt(index);
                            });
                          },
                          style: buttonStyle(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: OutlinedButton(
                          child: Text('拒否'),
                          onPressed: () async{
                            await model.rejectFriendShip(index);
                            createCanceledDialog(model.requireList[index].userName.toString());
                            setState(() {
                              model.requireList.removeAt(index);
                            });
                          },
                          style: buttonStyle(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget createFriendAcceptList(MyselfNewsModel model){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.friendNotifyList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(model.friendNotifyList[index].toString()),
            onDismissed: (direction) async{
              await model.removeFriendNotify(index);
              setState((){
                model.friendNotifyList.removeAt(index);
              });
            },
            child: Container(
              alignment: Alignment.centerLeft,
              height: 70,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12),),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Icon(Icons.archive_outlined),
                    ),
                    Text(
                      CommonUsage().checkIsStringEmpty(model.friendNotifyList[index].toString(), '内容'),
                      style: TextStyle(
                        fontFamily: 'MPlusR', fontSize: 13, color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  void createAcceptDialog(String name){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(CommonUsage().checkIsStringEmpty(name, '名無し')+'さんをフレンドリストに追加しました。'),
            actions: [
              OutlinedButton(
                child: Text('OK', style: dialogTextStyle(14)),
                style: buttonStyle(),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  void createCanceledDialog(String name){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: Text(CommonUsage().checkIsStringEmpty(name, '名無し')+'さんの承認を拒否しました'),
            actions: [
              OutlinedButton(
                child: Text('OK', style: dialogTextStyle(14)),
                style: buttonStyle(),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  Widget titleText01(MyselfNewsModel model){
    if(model.requireList.length > 0){
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorBase().SubGray()),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            child: Text(
              '未承認リスト',
              style: TextStyle(
                fontFamily: 'MPlusR',
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }else{
      return SizedBox();
    }
  }
  Widget titleText02(MyselfNewsModel model){
    if(model.friendNotifyList.length > 0){
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorBase().SubGray()),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            child: Text(
              'フレンド通知',
              style: TextStyle(
                fontFamily: 'MPlusR',
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }else{
      return SizedBox();
    }
  }
  Widget titleText03(MyselfNewsModel model){
    if(model.newsList.length > 0){
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorBase().SubGray()),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            child: Text(
              'お知らせ',
              style: TextStyle(
                fontFamily: 'MPlusR',
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }else{
      return SizedBox();
    }
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
  TextStyle dialogTextStyle(double size){
    return TextStyle(
      fontSize: size,
      fontFamily: 'MPlusR',
      fontWeight: FontWeight.w600,
      color: ColorBase().SubGray(),
    );
  }
}