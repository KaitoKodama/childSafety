import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/system/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'initial_models/login_model.dart';


class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{

  //メインウィジェット
  @override
  Widget build(BuildContext context){
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel()..fetchLoginState(),
      child: Scaffold(
        backgroundColor: ColorBase().TopBackGroundBlue(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorBase().TopBackGroundBlue(),
          automaticallyImplyLeading: false,
          title: Text('まぱこ', style: TextStyle(fontFamily: 'MPlus', fontWeight: FontWeight.bold, fontSize: 30, color: ColorBase().MainBlue()),),
        ),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            // ------------- オフライン画面 -------------
            if(model.isOffline){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.offline_bolt_outlined),
                          Text('オフラインです'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            // ------------ ローディング画面 -------------
            else if(model.isLoading){
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   CircularProgressIndicator(),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.downloading_outlined),
                         Text('ローディング中です'),
                       ],
                     ),
                   ),
                 ],
               ),
             );
            }
            // -------------- メイン画面 -----------------
            else{
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 5),
                        child: SmallPartsBase().textStyledBoolean('メールアドレスとパスワードを入力して\nログインしてください', '', ColorBase().SubGray(), 15),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: WidgetBase().initialDecoration('example@google.com'),
                          initialValue: model.mail,
                          onChanged: (text) {
                            model.mail = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: WidgetBase().initialDecoration('パスワード'),
                          controller: passwordController,
                          onChanged: (text) {
                            model.password = text;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: OutlinedButton(
                          child: SmallPartsBase().textStyledBoolean('ログイン', '', Colors.white, 12),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: ColorBase().MainBlue(),
                            primary: Colors.white,
                            side: BorderSide(color: ColorBase().MainBlue()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              await model.login();
                              if(!model.isOffline){
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FriendListPage()),
                                );
                              }
                            }
                            catch(e){
                              createErrorDialog(e.toString());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void createErrorDialog(String exe){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Text(exe),
          actions: [
            OutlinedButton(
              style: buttonStyle(),
              child: Text('OK'),
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
  ButtonStyle buttonStyle(){
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      primary: Color.fromRGBO(19, 200, 188, 1.0),
      side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}