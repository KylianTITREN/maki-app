import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/card.dart';
import 'package:maki_app/components/skeleton.dart';
import 'package:maki_app/pages/dictionnary.dart';
import 'package:maki_app/pages/gallerie.dart';
import 'package:maki_app/pages/recettes.dart';
import 'package:maki_app/pages/vlog.dart';
import 'package:maki_app/utils/Dialogs.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static get tag => '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) => {getMsg(), timer.cancel()});
    super.initState();
  }

  getMsg() {
    FirebaseUtils.getMessage(context, onSuccess: () {
      if (Registry.message.url != '') {
        ChoicesDialog(
          context,
          Text(Registry.message.content),
          actions: <String, VoidCallback>{
            'Plus tard': () {
              quitDialog(context);
              FirebaseUtils.updateMessage();
            },
            'Mettre à jour': () {
              launch(Registry.message.url).then((value) {
                quitDialog(context);
                FirebaseUtils.updateMessage();
              });
            },
          },
        ).show();
      } else {
        ChoicesDialog(
          context,
          Text(Registry.message.content),
          actions: <String, VoidCallback>{
            'Fermer': () {
              quitDialog(context);
              FirebaseUtils.updateMessage();
            },
          },
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CustomCard(
                icon: '🍔',
                title: 'maki recettes',
                func: () => startPage(context, RecettesPage())),
            SizedBox(height: 30),
            CustomCard(
                icon: '📸',
                title: 'maki gallerie',
                func: () => startPage(context, GalleriePage())),
            SizedBox(height: 30),
            CustomCard(
                icon: '📖',
                title: 'maki dico',
                func: () => startPage(context, DicoPage())),
            SizedBox(height: 30),
            CustomCard(
                icon: '🎥',
                title: 'maki vlog',
                func: () => startPage(context, VlogPage())),
          ],
        ),
      ),
    );
  }
}
