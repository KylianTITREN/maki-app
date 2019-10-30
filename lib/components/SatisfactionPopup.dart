import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Const.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/DialogUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SatisfactionPopup extends BaseStatefulWidget {
  SatisfactionPopup([this.callback]);

  final VoidCallback callback;

  @override
  State<StatefulWidget> onBuild() => SatisfactionPopupState();
}

class SatisfactionPopupState extends BaseState<SatisfactionPopup> {
  double _score = 0;
  String _scoreComment = '';

  @override
  Widget onBuild() {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        backgroundColor: Colours.darkGrey,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_score <= 2 && _scoreComment == '') {
                toast('Veuillez ajouter un commentaire', gravity: ToastGravity.CENTER);
              } else {
                dismissKeyboard(context);
                DialogUtils.showLoading(context, text: 'Chargement');
                RestClient.jsonService.sendSatisfactionResult(Const.API_TOKEN, Registry.uid, _score.toInt(), _scoreComment).then((response) {
                  DialogUtils.dismiss(context);
                  print('Satisfaction sent !');
                  quitDialog(context);

                  if (widget.callback != null) {
                    widget.callback();
                  }
                }).catchError((object) {
                  DialogUtils.dismiss(context);
                  print('Error: $object');
                  quitDialog(context);

                  if (widget.callback != null) {
                    widget.callback();
                  }
                });
              }
            },
            child: Text('Envoyer'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Qu'avez-vous pensé de votre expérience ?",
              style: Styles.popupTitle(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.0),
            SmoothStarRating(
              allowHalfRating: false,
              onRatingChanged: (value) {
                _score = value;
                setState(() {});
              },
              starCount: 5,
              rating: _score,
              size: 40.0,
              color: Colours.primaryColor,
              borderColor: Colours.primaryColor,
              spacing: 0.0,
            ),
            SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                _scoreComment = value;
              },
              maxLines: 2,
              decoration: Styles.editText(context, hint: 'Commentaire'),
            ),
          ],
        ),
      ),
    );
  }
}
