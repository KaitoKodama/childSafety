import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/system/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'initial_models/login_model.dart';


class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        backgroundColor: HexColor('#F3F7FD'),
        appBar: ApplicationSimpleHead(context),
        body: Consumer<LoginModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 25),
                        child: Text(
                          'メールアドレスとパスワードを入力して\nログインしてください',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: HexColor('#333333'),fontFamily: 'MPlusR',fontSize: 14),
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: BuildWidget().buildTextFormFieldWidget(HexColor('#58C1DF'),HexColor('#58C1DF'),'メールアドレス','',(text)=>{
                          model.mail = text
                        }),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: BuildWidget().buildTextFormFieldWidget(HexColor('#58C1DF'),HexColor('#58C1DF'),'パスワード','',(text)=>{
                          model.password = text
                        }),
                    ),
                    BuildWidget().styledButton('ログイン',HexColor('#FFFFFF'),HexColor('#58C1DF'),HexColor('#58C1DF'),() async {
                      try {
                        await model.loginRequest();
                        Navigator.pop(context);
                        Navigator.push(context,MaterialPageRoute(builder: (context) => FriendListPage()));
                      }
                      catch(e){
                        BuildWidget().buildDialog('メールアドレスまたはパスワードに誤りがあります。','再度ご入力をお願いいたします。','戻る',context,()=>{
                          Navigator.pop(context)
                        });
                      }
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}