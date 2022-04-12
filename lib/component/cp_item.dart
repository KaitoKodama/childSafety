import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cp_prop.dart';


class StyledFriendItem extends StatelessWidget{
  StyledFriendItem(this.iconProvider, this.mainText, this.subText, this.onPressed);
  final ImageProvider iconProvider;
  final String mainText;
  final String subText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: OutlinedButton(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CircleIconItem(60, iconProvider),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mainText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13,fontFamily: 'MPlus',color: HexColor('#333333')),
                  ),
                  Text(subText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,fontFamily: 'MPlus',color: HexColor('#8E8E8E')),
                  ),
                ],
              ),
            ),
          ],
        ),
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
            side: BorderSide(color: Theme.of(context).canvasColor)
        ),
        onPressed: (){ onPressed(); },
      ),
    );
  }
}


class CircleIconItem extends StatelessWidget{
  CircleIconItem(this.size, this.iconProvider);
  final double size;
  final ImageProvider iconProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: HexColor('#FFE33F'), width: 1),
        shape: BoxShape.circle,
        image: DecorationImage(fit: BoxFit.cover, image: iconProvider),
      ),
    );
  }
}
class CircleIconItemProgress extends StatelessWidget{
  CircleIconItemProgress(this.size);
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CircularProgressIndicator(),
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: HexColor('#FFE33F'), width: 1),
        shape: BoxShape.circle,
      ),
    );
  }
}