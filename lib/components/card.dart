import 'package:flutter/material.dart';
import 'package:maki_app/components/text-semibold.dart';

class CustomCard extends StatelessWidget {
  CustomCard({this.icon, this.title, this.func});

  final String icon;
  final String title;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
                color: Colors.black12,
                offset: new Offset(0.0, 0.0),
                blurRadius: 13)
          ],
          color: Theme.of(context).cardColor,
          borderRadius: new BorderRadius.all(Radius.circular(15.0)),
        ),
        height: 80,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(icon, style: TextStyle(fontSize: 44)),
            SizedBox(width: 30),
            TextSemiBold(text: title)
          ],
        ),
      ),
    );
  }
}
