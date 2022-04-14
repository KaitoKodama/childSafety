import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cp_prop.dart';


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
              Image.asset('images/top_logo.png'),
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