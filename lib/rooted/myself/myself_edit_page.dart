import 'package:child_safety01/rooted/myself/myself_models/myself_edit_model.dart';
import 'package:child_safety01/system/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myself_models/myself_edit_model.dart';


class MySelfEditPage extends StatefulWidget{
  @override
  _MySelfEditPageState createState() => _MySelfEditPageState();
}

//情報登録・編集画面ページ
class _MySelfEditPageState extends State<MySelfEditPage>{

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<MySelfDataEditModel>(
      create: (_) => MySelfDataEditModel()..fetchCurrentData(),
      child: Scaffold(
        appBar: Header(context),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Consumer<MySelfDataEditModel>(
            builder: (context, model, child) {
              if(!model.isLoading){
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // 自身の写真用コンテナ
                      createIconImageField(model),
                      Container(
                        child: Column(
                          children: [
                            createSelfInputField(MyselfEditField.Name, model, '名前', ''),
                            createSelfInputField(MyselfEditField.Comment, model, '一言\nコメント', ''),
                            createSelfInputField(MyselfEditField.Introduce, model, '自己紹介', ''),
                            saveMyselfButton(model),
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.myselfChildDetail.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                createInfoBar(model, index),
                                createChildIconImageField(model, index),

                                createChildInputField(index, '名前', '例）【長男】拓哉  ●歳', model, ChildInputState.Name),
                                createChildInputField(index, 'お誕生日', '例）2020.1.1', model, ChildInputState.Birth),
                                createChildInputField(index, '好きな食べ物', '例）ハンバーグ、焼き肉', model, ChildInputState.FavFood),
                                createChildInputField(index, '嫌いな食べ物', '例）ピーマン、ニンジン、焼き魚', model, ChildInputState.HateFood),
                                createChildInputField(index, 'アレルギー', '※記入、未記入は任意です。', model, ChildInputState.Aller),
                                createChildInputField(index, '性格', '例）身体を動かす事が大好きで、少々落ち着きがないところもあります。アトピーをもっており肌があまり強くないです。', model, ChildInputState.Person),
                                createChildInputField(index, 'その他', '例）市販のお菓子は食べさせないようにしています。', model, ChildInputState.Exe),

                                saveMyselfChildButton(model, index),
                                (index == model.myselfChildDetail.length-1)? addNewChildField(model, index):SizedBox(width: 0,height: 0),
                              ],
                            );
                          }
                      ),
                    ],
                  ),
                );
              }
              else{
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }


