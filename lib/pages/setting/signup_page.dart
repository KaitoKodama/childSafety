import 'package:child_safety01/component/cp_button.dart';
import 'package:child_safety01/component/cp_input.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/models/setting/signup_model.dart';
import 'package:child_safety01/pages/friend/friend_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}
class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        backgroundColor: HexColor('#F3F7FD'),
        appBar: ApplicationSimpleHead(context),
        body: Consumer<SignUpModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 25),
                        child: Text(
                          'メールアドレスとパスワードを入力して\n新規登録をしてください',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: HexColor('#333333'),fontFamily: 'MPlusR',fontSize: 14),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: StyledInputField(HexColor('#1595B9'),HexColor('#1595B9'),'メールアドレス','',(text) => {
                          model.mail = text
                        })
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: StyledInputField(HexColor('#1595B9'),HexColor('#1595B9'),'パスワード','',(text) => {
                          model.password = text
                        })
                    ),
                    StyledButton('新規登録',HexColor('#1595B9'),HexColor('#FFFFFF'),HexColor('#1595B9'),() async{
                      try {
                        await model.requestSighup();
                        Navigator.pop(context);
                        Navigator.push(context,MaterialPageRoute(builder: (context) => FriendListPage()));
                      } catch (e) {
                        DisplayDialog('メールアドレスまたはパスワードに誤りがあります。','再度ご入力をお願いいたします。','戻る',context,()=>{
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
