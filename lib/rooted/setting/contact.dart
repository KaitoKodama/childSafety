import 'package:child_safety01/rooted/setting/setting_models/contact_model.dart';
import 'package:child_safety01/system/system.dart';
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
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<ContactModel>(
        create: (_) => ContactModel(),
        child: Scaffold(
        appBar: Header(context),
          body: Consumer<ContactModel>(
            builder: (context, model, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SmallPartsBase().textStyledBoolean(
                        'お問い合わせはこちらからお願いします。\n*外部リンクへ飛びます', '',
                        ColorBase().SubGray(), 14),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 200,
                        child: OutlinedButton(
                          style: buttonStyle(),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.contact_mail_outlined),
                              ),
                              Text('お問い合わせ'),
                            ],
                          ),
                          onPressed: (){
                            model.lunchTargetUrl();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
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