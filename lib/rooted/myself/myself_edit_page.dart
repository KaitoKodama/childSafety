import 'package:child_safety01/rooted/myself/myself_models/myself_edit_model.dart';
import 'package:child_safety01/system/common.dart';
import 'package:child_safety01/system/widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'myself_models/myself_edit_model.dart';


class MySelfEditPage extends StatefulWidget{
  @override
  _MySelfEditPageState createState() => _MySelfEditPageState();
}

class _MySelfEditPageState extends State<MySelfEditPage>{
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
              switch(model.displayState){
                case DisplayStateSimple.IsDisable:
                  return buildDisableWidget();
                case DisplayStateSimple.IsEnable:
                  return buildEnableWidget(model);
              }
            },
          ),
        ),
        bottomNavigationBar: ApplicationFoot(),
      ),
    );
  }


  Widget buildDisableWidget(){
    return BuildWidget().buildLoadingDialog(context);
  }
  Widget buildEnableWidget(MySelfDataEditModel model){
    return SingleChildScrollView(
        child:Column(
          children: [
            buildIconItem(model.userCompletedInfo.getIconFromPath(),() async{
              await model.getImageProviderFromPickedImage();
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
              BuildWidget().buildDialog('保存完了', 'ご自身のプロフィール保存を完了しました', '戻る', context, (){
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
                        buildIconItem(model.userCompletedInfo.childInfoList[index].getIconFromPath(),()async{
                          await model.getChildImageProviderFromPickedImage(index);
                        }),
                        buildInputItem('名前', model.userCompletedInfo.childInfoList[index].name, (value){
                          model.userCompletedInfo.childInfoList[index].name = value;
                        }),
                        DottedLine(
                          dashLength: 5,
                          dashGapLength: 5,
                          dashColor: HexColor('#58C1DF'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text('出生順',style: TextStyle(fontSize: 14, color: HexColor('#333333'), fontFamily: 'MPlusR')),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                        children: [
                                          buildRadioButtonItem(model, index, ChildOrder.male01,'長男'),
                                          buildRadioButtonItem(model, index, ChildOrder.male02,'次男'),
                                          buildRadioButtonItem(model, index, ChildOrder.male03,'三男'),
                                          buildRadioButtonItem(model, index, ChildOrder.male04,'四男'),
                                          buildRadioButtonItem(model, index, ChildOrder.male05,'五男'),
                                        ]
                                    ),
                                    Row(
                                        children: [
                                          buildRadioButtonItem(model, index, ChildOrder.female01,'長女'),
                                          buildRadioButtonItem(model, index, ChildOrder.female02,'次女'),
                                          buildRadioButtonItem(model, index, ChildOrder.female03,'三女'),
                                          buildRadioButtonItem(model, index, ChildOrder.female04,'四女'),
                                          buildRadioButtonItem(model, index, ChildOrder.female05,'五女'),
                                        ]
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                          BuildWidget().buildDialog('保存完了', 'お子さまのプロフィール保存を完了しました', '戻る', context, (){
                            Navigator.of(context).pop();
                          });
                        }),
                        buildChildOperateButtonItem(SvgPicture.asset('images/icon_child_add.svg'), 'お子さま情報を追加する', (){
                          BuildWidget().buildDialog('お子さま情報の追加', '新しくお子さま情報を追加しますか？', '追加する', context, (){
                            Navigator.of(context).pop();
                            model.addChildMap();
                          });
                        },true),
                        buildChildOperateButtonItem(SvgPicture.asset('images/icon_child_remove.svg'), 'お子さま情報を削除する', (){
                          String childName = model.userCompletedInfo.childInfoList[index].name;
                          BuildWidget().buildDialog('お子さま情報の削除', '$childNameをお子さま情報から削除しますか？', '削除する', context, (){
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
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor('#FFE33F'), width: 2),
                  shape: BoxShape.circle,
                  image: DecorationImage(fit: BoxFit.cover, image: icon),
                ),
              ),
            ),
            Text(
              '写真を変更',
              style: TextStyle(fontSize: 13, color: HexColor('#1595B9'), fontFamily: 'MPlusR'),
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
                    hintText: '-',
                    hintStyle: TextStyle(fontSize: 14, color: HexColor('#707070'), fontFamily: 'MPlusR'),
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

  Widget buildRadioButtonItem(MySelfDataEditModel model, int index, ChildOrder selection, String contentText){
    return Expanded(
      child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: SizedBox(
                width: 10,
                height: 10,
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith((states) =>  HexColor('#333333')),
                  groupValue: model.userCompletedInfo.childInfoList[index].orderState,
                  value: selection,
                  onChanged: (value){
                    setState(() {
                      var order = value as ChildOrder;
                      model.userCompletedInfo.childInfoList[index].setChildOrderState(order);
                    });
                  },
                ),
              ),
            ),
            Text(contentText,style:TextStyle(fontSize: 14, fontFamily: 'MPlusR', color: HexColor('#333333'))),
          ]
      ),
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