import 'package:c_valide/res/Colours.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final bool isFirst;

  MessageListItem({this.messageSnapshot, this.animation, this.isFirst});

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Column(
        children: <Widget>[
          isFirst
              ? new Text(
                  DateFormat('kk:mm').format(DateTime.now()),
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                )
              : Container(),
          isFirst && messageSnapshot.value['from'] == "APP"
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Un conseiller va vous répondre dans quelques instants.',
                    style: TextStyle(fontSize: 12, color: Colors.black26),
                  ),
                )
              : Container(),
          new Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: new Row(
              children: "APP" == messageSnapshot.value['from']
                  ? getSentMessageLayout()
                  : getReceivedMessageLayout(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                color: Colours.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(
                messageSnapshot.value['message'],
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                color: Colours.darkGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(
                messageSnapshot.value['message'],
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
