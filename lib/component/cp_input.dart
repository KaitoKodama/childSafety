import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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