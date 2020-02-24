import 'package:flutter/material.dart';

class TextSemiBold extends StatelessWidget {
  TextSemiBold({this.text, this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    String lastWord = text.substring(text.lastIndexOf(" ") + 1);

    return RichText(
      text: TextSpan(
        text: text.replaceAll(lastWord, '').toUpperCase(),
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: size ?? 18, fontWeight: FontWeight.w600),
        children: <TextSpan>[
          TextSpan(text: lastWord.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
