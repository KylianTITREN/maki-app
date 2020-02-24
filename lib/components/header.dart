import 'package:flutter/material.dart';
import 'package:maki_app/components/text-semibold.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader({this.icon, this.title, this.func, this.isize});

  final String icon;
  final String title;
  final Function func;
  final double isize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                icon,
                style: TextStyle(fontSize: isize ?? 77),
              ),
              TextSemiBold(text: title, size: 24)
            ],
          ),
          func == null
              ? Container()
              : GestureDetector(
                  onTap: func,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.add,
                      size: 28,
                      color: Colors.white,
                    ),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black12,
                            offset: new Offset(0.0, 0.0),
                            blurRadius: 13)
                      ],
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
