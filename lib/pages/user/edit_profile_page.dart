import 'package:child_safety01/component/cp_item.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/component/cp_screen.dart';
import 'package:child_safety01/models/user/edit_profile_model.dart';
import 'package:child_safety01/pages/static/permission_page.dart';
import 'package:child_safety01/utility/enum.dart';
import 'package:child_safety01/utility/system.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';


class EditProfilePage extends StatefulWidget{
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<MySelfDataEditModel>(
      create: (_) => MySelfDataEditModel()..initUserData(),
      child: Scaffold(
        appBar: ApplicationHead(context),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Consumer<MySelfDataEditModel>(
            builder: (context, model, child) {
              if(!model.isLoading) return buildScreenWidget(model);
              return LoadingScreen();
            },
          ),
        ),
        bottomNavigationBar: ApplicationFoot(),
      ),
    );
  }


  Widget buildScreenWidget(MySelfDataEditModel model){
    return SingleChildScrollView(
        child:Column(
          children: [
            buildUserIconItem(model, model.userCompletedInfo.getIconFromPath(), () async{
              if(await Permission.mediaLibrary.isGranted){
                await model.getImageProviderFromPickedImage();
              }
              else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionPage()));
              }
            }),
            buildInputItem('名前', model.userCompletedInfo.userName, (value){
              model.userCompletedInfo.userName = value;
            }),
            buildInputItem('一言\nコメント', model.userCompletedInfo.userComment, (value){
              model.userCompletedInfo.userComment = value;
            }),
            buildInputItem('自己紹介', model.userCompletedInfo.userExplain, (value){
              model.userCompletedInfo.userExplain = value;
            }),
            buildSaveButtonItem(() async{
              await model.updateSelfField();
              DisplayDialog('保存完了', 'ご自身のプロフィール保存を完了しました', '戻る', context, (){
                Navigator.of(context).pop();
              });
            }),
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.userCompletedInfo.childInfoList.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 55, bottom: 30),
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
                                Text('お子さま情報',style: TextStyle(fontSize: 16, fontFamily: 'MPlusR', color: HexColor('#FFFFFF')))
                              ],
                            ),
                          ),
                        ),
                        buildUserChildIconItem(model, index, ()async{
                          if(await Permission.mediaLibrary.isGranted){
                            await model.getChildImageProviderFromPickedImage(index);
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionPage()));
                          }
                        }),
                        buildInputItem('名前', model.userCompletedInfo.childInfoList[index].name, (value){
                          model.userCompletedInfo.childInfoList[index].name = value;
                        }),
                        buildDropdownListItem(model, index),
                        buildInputItem('お誕生日', model.userCompletedInfo.childInfoList[index].birth, (value){
                          model.userCompletedInfo.childInfoList[index].birth = value;
                        }),
                        buildInputItem('好きな食べ物', model.userCompletedInfo.childInfoList[index].favoriteFood, (value){
                          model.userCompletedInfo.childInfoList[index].favoriteFood = value;
                        }),
                        buildInputItem('嫌いな食べ物', model.userCompletedInfo.childInfoList[index].hateFood, (value){
                          model.userCompletedInfo.childInfoList[index].hateFood = value;
                        }),
                        buildInputItem('アレルギー', model.userCompletedInfo.childInfoList[index].allergy, (value){
                          model.userCompletedInfo.childInfoList[index].allergy = value;
                        }),
                        buildInputItem('性格', model.userCompletedInfo.childInfoList[index].personality, (value){
                          model.userCompletedInfo.childInfoList[index].personality = value;
                        }),
                        buildInputItem('その他', model.userCompletedInfo.childInfoList[index].etc, (value){
                          model.userCompletedInfo.childInfoList[index].etc = value;
                        }),
                        buildSaveButtonItem(() async{
                          await model.updateChildField(index);
                          String name = model.userCompletedInfo.childInfoList[index].name;
                          DisplayDialog('保存完了', '$nameのプロフィール保存を完了しました', '戻る', context, (){
                            Navigator.of(context).pop();
                          });
                        }),
                        buildChildOperateButtonItem(SvgPicture.asset('images/icon_child_add.svg'), 'お子さま情報を追加する', (){
                          DisplayDialog('お子さま情報の追加', '新しくお子さま情報を追加しますか？', '追加する', context, (){
                            Navigator.of(context).pop();
                            model.addChildMap();
                          });
                        },true),
                        buildChildOperateButtonItem(SvgPicture.asset('images/icon_child_remove.svg'), 'お子さま情報を削除する', (){
                          String childName = model.userCompletedInfo.childInfoList[index].name;
                          DisplayDialog('お子さま情報の削除', '$childNameをお子さま情報から削除しますか？', '削除する', context, (){
                            Navigator.of(context).pop();
                            model.removeChildMap(index);
                          });
                        },model.isEnableToRemoveChild()),
                      ],
                    );
                  }
              ),
            ),
          ],
        )
    );
  }

  Widget buildUserIconItem(MySelfDataEditModel model, ImageProvider icon, Function onPressed){
    if(model.userCompletedInfo.isProviding){
      return buildIconProgress();
    }
    else{
      return buildIconItem(icon, onPressed);
    }
  }
  Widget buildUserChildIconItem(MySelfDataEditModel model, int index, Function onPressed){
    if(model.userCompletedInfo.childInfoList[index].isProviding){
      return buildIconProgress();
    }
    else{
      return buildIconItem(model.userCompletedInfo.childInfoList[index].getIconFromPath(), onPressed);
    }
  }

  Widget buildIconProgress(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).canvasColor,
          side: BorderSide(color: Theme.of(context).canvasColor),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Column(
          children: [
            CircleIconItemProgress(95),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                '写真を変更',
                style: TextStyle(fontSize: 13, color: HexColor('#1595B9'), fontFamily: 'MPlusR'),
              ),
            ),
          ],
        ),
        onPressed: (){},
      ),
    );
  }
  Widget buildIconItem(ImageProvider icon, Function onPressed){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).canvasColor,
          side: BorderSide(color: Theme.of(context).canvasColor),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Column(
          children: [
            CircleIconItem(95, icon),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                '写真を変更',
                style: TextStyle(fontSize: 13, color: HexColor('#1595B9'), fontFamily: 'MPlusR'),
              ),
            ),
          ],
        ),
        onPressed: ()async{ onPressed(); },
      ),
    );
  }
  Widget buildInputItem(String titleText, String initialText, Function onChanged){
    return Column(
      children: [
        DottedLine(
          dashLength: 5,
          dashGapLength: 5,
          dashColor: HexColor('#58C1DF'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(titleText,style: TextStyle(fontSize: 14, color: HexColor('#333333'), fontFamily: 'MPlusR')),
              ),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  initialValue: initialText!='-'? initialText:null,
                  decoration: InputDecoration(
                    hintText: '$titleTextを入力してください',
                    hintStyle: TextStyle(fontSize: 14, color: HexColor('#C6C6C6'), fontFamily: 'MPlusR'),
                    counterStyle: TextStyle(fontSize: 14, color: HexColor('#333333'), fontFamily: 'MPlusR'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (value)=>{ onChanged(value) },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget buildDropdownListItem(MySelfDataEditModel model, int index){
    return Column(
      children: [
        DottedLine(
          dashLength: 5,
          dashGapLength: 5,
          dashColor: HexColor('#58C1DF'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text('出生順',style: TextStyle(fontSize: 14, color: HexColor('#333333'), fontFamily: 'MPlusR')),
              ),
              SizedBox(
                width: 200,
                child: DropdownButton(
                  items: [
                    for(var item in model.userCompletedInfo.childInfoList[index].orderUnitList.unitList)
                      DropdownMenuItem(child: Text(item.name, textAlign: TextAlign.center), value: item.order),
                  ],
                  onChanged: (value){
                    setState(() {
                      var unitOrder = value as ChildOrder;
                      model.userCompletedInfo.childInfoList[index].orderUnitList.setUnitFromEnum(unitOrder);
                    });
                  },
                  value: model.userCompletedInfo.childInfoList[index].orderUnitList.selectUnit.order,
                  underline: Container(height: 0),
                  iconEnabledColor: HexColor('#1595B9'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSaveButtonItem(Function onSave){
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 100,
        height: 45,
        child: OutlinedButton(
          child: Text('保存',style: TextStyle(fontSize: 14, color: HexColor('#FFFFFF'), fontFamily: 'MPlusR')),
          style: OutlinedButton.styleFrom(
            backgroundColor: HexColor('#1595B9'),
            side: BorderSide(color: HexColor('#1595B9')),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          ),
          onPressed: ()async{ onSave(); },
        ),
      ),
    );
  }
  Widget buildChildOperateButtonItem(SvgPicture operateIcon, String operateText, Function onOperate, bool judgement){
    if(judgement){
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: OutlinedButton(
          child: Container(
            width: 250,
            height: 50,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(operateText,style: TextStyle(fontSize: 12, color: HexColor('#1595B9'),fontFamily: 'MPlus')),
                ),
                operateIcon,
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Theme.of(context).canvasColor,
            side: BorderSide(color: HexColor('#1595B9')),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60),),
          ),
          onPressed: (){ onOperate(); },
        ),
      );
    }
    else{
      return Container();
    }
  }
}