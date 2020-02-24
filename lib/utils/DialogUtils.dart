import 'package:c_valide/basics/BaseStatelessWidget.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';

class DialogUtils extends BaseStatelessWidget {
  DialogUtils(this.text);

  final String text;

  @override
  Widget onBuild() {
    return AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(text ?? ''),
          ),
        ],
      ),
    );
  }

  static void showLoading(BuildContext context, {String text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DialogUtils(text);
      },
    );
  }

  static void dismiss(BuildContext context) {
    quitPage(context);
  }
}
