import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.text, this.func, this.bgColor});

  final String text;
  final Function func;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            bgColor !=null ? bgColor : Theme.of(context).accentColor,
            bgColor !=null ? bgColor.withOpacity(0.6) : Color.fromRGBO(255, 206, 69, 1)
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: RaisedButton(
        color: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.all(10),
        onPressed: func,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
