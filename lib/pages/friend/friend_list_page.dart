import 'package:child_safety01/component/extends.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/component/widget.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/models/friend/friend_list_model.dart';
import 'package:child_safety01/utility/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'friend_detail_page.dart';


class FriendListPage extends StatefulWidget{
  @override
  FriendListPageState createState() => FriendListPageState();
}
class FriendListPageState extends State<FriendListPage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<FriendListModel>(
      create: (_) => FriendListModel()..initFriendList(),
      child: Scaffold(
        appBar: ApplicationHead(context),
        body: Consumer<FriendListModel>(
          builder: (context, model, child) {
            switch(model.displayState) {
              case DisplayState.IsLoading:
                return buildLoadingWidget();
              case DisplayState.FriendDoesNotExist:
                return buildFriendDoesNotExistWidget();
              case DisplayState.FriendExist:
                return buildFriendExistWidget(model);
            }
          },
        ),
        bottomNavigationBar: ApplicationFoot(),
      ),
    );
  }

  Widget buildLoadingWidget(){
    return LoadingScreen();
  }
  Widget buildFriendDoesNotExistWidget(){
    return Center(
      child: Container(
        child: Text(
          '現在登録されている友達はいません',
          style: TextStyle(fontFamily: 'MPlusR', fontSize: 13, color: HexColor('#333333'))
        ),
      ),
    );
  }
  Widget buildFriendExistWidget(FriendListModel model){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Container(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset('images/icon_search.svg'),
                      ),
                      Text('検索', style: TextStyle(fontSize: 16, fontFamily: 'MPlusR', color: HexColor('#AAAAAA'))),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: HexColor('#1595B9')),
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                  onPressed: (){
                    print(model.friendList.length);
                    showSearch(context: context, delegate: FriendSearch(model.friendList));
                  },
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: model.friendList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  // ■ ターゲットがログアウトしている場合
                  if(model.friendList[index].isLogout == true){
                    return Dismissible(
                      key: Key(model.friendList[index].toString()),
                      direction: DismissDirection.none,
                      child: StyledFriendItem(
                        model.friendList[index].getIconFromPath(),
                        model.friendList[index].userName+'さんは現在ログアウト中です',
                        model.friendList[index].userName+'さんをフレンドリストから削除しますか？',()=>{
                          DisplayDialog('フレンドリスト削除',model.friendList[index].userName+'さんをフレンドリストから削除します。よろしいですか？','削除する',context,() async {
                            await model.deleteFriendFromList(index);
                            Navigator.of(context).pop();
                            DisplayDialog('フレンドリスト削除完了','再度フレンド追加する場合は、QRコードまたはIDで追加してください','戻る',context,(){
                              Navigator.of(context).pop();
                            });
                          }),
                        },
                      ),
                    );
                  }
                  // ■ ターゲットがログインしている場合
                  else{
                    return StyledFriendItem(
                      model.friendList[index].getIconFromPath(),
                      model.friendList[index].userName,
                      model.friendList[index].userComment,(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FriendDetailPage(model.friendList[index].userID)));
                      },
                    );
                  }
                }
             ),
          ],
        ),
      ),
    );
  }
}