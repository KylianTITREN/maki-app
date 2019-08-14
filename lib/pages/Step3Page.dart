import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/components/CSeparator.dart';
import 'package:c_valide/components/CVideo.dart';
import 'package:c_valide/models/Anomalie.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:sprintf/sprintf.dart';

class StepPage3 extends BaseStatefulWidget {
  StepPage3(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage3State();
}

class _StepPage3State extends BaseState<StepPage3> {
  static const int MAX_FILES = 7;

  List<Anomalie> _anomalies = [];
  List<File> _files = [null];

  StreamSubscription<Event> _subscription;

  @override
  Widget onBuild() {
    if (widget.parentState.currentStep == 2 && _anomalies.length <= 0) {
      _startValidationRequest();
    }

    return Container(
      padding: const EdgeInsets.all(32.0),
      child: _anomalies.length <= 0
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        Strings.textValidating,
                        style: Styles.text(context),
                      ),
                    ),
                    CSeparator(Colours.primaryColor),
                    CVideo(),
                  ],
                ),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        sprintf(Strings.textAnomaliesFolderNumber, [Registry.folderNumber]),
                        style: Styles.text(context),
                        textAlign: TextAlign.center,
                        softWrap: false,
                      ),
                      CSeparator(Colours.primaryColor),
                      Text(
                        sprintf(Strings.textNbAnomalies, [_anomalies.length]),
                        style: Styles.text(context),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: _anomalies.length,
                      itemBuilder: (context, index) {
                        Anomalie anomalie = _anomalies[index];
                        return AnomalieRow(anomalie);
                      },
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              Strings.textUploadDocuments,
                              style: Styles.littleTextPrimary(context),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4.0),
                              child: GridView.count(
                                primary: false,
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                mainAxisSpacing: 6.0,
                                crossAxisSpacing: 6.0,
                                padding: const EdgeInsets.all(16.0),
                                children: List.generate(_files.length, (index) {
                                  File file = _files[index];
                                  return file != null
                                      ? ImageButton(
                                          file,
                                          onPressed: () {
                                            onDocumentButtonPressed(file);
                                          },
                                        )
                                      : UploadButton(
                                          Icons.add_circle,
                                          onPressed: onUploadButtonPressed,
                                        );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CButton(
                        Strings.textSend,
                        color: Colours.primaryColor,
                        onPressed: () {
                          _onValidate();
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }

  void addFile(File file) {
    if (file != null) {
      _files.add(file);

      setState(() {});
    }
  }

  void removeFile(File file) {
    if (file != null) {
      _files.remove(file);

      setState(() {});
    }
  }

  void pickPDF() async {
    File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: ".pdf");
    addFile(file);
  }

  void pickImage() async {
    File file = await FilePicker.getFile(type: FileType.IMAGE);
    addFile(file);
  }

  void openCamera() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    addFile(file);
  }

  void onUploadButtonPressed() {
    if (_files.length >= MAX_FILES) {
      Page.toast(Strings.textLimitReached);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(8.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  textColor: Colours.primaryColor,
                  onPressed: () {
                    Page.quitPage(context);
                    pickPDF();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.insert_drive_file),
                      ),
                      Text(
                        "Choisir un PDF",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
                CSeparator(
                  Colours.grey,
                  height: 1,
                  width: 200,
                ),
                FlatButton(
                  textColor: Colours.primaryColor,
                  onPressed: () {
                    Page.quitPage(context);
                    pickImage();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.image),
                      ),
                      Text(
                        "Choisir une image",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
                CSeparator(
                  Colours.grey,
                  height: 1,
                  width: 200,
                ),
                FlatButton(
                  textColor: Colours.primaryColor,
                  onPressed: () {
                    Page.quitPage(context);
                    openCamera();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.camera_alt),
                      ),
                      Text(
                        "Prendre une photo",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void onDocumentButtonPressed(File file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Voulez-vous vraiment effacer ce document ?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Page.quitPage(context);
                removeFile(file);
              },
              child: Text("Effacer"),
            ),
            FlatButton(
              onPressed: () {
                Page.quitPage(context);
              },
              child: Text("Annuler"),
            ),
          ],
        );
      },
    );
  }

  void _startValidationRequest() {
    _subscription = FirebaseUtils.listenState(Registry.uid, ['ANOMALIES', 'REFUSED', 'VALIDATED'],
        callback: (state) {
      switch (state) {
        case 'ANOMALIES':
          {
            _startAnomaliesRequest();
            break;
          }
        case 'REFUSED':
          {
            Registry.folderValidated = false;
            _goToNextPage();
            break;
          }
        case 'VALIDATED':
          {
            Registry.folderValidated = true;
            _goToNextPage();
            break;
          }
      }
    });
  }

  void _startAnomaliesRequest() {
    _anomalies = List<Anomalie>.generate(
      1 + Random().nextInt(7),
      (index) {
        return Anomalie(
          text: lipsum.createWord(
            numWords: 3 + Random().nextInt(3),
          ),
        );
      },
    );

    setState(() {});
  }

  void _onValidate() {
    _sendDocuments();
  }

  void _sendDocuments() {
    delay(() {
      _anomalies = [];
      _files = [];

      setState(() {});
    }, 1000);
  }

  void _goToNextPage() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    widget.parentState.goToNextPage();
  }
}

class AnomalieRow extends StatelessWidget {
  AnomalieRow(this.anomalie);

  final Anomalie anomalie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colours.darkGrey,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        anomalie.text,
        style: Styles.textThin(context),
      ),
    );
  }
}

class UploadButton extends SquareButton {
  UploadButton(IconData icon, {VoidCallback onPressed})
      : super(
          Icon(
            icon,
            color: Colours.primaryColor,
            size: 32.0,
          ),
          onPressed: onPressed,
        );
}

class ImageButton extends SquareButton {
  ImageButton(File image, {VoidCallback onPressed})
      : super(
          Image.file(
            image,
            fit: BoxFit.cover,
          ),
          onPressed: onPressed,
        );
}

class SquareButton extends StatelessWidget {
  SquareButton(this.content, {this.onPressed});

  final Widget content;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: content,
      padding: EdgeInsets.all(2.0),
      color: Colors.black.withOpacity(0.2),
      onPressed: onPressed,
    );
  }
}
