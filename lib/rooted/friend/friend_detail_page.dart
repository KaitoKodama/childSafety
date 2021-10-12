import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/system/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friend_models/friend_detail_model.dart';


class FriendDetailPage extends StatelessWidget{
  FriendDetailPage(this.targetId);
  String targetId;

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<FriendDetailModel>(
      create: (_) => FriendDetailModel()..fetchFriendDetail(targetId),
      child: Scaffold(
        appBar: Header(context),
        body: Consumer<FriendDetailModel>(
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: showIconImage(model.friendUserDetail!.userIconPath),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallPartsBase().textStyledBoolean(
                                    model.friendUserDetail!.userName.toString(),
                                    '名前未設定', Colors.black, 13
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, right: 15),
                                  child: SmallPartsBase().textStyledBoolean(model.friendUserDetail!.userComment.toString(), 'コメントが設定されていません', ColorBase().SubGray(), 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                        child: Text(model.friendUserDetail!.userExplain.toString()),
                      ),
                    ),
                    Container(
                      color: ColorBase().MainBlue(),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
                        child: Text(
                          'お子さま情報',
                          style: SmallPartsBase().childBarStyle(),
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.friendChildDetail.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 55, bottom: 20, left: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    showIconImage(model.friendChildDetail[index].childIcon),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SmallPartsBase().textStyledBoolean(model.friendChildDetail[index].childName.toString(), '未設定', Colors.black, 13),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: SmallPartsBase().textStyledBoolean(model.friendChildDetail[index].childBirth.toString(), '未設定', ColorBase().SubGray(), 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  childInformation(context, '好きな食べ物', model.friendChildDetail[index].childFavFood.toString()),
                                  childInformation(context, '嫌いな食べ物', model.friendChildDetail[index].childHateFood.toString()),
                                  childInformation(context, 'アレルギー', model.friendChildDetail[index].childAllergy.toString()),
                                  childInformation(context, '性格', model.friendChildDetail[index].childPersonality.toString()),
                                  childInformation(context, 'その他', model.friendChildDetail[index].childExe.toString()),
                                ],
                              ),
                            ],
                          );
                        }
                    ),
                    deleteFriendButton(model, context),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget showIconImage(String? iconPath){
    return SizedBox(
      width: 55,
      height: 55,
      child: CircleAvatar(
        radius: 40,
        backgroundImage: (iconPath!.isNotEmpty)?
        Image.network(iconPath).image:Image.asset('images/base-icon.png').image,
      ),
    );
  }
  Widget childInformation(BuildContext context, String title, String content){
    return Container(
      decoration: BoxDecoration(
        border: const Border(
          top: const BorderSide(
            color: Colors.black,
            width: 0.1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width*0.3,
                child: SmallPartsBase().textStyledBoolean(title, '', Colors.black, 14)
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 15),
                child: Text(
                  (content.isNotEmpty)?content:'-',
                  style: TextStyle(
                    fontFamily: 'MPlusR', fontSize: 14, color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget childTitle(String text){
    return Row(
      children: [
        Icon(Icons.bubble_chart),
        Text(text, style: SmallPartsBase().mainTextStyle()),
      ],
    );
  }
  Widget childContent(String text){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        (text.length != 0)? text: '',
        style: SmallPartsBase().mainTextStyle(),
      ),
    );
  }

  Widget deleteFriendButton(FriendDetailModel model, BuildContext context){
    return SizedBox(
      width: 220,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 50),
        child: OutlinedButton(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: SmallPartsBase().textStyledBoolean('フレンドリスト削除', '', Colors.white, 14),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorBase().MainBlue(),
            primary: Colors.white,
            side: BorderSide(color: ColorBase().MainBlue()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async{
            await model.deleteSelectedFriend(model.friendUserDetail!.userID.toString());
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendListPage()),
            );
          },
        ),
      ),
    );
  }
}