import 'package:child_safety01/component/cp_button.dart';
import 'package:child_safety01/component/cp_prop.dart';
import 'package:child_safety01/component/funcwidget.dart';
import 'package:child_safety01/component/cp_screen.dart';
import 'package:child_safety01/models/user/qr_scan_model.dart';
import 'package:child_safety01/utility/enum.dart';
import 'package:child_safety01/utility/system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QRScanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => QRScanPageState();
}
class QRScanPageState extends State<QRScanPage>{
  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider<QRScanModel>(
      create: (_) => QRScanModel()..initQRScanModel(),
      child: Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Consumer<QRScanModel>(
            builder: (context, model, child) {
              if(!model.isLoading) return buildScreenWidget(model);
              return LoadingScreen();
            },
          ),
        ),
      ),
    );
  }

  Widget buildScreenWidget(QRScanModel model){
    return Column(
      children: [
        Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: buildQrView(model, context)
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  'QRコードをスキャンして\n友達追加機能を利用することができます。',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'MPlusR',fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: StyledButton('戻る', HexColor('#FFFFFF'), HexColor('#1595B9'), HexColor('#1595B9'), (){
                  model.closeCameraAndStream();
                  Navigator.of(context).pop();
                  //SplashScreen(context, AddFriendIDPage());
                }),
              ),
              StyledButton('マイQR', HexColor('#FFFFFF'), HexColor('#1595B9'), HexColor('#1595B9'), (){
                showModalBottomSheet(context: context, builder: (context){
                  return Container(
                    height: MediaQuery.of(context).size.height *0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: QrImage(data: model.uid, size: 200, backgroundColor: HexColor('#FFFFFF')),
                        ),
                        StyledButton('キャンセル', HexColor('#FFFFFF'), HexColor('#1595B9'), HexColor('#1595B9'), (){
                          Navigator.of(context).pop();
                        }),
                      ],
                    ),
                  );},isScrollControlled: true
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildQrView(QRScanModel model, BuildContext context) => QRView(
    key: GlobalKey(debugLabel: 'QR'),
    onQRViewCreated: (QRViewController controller){
      model.resumeCamera(controller);
      controller.scannedDataStream.listen((barcode) {
        setState(() async{
          if(model.scanBarcode != barcode.code){
            model.scanBarcode = barcode.code;
            RequestUnit requestUnit = await System().getRequestState(model.myFriendList, model.myFriendRequireList, model.scanBarcode);
            if(requestUnit.requestState == RequestState.Accept){
              DisplayDialog('スキャンを完了しました', requestUnit.logMessage, '決定', context, (){
                model.saveUIDToBothField();
                Navigator.of(context).pop();
              });
            }
            else{
              DisplayDialog('スキャンを完了しました', requestUnit.logMessage, '戻る', context, (){
                Navigator.of(context).pop();
              });
            }
          }
        });
      });
    },
    overlay: QrScannerOverlayShape(
      borderRadius: 10,
      borderWidth: 10,
      cutOutSize: MediaQuery.of(context).size.width*0.8,
    ),
  );
}