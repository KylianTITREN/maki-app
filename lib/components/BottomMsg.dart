import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';

class BottomMsg extends StatefulWidget {
  const BottomMsg({Key key}) : super(key: key);

  @override
  _BottomMsgState createState() => _BottomMsgState();
}

class _BottomMsgState extends State<BottomMsg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 120),
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
              const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ModalBar(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
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
              MessagesBox(),
            ],
          ),
        ),
      ),
    );
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

class MessagesBox extends StatelessWidget {
  static final TextEditingController _msgFieldController =
      TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  var listMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colours.primaryColor),
                borderRadius: BorderRadius.circular(8)),
            height: 35,
            child: TextField(
              controller: _msgFieldController,
              decoration: InputDecoration(
                  hintText: 'Entrez votre message...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                      color: Colours.primaryColor,
                    ),
                    onPressed: () {
                      print(_msgFieldController.text);
                    },
                  )),
            ),
          )
        ],
      ),
    );
  }
}
