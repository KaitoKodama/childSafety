import 'package:flutter/cupertino.dart';
import 'cp_prop.dart';


class ListTitle extends StatelessWidget{
  ListTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(title, style: TextStyle(color: HexColor('#1595B9'), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'MPlus')),
    );
  }
}
class ListContents extends StatelessWidget{
  ListContents(this.title, this.content);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(title, style: TextStyle(color: HexColor('#1595B9'), fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          Text(content, style: TextStyle(color: HexColor('#707070'), fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}
class ListConclusion extends StatelessWidget{
  ListConclusion(this.conclude);
  final String conclude;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(conclude, style: TextStyle(color: HexColor('#707070'), fontSize: 12, fontWeight: FontWeight.normal)),
    );
  }
}