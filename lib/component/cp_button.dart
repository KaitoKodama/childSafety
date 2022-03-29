import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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

class StyledButtonTiny extends StatelessWidget{
  StyledButtonTiny(this.text, this.textColor, this.buttonColor, this.onPressed);
  final String text;
  final Color textColor;
  final Color buttonColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: OutlinedButton(
        child: Text(text, style: TextStyle(color: textColor, fontFamily: 'MPlus', fontSize: 12)),
        style: OutlinedButton.styleFrom(
          backgroundColor: buttonColor,
          side: BorderSide(color: buttonColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
        ),
        onPressed: () => { onPressed() },
      ),
    );
  }
}

class StyledIconButton extends StatelessWidget{
  StyledIconButton(this.icon, this.size, this.color, this.onPressed);
  final Icon icon;
  final double size;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: OutlinedButton(
        child: icon,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        onPressed: () async =>{ onPressed() },
      ),
    );
  }
}