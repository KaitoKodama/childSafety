import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'extends.dart';


/* ---------------------------------------
 ボタン
---------------------------------------- */
class StyledButton extends StatelessWidget{
  StyledButton(this.text, this.textColor, this.backgroundColor, this.borderColor, this.onClick);
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: OutlinedButton(
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontFamily: 'MPlusR'),),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
        ),
        onPressed: ()async=>{onClick()},
      ),
    );
  }
}

/* ---------------------------------------
 入力フィールド
---------------------------------------- */
class StyledInputField extends StatelessWidget{
  StyledInputField(this.textColor, this.borderColor, this.hintText, this.defaultText, this.onChanged);
  final Color textColor;
  final Color borderColor;
  final String hintText;
  final String defaultText;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 50,
      child: TextFormField(
        onChanged: (text) => {onChanged(text)},
        initialValue: defaultText,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: textColor,fontFamily: 'MPlusR'),
          hintStyle: TextStyle(color: textColor,fontFamily: 'MPlusR'),
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor,width: 2,),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor,width: 2,),
          ),
        ),
      ),
    );
  }
}

/* ---------------------------------------
 フレンドアイテム
---------------------------------------- */
class StyledFriendItem extends StatelessWidget{
  StyledFriendItem(this.iconProvider, this.mainText, this.subText, this.onPressed);
  final ImageProvider iconProvider;
  final String mainText;
  final String subText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor('#FFE33F'), width: 1),
                  shape: BoxShape.circle,
                  image: DecorationImage(fit: BoxFit.cover, image: iconProvider),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mainText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,fontFamily: 'MPlus',color: HexColor('#333333')),
                  ),
                  Text(subText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,fontFamily: 'MPlus',color: HexColor('#8E8E8E')),
                  ),
                ],
              ),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            side: BorderSide(color: Theme.of(context).canvasColor)
        ),
        onPressed: (){ onPressed(); },
      ),
    );
  }
}

/* ---------------------------------------
 ローディング画面
---------------------------------------- */
class LoadingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#F3F7FD'),
      width: double.infinity,
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('images/top_logo.svg'),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------------------------------
 リスト表示
---------------------------------------- */
class ListTitle extends StatelessWidget{
  ListTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(title, style: TextStyle(color: HexColor('#1595B9'), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'MPlus')),
    );
  }
}
class ListContents extends StatelessWidget{
  ListContents(this.title, this.content);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(title, style: TextStyle(color: HexColor('#1595B9'), fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Text(content, style: TextStyle(color: HexColor('#707070'), fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}
class ListConclusion extends StatelessWidget{
  ListConclusion(this.conclude);
  final String conclude;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(conclude, style: TextStyle(color: HexColor('#707070'), fontSize: 12, fontWeight: FontWeight.normal)),
    );
  }
}