  //------------------ メインパートの作成 -----------------------
  Widget createInfoBar(MySelfDataEditModel model, int index){
    if(index == model.myselfChildDetail.length-1 && index != 0){
      return Container(
        color: ColorBase().MainBlue(),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
              child: Text(
                'お子さま情報 : '+(index+1).toString(),
                style: SmallPartsBase().childBarStyle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: removeLastChildField(model, index),
            ),
          ],
        ),
      );
    }
    else{
      return Container(
        color: ColorBase().MainBlue(),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
          child: Text(
            'お子さま情報 : '+(index+1).toString(),
            style: SmallPartsBase().childBarStyle(),
          ),
        ),
      );
    }
  }
  Widget createIconImageField(MySelfDataEditModel model){
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top:30, bottom: 20),
        child: OutlinedButton(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 98,
                  height: 98,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundImage: (model.myselfDetail!.userIconPath!.isNotEmpty)? Image.network(model.myselfDetail!.userIconPath.toString()).image: Image.asset('images/base-icon.png').image
                  ),
                ),
              ),
              SmallPartsBase().textStyledBoolean('写真を変更', '', ColorBase().MainBlue(), 13),
            ],
          ),
          onPressed: (){
            model.showSelfImagePicker();
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorBase().BackGroundColor(context)),
          ),
        ),
      ),
    );
  }

  Widget createChildIconImageField(MySelfDataEditModel model, int index){
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top:30, bottom: 20),
        child: OutlinedButton(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 98,
                  height: 98,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundImage: (model.myselfChildDetail[index].childIcon!.isNotEmpty)? Image.network(model.myselfChildDetail[index].childIcon.toString()).image: Image.asset('images/base-icon.png').image
                  ),
                ),
              ),
              SmallPartsBase().textStyledBoolean('写真を変更', '', ColorBase().MainBlue(), 13),
            ],
          ),
          onPressed: (){
            model.showSelfChildImagePicker(index);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorBase().BackGroundColor(context)),
          ),
        ),
      ),
    );
  }


  //---------------------------------- 情報入力系インプットフィールド -----------------------------------
  Widget createSelfInputField(MyselfEditField state, MySelfDataEditModel model, String title, String hint){
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width *0.3,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 13, left: 15),
                child: Text(title),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width *0.7,
              child:Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextFormField(
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                  initialValue: model.getMyselfDetailText(state),
                  onChanged: (text){
                    model.setMyselfDetailText(state, text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorBase().BorderColor()),
        ),
      ),
    );
  }

  Widget createChildInputField(int index, String title, String hint, MySelfDataEditModel model, ChildInputState state){
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width *0.3,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 40),
                    child: Text(title),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width *0.7,
                  child:Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: TextFormField(
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                      ),
                      initialValue: model.getSpecificChildFieldStr(index, state),
                      onChanged: (text){
                        model.setSpecificChildFieldStr(index, text, state);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorBase().BorderColor()),
        ),
      ),
    );
  }



  //--------------------------------- ボタン系ウィジェット -------------------------------------
  //更新
  Widget saveMyselfButton(MySelfDataEditModel model){
    return SizedBox(
      width: 220,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 50),
        child: OutlinedButton(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SmallPartsBase().textStyledBoolean('保存', '', Colors.white, 14),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: (model.myselfDetail!.isSaved == true)?
                  Icon(Icons.file_download_done_outlined):Icon(Icons.file_upload_outlined),
                ),
              ],
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorBase().MainBlue(),
            primary: Colors.white,
            side: BorderSide(color: ColorBase().MainBlue()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (){
            model.updateSelfField();
          },
        ),
      ),
    );
  }

  Widget saveMyselfChildButton(MySelfDataEditModel model, int index){
    return SizedBox(
      width: 220,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 50),
        child: OutlinedButton(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                SmallPartsBase().textStyledBoolean('保存', '', Colors.white, 14),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: (model.myselfChildDetail[index].isSaved == true)?
                    Icon(Icons.file_download_done_outlined):Icon(Icons.file_upload_outlined),
                ),
              ],
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: ColorBase().MainBlue(),
            primary: Colors.white,
            side: BorderSide(color: ColorBase().MainBlue()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (){
            model.updateChildField(index);
          },
        ),
      ),
    );
  }

  //追加・削除
  Widget addNewChildField(MySelfDataEditModel model, int index){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 300,
        height: 50,
        child: OutlinedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('お子様を追加する', style: TextStyle(color: Color.fromRGBO(19, 200, 188, 1.0), fontFamily: 'MPlusR', fontSize: 12)),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            primary: Color.fromRGBO(19, 200, 188, 1.0),
            side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: () async{
            model.addChildMap(index);
            Navigator.push(context, MaterialPageRoute(builder: (context) => MySelfEditPage()));
          },
        ),
      ),
    );
  }

  Widget removeLastChildField(MySelfDataEditModel model, int index){
    return OutlinedButton(
      child: Row(
        children: [
          Text('削除', style: TextStyle(color: Color.fromRGBO(19, 200, 188, 1.0), fontFamily: 'MPlusR', fontSize: 12)),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Icon(Icons.remove_circle),
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        primary: Color.fromRGBO(19, 200, 188, 1.0),
        side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: (){
        model.removeChildMap(index);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MySelfEditPage()));
      },
    );
  }
}