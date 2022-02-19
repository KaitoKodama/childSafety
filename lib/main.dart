import 'package:child_safety01/initial/login_page.dart';
import 'package:child_safety01/initial/reset_page.dart';
import 'package:child_safety01/main_model.dart';
import 'package:child_safety01/rooted/friend/friend_list_page.dart';
import 'package:child_safety01/system/common.dart';
import 'package:child_safety01/system/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'initial/signup_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      child: Scaffold(
        backgroundColor: HexColor('#F3F7FD'),
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.0),
          elevation: 0.0,
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 35),
                    child: SvgPicture.asset('images/top_logo.svg')),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: BuildWidget().styledButton('新規登録',HexColor('#1595B9'),HexColor('#FFFFFF'),HexColor('#1595B9'),(){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => SignupPage()));
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: BuildWidget().styledButton('ログイン',HexColor('#FFFFFF'),HexColor('#58C1DF'),HexColor('#58C1DF'), ()async{
                    await model.checkLoginState();
                    if (model.loginState == LoginState.CompletedLogin) {
                      try{
                        await model.onDocumentFieldCheck();
                        Navigator.push(context,MaterialPageRoute(builder: (context) => FriendListPage()));
                      }
                      catch(exe){
                        BuildWidget().buildDialog('フィールドの不一致を確認。復旧が必要です', '復旧完了後、再度プロフィール情報を記述ください', '復旧開始', context, () async{
                          await FitDocumentField().updateRequire();
                          Navigator.push(context,MaterialPageRoute(builder: (context) => FriendListPage()));
                        });
                      }
                    }
                    else {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  }),
                ),
                BuildWidget().styledButton('パスワードをお忘れの方はコチラ',HexColor('#FFFFFF'),HexColor('#1595B9'),HexColor('#1595B9'),(){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ResetPage()));
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
