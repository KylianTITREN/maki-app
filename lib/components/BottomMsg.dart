import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/components/MsgListItem.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomMsg extends StatefulWidget {
  const BottomMsg();

  @override
  _BottomMsgState createState() => _BottomMsgState();
}

class _BottomMsgState extends State<BottomMsg> {
  static final TextEditingController _msgFieldController =
      TextEditingController();
  bool _isComposingMessage = false;
  int numberOfMsg;
  static String parentFolder = FlavorConfig.isProduction() ? 'prod' : 'test';
  final reference = FirebaseDatabase.instance
      .reference()
      .child(parentFolder)
      .child('chats')
      .child(Registry.chatUid);

  @override
  Widget build(BuildContext context) {
    reference.child('messages').once().then((onValue) {
      Map data = onValue.value;
      if (data != null) {
        numberOfMsg = data.length - 1;
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ModalBar(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 12, bottom: 15),
                    child: Text(
                      'Conseiller',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        height: MediaQuery.of(context).size.height * 0.61,
                        child: new FirebaseAnimatedList(
                          query: reference.child('messages'),
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 3),
                          reverse: true,
                          sort: (a, b) => DateTime.fromMillisecondsSinceEpoch(
                                  b.value['created_at'])
                              .compareTo(DateTime.fromMillisecondsSinceEpoch(
                                  a.value['created_at'])),
                          itemBuilder: (_, DataSnapshot messageSnapshot,
                              Animation<double> animation, int index) {
                            return new MessageListItem(
                              messageSnapshot: messageSnapshot,
                              animation: animation,
                              isFirst: index == numberOfMsg ? true : false,
                            );
                          },
                        ),
                      ),
                      new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colours.primaryColor),
                            borderRadius: BorderRadius.circular(8)),
                        child: _buildTextComposer(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Envoyer"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_msgFieldController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_msgFieldController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(
        color: _isComposingMessage
            ? Theme.of(context).accentColor
            : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: TextField(
                controller: _msgFieldController,
                onChanged: (String messageText) {
                  setState(() {
                    _isComposingMessage = messageText.length > 0;
                  });
                },
                maxLength: 280,
                focusNode: FocusNode(),
                onSubmitted: _textMessageSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "Envoyer un message"),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? getIOSSendButton()
                  : getDefaultSendButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    if (Registry.magasin == null) {
      InformationDialog(context, text: 'Veuillez choisir un magasin').show();
    } else if (_msgFieldController.text.isNotEmpty) {
      _msgFieldController.clear();

      setState(() {
        _isComposingMessage = false;
      });

      FirebaseUtils.setChatMessage(Registry.chatUid, text);
    }
  }
}

class ModalBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 110),
      decoration: BoxDecoration(
        color: Colours.darkGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
