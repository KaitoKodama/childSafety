import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactModel extends ChangeNotifier{

  Future lunchTargetUrl() async{
    final url = 'https://barneyz.com/contact';
    if(await canLaunch(url)){
      await launch(url);
    }
  }
}