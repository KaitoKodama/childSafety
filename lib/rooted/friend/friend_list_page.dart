import 'package:child_safety01/system/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'friend_detail_page.dart';
import 'friend_models/friend_list_model.dart';



class FriendListPage extends StatefulWidget{
  @override
  FriendListPageState createState() => FriendListPageState();
}

//フレンドリスト表示ページ
class FriendListPageState extends State<FriendListPage>{

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<FriendListModel>(
      create: (_) => FriendListModel()..fetchFriends(),
      child: Scaffold(
        appBar: Header(context),
        body: Consumer<FriendListModel>(
          builder: (context, model, child) {
            //ローディング時の表示
            if(model.isLoading){
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            //ローディング完了時の表示
            else{
              if(model.friendInformation.length == 0){
                return Center(
                  child: Container(
                    child: Text('友達が一人もいません',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  ),
                );
              }
              else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 20),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          child: Row(
                            children: [
                              Icon(Icons.search, color: ColorBase().MainBlue()),
                              const Text('検索', style: TextStyle(fontSize: 16, fontFamily: 'MPlusR')),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                            primary: ColorBase().SubGray(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Color.fromRGBO(239, 239, 239, 1.0),
                          ),
                          onPressed: (){
                            showSearch(context: context, delegate: FriendListSearch(model));
                          },
                        ),
                      ),
                    ),
                    createFriendList(model)
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget createFriendList(FriendListModel model){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: model.friendInformation.length,
        itemBuilder: (context, index) {
          if(model.friendInformation[index].isLogout == false) {
            return SizedBox(
              height: 70,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ColorBase().BackGroundColor(context)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CircleAvatar(
                          radius: 40,
                          backgroundImage: (model.friendInformation[index].userIconPath.toString().length != 0)? Image.network(model.friendInformation[index].userIconPath.toString()).image: Image.asset('images/base-icon.png').image
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              (model.friendInformation[index].userName.toString().isNotEmpty)?model.friendInformation[index].userName.toString():'名前未設定',
                              style: TextStyle(
                                fontFamily: 'MPlusR', fontSize: 13, color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              (model.friendInformation[index].userComment.toString().isNotEmpty)?model.friendInformation[index].userComment.toString():'コメントが設定されていません',
                              style: TextStyle(
                                fontFamily: 'MPlusR', fontSize: 12, color: ColorBase().SubGray(),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    (model.friendInformation[index].userID.toString().length != 0)?
                    FriendDetailPage(model.friendInformation[index].userID.toString()):
                    FriendListPage()
                    ),
                  );
                },
              ),
            );
          }else{
            return createDeleteItem(context, model, index);
          }
        }
    );
  }

  //特定の要素
  Widget createSearchedFriendList(List<int> displayIndex, FriendListModel model){
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: displayIndex.length,
        itemBuilder: (context, index) {
          if(model.friendInformation[index].isLogout == false){
            return SizedBox(
              height: 70,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ColorBase().BackGroundColor(context)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:(model.friendInformation[displayIndex[index]].userIconPath.toString().length != 0)? NetworkImage(model.friendInformation[displayIndex[index]].userIconPath.toString()): Image.asset('images/base-icon.png').image,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child:SmallPartsBase().textStyledBoolean(model.friendInformation[displayIndex[index]].userName.toString(), '名前未設定', Colors.black, 13)
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    (model.friendInformation[displayIndex[index]].userID.toString().length != 0)?
                    FriendDetailPage(model.friendInformation[displayIndex[index]].userID.toString()): FriendListPage()
                    ),
                  );
                },
              ),
            );
          }else{
            return createDeleteItem(context, model, index);
          }
        }
    );
  }

  Widget createDeleteItem(BuildContext context, FriendListModel model, int index){
    return Dismissible(
      key: Key(model.friendInformation[index].toString()),
      direction: DismissDirection.none,
      child: SizedBox(
        height: 70,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorBase().BackGroundColor(context)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (model.friendInformation[index].userIconPath.toString().length != 0)?
                    Image.network(model.friendInformation[index].userIconPath.toString()).image:
                    Image.asset('images/base-icon.png').image
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: 250,
                  child: Text(
                    (model.friendInformation[index].userName.toString().isNotEmpty)?
                    model.friendInformation[index].userName.toString()+'さんは現在ログアウト中です':
                    '名前未設定',
                    style: TextStyle(
                      fontFamily: 'MPlusR', fontSize: 13, color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            createDeleteItemDialog(context, model, index);
          },
        ),
      ),
    );
  }
  void createDeleteItemDialog(BuildContext context, FriendListModel model, int index){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('フレンド削除', style: dialogTextStyle(16)),
            content: Text(model.friendInformation[index].userName.toString()+'さんをフレンドリストから削除しますか？', style: dialogTextStyle(14)),
            actions: [
              OutlinedButton(
                child: Text('削除', style: dialogTextStyle(14),),
                style: buttonStyleDialog(),
                onPressed: () async{
                  await model.deleteFriendFromList(index);
                  setState(() {
                    model.friendInformation.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              ),
              OutlinedButton(
                child: Text('キャンセル', style: dialogTextStyle(14)),
                style: buttonStyleDialog(),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  ButtonStyle buttonStyleDialog(){
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