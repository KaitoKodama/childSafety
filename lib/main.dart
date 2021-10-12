import 'package:child_safety01/initial/login_page.dart';
import 'package:child_safety01/system/system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'initial/signup_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '子供アプリ製品版',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //--------- パスワードリセット用(main.dartのみmodel無し) -------------
  final auth = FirebaseAuth.instance;
  String email = '';
  @override
  void initState() {
    if(auth.currentUser != null){
      email = FirebaseAuth.instance.currentUser!.email.toString();
    }
    super.initState();
  }
  Future resetPassword() async{
    await auth.sendPasswordResetEmail(email: email);
  }
  // --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 252, 255, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: Column(
                children: [
                  Text('まぱこ', style: TextStyle(color: Color.fromRGBO(19, 200, 188, 1.0), fontFamily: 'MPlus', fontSize: 40)),
                  SmallPartsBase().textStyledBoolean('我が子の情報共有アプリ', '', ColorBase().SubGray(), 15),
                ],
              ),
            ),
            initialButton('新規登録', SignupPage()),
            initialButton('ログイン', LoginPage()),
            resetButton(context),
          ],
        ),
      ),
    );
  }


  Widget initialButton(String text, Widget route){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 300,
        height: 50,
        child: OutlinedButton(
          child: Text(text, style: TextStyle(color: Color.fromRGBO(19, 200, 188, 1.0), fontFamily: 'MPlusR', fontSize: 12)),
          style: buttonStyle(),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          },
        ),
      ),
    );
  }
  Widget resetButton(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 300,
        height: 50,
        child: OutlinedButton(
          child: Text('パスワードを忘れた', style: TextStyle(color: Color.fromRGBO(19, 200, 188, 1.0), fontFamily: 'MPlusR', fontSize: 12)),
          style: buttonStyle(),
          onPressed: (){
            resetPasswordDialog(context);
          },
        ),
      ),
    );
  }

  void resetPasswordDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('パスワードをリセットしますか？', style: dialogTextStyle(16)),
            content: Text('メールアドレス：'+email.toString()+'\n宛にパスワードの再設定メールが届きます。', style: dialogTextStyle(14)),
            actions: [
              OutlinedButton(
                child: Text('リセット', style: dialogTextStyle(14),),
                style: buttonStyleDialog(),
                onPressed: () async{
                  await resetPassword();
                  Navigator.of(context).pop();
                },
              ),
              OutlinedButton(
                child: Text('キャンセル', style: dialogTextStyle(14)),
                style: buttonStyleDialog(),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  ButtonStyle buttonStyle(){
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      primary: Color.fromRGBO(19, 200, 188, 1.0),
      side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }
  ButtonStyle buttonStyleDialog(){
    return OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      primary: Color.fromRGBO(19, 200, 188, 1.0),
      side: BorderSide(color: Color.fromRGBO(19, 200, 188, 1.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
  TextStyle dialogTextStyle(double size){
    return TextStyle(
      fontSize: size,
      fontFamily: 'MPlusR',
      fontWeight: FontWeight.w600,
      color: ColorBase().SubGray(),
    );
  }
}
