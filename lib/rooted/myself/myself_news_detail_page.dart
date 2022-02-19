import 'package:child_safety01/system/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySelfNewsDetailPage extends StatelessWidget{
  MySelfNewsDetailPage(this.newsTitle, this.newsContent);
  String newsTitle;
  String newsContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ApplicationHead(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmallPartsBase().textStyledBoolean(newsTitle, '', Colors.black, 14),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmallPartsBase().textStyledBoolean(newsContent, '', ColorBase().SubGray(), 12),
            ),
          ],
        ),
    );
  }
}