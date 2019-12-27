import 'dart:async';

import 'package:c_valide/components/BottomMsg.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/models/Magasin.dart';
import 'package:c_valide/components/ShopPopup.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/api/Requests.dart';
import 'package:c_valide/res/Strings.dart';

class CPage extends StatefulWidget {
  const CPage({this.child, this.fab, this.backgroundColor});

  final Widget child;
  final Widget fab;
  final Color backgroundColor;

  @override
  CPageState createState() => CPageState();
}

class CPageState extends State<CPage> {
  int showPopup = 0;
  Magasin filterMagasin;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () => showPopup == 0 ? _chooseShop() : null);
  }

  void updateData(Magasin shopChoosen) {
    LoadingDialog(context, text: Strings.textLoading).show();
    Requests.startAllDataRequest(
      context,
      description: Strings.textErrorOccurredTryAgain,
      negative: Strings.textCancel,
      onRequestFinished: () {
        quitDialog(context);
        setState(() {
          Registry.magasin = shopChoosen;
        });
      },
      onRequestError: () {
        quitDialog(context);
      },
    );
  }

  void _chooseShop() {
    showPopup++;
    showDialog(
      context: context,
      builder: (_) => ShopPopup(
        onValueChanged: (filterMagasin) {
          Registry.magasin = filterMagasin;
          quitDialog(context);
          updateData(filterMagasin);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.backgroundColor ?? Colors.black87,
        child: SafeArea(
            child: widget.child,
          ),
          //TODOO
          // Stack(children: <Widget>[
          // Positioned(
          //   top: 30,
          //   right: 30,
          //   child: GestureDetector(
          //     onTap: () {
          //       _chooseShop();
          //     },
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Text(
          //           Registry.magasin == null
          //               ? 'Aucun sélectionné'
          //               : Registry.magasin.name,
          //           style: TextStyle(
          //             color: Colors.white,
          //           ),
          //         ),
          //         SizedBox(width: 12),
          //         Image.asset(
          //           "assets/images/shape-shop.png",
          //           fit: BoxFit.contain,
          //           color: Colors.white,
          //           height: 24,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // SafeArea(
          //   child: widget.child,
          // ),
        // ]),
      ),
      floatingActionButton: widget.fab,
    );
  }
}

class MyFloatingButton extends StatefulWidget {
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;
  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colours.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset("assets/images/msg-shape.png"),
            ),
            onPressed: () {
              var sheetController = showBottomSheet(
                  context: context,
                  backgroundColor: Colors.black54,
                  builder: (context) => BottomMsg());

              _showButton(false);

              sheetController.closed.then((value) {
                _showButton(true);
              });
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
