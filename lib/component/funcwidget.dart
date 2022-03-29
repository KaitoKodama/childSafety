import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cp_prop.dart';


class SplashScreen{
  SplashScreen(BuildContext context, Widget route){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return route;
        },
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final Animatable<double> tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut));
          final Animation<double> doubleAnimation = animation.drive(tween);
          return FadeTransition(
            opacity: doubleAnimation,
            child: child,
          );
        },
      ),
    );
  }
}


class DisplayDialog{
  DisplayDialog(String titleText, String contentText, String buttonText, BuildContext context, Function actionTap){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(25),
            contentPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
            actionsPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
            buttonPadding: const EdgeInsets.all(0),
            backgroundColor: HexColor('#F3F7FD'),
            title: Text(titleText, style: TextStyle(fontSize: 14, fontFamily: 'MPlus')),
            content: Text(contentText, style: TextStyle(fontSize: 14, fontFamily: 'MPlusR')),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: HexColor('#1595B9'),
                    side: BorderSide(color: HexColor('#1595B9')),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),),
                  ),
                  child: Text(buttonText, style: TextStyle(color: HexColor('#FFFFFF'), fontSize: 16, fontFamily: 'MPlusR')),
                  onPressed: ()=>{ actionTap() },
                ),
              ),
            ],
          );
        }
    );
  }
}