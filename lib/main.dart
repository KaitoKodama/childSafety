import 'package:child_safety01/pages/friend/friend_list_page.dart';
import 'package:child_safety01/pages/setting/login_page.dart';
import 'package:child_safety01/pages/setting/reset_page.dart';
import 'package:child_safety01/pages/setting/signup_page.dart';
import 'package:child_safety01/utility/system.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'component/cp_button.dart';
import 'component/cp_prop.dart';
import 'component/funcwidget.dart';
import 'main_model.dart';


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
    return Scaffold(
      backgroundColor: HexColor('#F3F7FD'),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Stack(
                    children: [
                      Container(width: 300, height: 225),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn,
                        builder: (BuildContext context, double double, Widget? child) {
                          return Positioned(
                            top: ClampValue().getClampValue(10, double),
                            child: Opacity(
                              opacity: double,
                              child: SizedBox(
                                width: 300,
                                child: Image.asset('images/top_logo.png'),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: StyledButton('新規登録',HexColor('#1595B9'),HexColor('#FFFFFF'),HexColor('#1595B9'),(){
                  SplashScreen(context, SignupPage());
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: StyledButton('ログイン',HexColor('#FFFFFF'),HexColor('#58C1DF'),HexColor('#58C1DF'), ()async{
                  var state = await MainModel().getLoginState();
                  if (state == LoginState.CompletedLogin) {
                    try{
                      await MainModel().onDocumentFieldCheck();
                      SplashScreen(context, FriendListPage());
                    }
                    catch(exe){
                      DisplayDialog('フィールドの不一致を確認。復旧が必要です', '復旧完了後、再度プロフィール情報を記述ください', '復旧開始', context, () async{
                        await ResetManager().resetDocumentField();
                        SplashScreen(context, FriendListPage());
                      });
                    }
                  }
                  else {
                    SplashScreen(context, LoginPage());
                  }
                }),
              ),
              StyledButton('パスワードをお忘れの方はコチラ',HexColor('#FFFFFF'),HexColor('#1595B9'),HexColor('#1595B9'),(){
                SplashScreen(context, ResetPage());
                },
              ),
            ],
          ),
        ),
    );
  }
}
