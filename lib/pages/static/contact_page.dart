import 'package:child_safety01/component/extends.dart';
import 'package:child_safety01/component/header.dart';
import 'package:child_safety01/models/static/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget{
  @override
  _ContactPageState createState() => _ContactPageState();
}

//お問い合わせページ
class _ContactPageState extends State<ContactPage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<ContactModel>(
        create: (_) => ContactModel(),
        child: Scaffold(
        appBar: ApplicationHead(context),
          body: Consumer<ContactModel>(
            builder: (context, model, child) {
              return buildScreenWidget(model);
            }
          ),
        ),
    );
  }

  Widget buildScreenWidget(ContactModel model){
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text('お問い合わせはこちら', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 18)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('外部リンクへ移動します', style: TextStyle(color: HexColor('#000000'), fontFamily: 'MPlusR', fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton(
                    child: Text('お問い合わせページに移動', style: TextStyle(color: HexColor('#FFFFFF'), fontFamily: 'MPlus', fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: HexColor('#1595B9'),
                      side: BorderSide(color: HexColor('#1595B9')),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    ),
                    onPressed: () {
                      model.lunchTargetUrl();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}