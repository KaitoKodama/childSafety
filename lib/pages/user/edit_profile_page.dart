import 'package:child_safety01/component/cp_item.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/footer.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/component/cp_screen.dart';
import 'package:child_safety01/models/user/edit_profile_model.dart';
import 'package:child_safety01/pages/static/permission_page.dart';
import 'package:child_safety01/utility/enum.dart';
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
            buildInputItem('??????', model.userCompletedInfo.userName, (value){
              model.userCompletedInfo.userName = value;
            }),
            buildInputItem('??????\n????????????', model.userCompletedInfo.userComment, (value){
              model.userCompletedInfo.userComment = value;
            }),
            buildInputItem('????????????', model.userCompletedInfo.userExplain, (value){
              model.userCompletedInfo.userExplain = value;
            }),
            buildSaveButtonItem(() async{
              await model.updateSelfField();
              DisplayDialog('????????????', '?????????????????????????????????????????????????????????', '??????', context, (){
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
                                Text('??????????????????',style: TextStyle(fontSize: 16, fontFamily: 'MPlusR', color: HexColor('#FFFFFF')))
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
                        buildInputItem('??????', model.userCompletedInfo.childInfoList[index].name, (value){
                          model.userCompletedInfo.childInfoList[index].name = value;
                        }),
                        buildDropdownListItem(model, index),
                        buildInputItem('????????????', model.userCompletedInfo.childInfoList[index].birth, (value){
                          model.userCompletedInfo.childInfoList[index].birth = value;
                        }),
                        buildInputItem('??????????????????', model.userCompletedInfo.childInfoList[index].favoriteFood, (value){
                          model.userCompletedInfo.childInfoList[index].favoriteFood = value;
                        }),
                        buildInputItem('??????????????????', model.userCompletedInfo.childInfoList[index].hateFood, (value){
                          model.userCompletedInfo.childInfoList[index].hateFood = value;
                        }),
                        buildInputItem('???????????????', model.userCompletedInfo.childInfoList[index].allergy, (value){
                          model.userCompletedInfo.childInfoList[index].allergy = value;
                        }),
                        buildInputItem('??????', model.userCompletedInfo.childInfoList[index].personality, (value){
                          model.userCompletedInfo.childInfoList[index].personality = value;
                        }),
                        buildInputItem('?????????', model.userCompletedInfo.childInfoList[index].etc, (value){
                          model.userCompletedInfo.childInfoList[index].etc = value;
                        }),
                        buildSaveButtonItem(() async{
                          await model.updateChildField(index);
                          String name = model.userCompletedInfo.childInfoList[index].name;
                          DisplayDialog('????????????', '$name????????????????????????????????????????????????', '??????', context, (){
                            Navigator.of(context).pop();
                          });
                        }),
                        buildChildOperateButtonItem(SvgPicture.asset('images/icon_child_add.svg'), '?????????????????????????????????', (){
                          DisplayDialog('???????????????????????????', '???????????????????????????????????????????????????', '????????????', context, (){
                            Navigator.of(context).pop();
                            model.addChildMap();
                          });
                        },true),
                        buildChildOperateButtonItem(SvgPicture.asset('images/icon_child_remove.svg'), '?????????????????????????????????', (){
                          String childName = model.userCompletedInfo.childInfoList[index].name;
                          DisplayDialog('???????????????????????????', '$childName????????????????????????????????????????????????', '????????????', context, (){
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
                '???????????????',
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
                '???????????????',
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
                    hintText: '$titleText???????????????????????????',
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
                child: Text('?????????',style: TextStyle(fontSize: 14, color: HexColor('#333333'), fontFamily: 'MPlusR')),
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
          child: Text('??????',style: TextStyle(fontSize: 14, color: HexColor('#FFFFFF'), fontFamily: 'MPlusR')),
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