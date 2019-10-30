import 'dart:io';
import 'dart:math';

import 'package:c_valide/app/Const.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/models/Anomalie.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import 'CSeparator.dart';

class CAnomalieDetails extends StatefulWidget {
  CAnomalieDetails(this._anomalie);

  final Anomalie _anomalie;

  @override
  State<StatefulWidget> createState() => _CAnomalieDetailsState(_anomalie);
}

class _CAnomalieDetailsState extends State<CAnomalieDetails> {
  _CAnomalieDetailsState(this._anomalie);

  Anomalie _anomalie;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int length = min(1 + _anomalie.filesAssociated.length, Const.MAX_FILES);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _anomalie.nom != null
              ? Container(
                  child: Text(
                    _anomalie.nom,
                    textAlign: TextAlign.center,
                    style: Styles.appBarTitle(context),
                  ),
                )
              : Container(),
          SizedBox(height: 15),
          _anomalie.mailAddon != null
              ? Container(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 5),
                  child: Text(
                    _anomalie.mailAddon,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Styles.text(context),
                  ),
                )
              : Container(),
          _anomalie.mailAddon != null && _anomalie.mailAddon != "" && _anomalie.mailAddon.length > 230
              ? 
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: FlatButton(
                  onPressed: () {
                    _onMailAddonTapped(_anomalie.mailAddon);
                  },
                  child: Text(
                    'Voir plus',
                    style: Styles.littleTextPrimary(context),
                  ),
                ))
              : Container(),
          Registry.folderValidated != 1
              ? GridView.count(
                  primary: false,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 6.0,
                  crossAxisSpacing: 6.0,
                  padding: const EdgeInsets.all(16.0),
                  children: List.generate(
                    length,
                    (index) {
                      if (index == _anomalie.filesAssociated.length) {
                        return UploadButton(
                          Icons.add_circle,
                          onPressed: onUploadButtonPressed,
                        );
                      } else {
                        File file = _anomalie.filesAssociated[index];
                        return DocumentButton(
                          context,
                          file,
                          onPressed: () {
                            onDocumentButtonPressed(file);
                          },
                        );
                      }
                    },
                  ),
                )
              : Container(),
          CButton(
            Registry.folderValidated != 1 ? Strings.textValidate : Strings.textCancel,
            color: Colours.primaryColor,
            onPressed: () {
              quitPage(context);
            },
          ),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  void _onMailAddonTapped(String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Commentaire',
                  textAlign: TextAlign.center,
                  style: Styles.appBarTitle(context),
                ),
                SizedBox(height: 8.0),
                Text(description),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                quitDialog(context);
              },
              child: Text(Strings.textOk),
            ),
          ],
        );
      },
    );
  }

  void onDocumentButtonPressed(File file) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.textAreYouSureToDeleteThisDocument),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                quitPage(context);
                removeFile(file);
              },
              child: Text(Strings.textErase),
            ),
            FlatButton(
              onPressed: () {
                quitPage(context);
              },
              child: Text(Strings.textCancel),
            ),
          ],
        );
      },
    );
  }

  void onUploadButtonPressed() {
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
                  quitPage(context);
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
                  quitPage(context);
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
                  quitPage(context);
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

  void addFile(File file) {
    if (file != null) {
      _anomalie.filesAssociated.add(file);
      setState(() {});
    }
  }

  void removeFile(File file) {
    if (file != null) {
      _anomalie.filesAssociated.remove(file);
      setState(() {});
    }
  }

  void pickPDF() async {
    File file =
        await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: "pdf");
    addFile(file);
  }

  void pickImage() async {
    File file = await FilePicker.getFile(type: FileType.IMAGE);
    addFile(file);
  }

  void openCamera() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 70);
    addFile(file);
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

class DocumentButton extends SquareButton {
  DocumentButton(BuildContext context, File file, {VoidCallback onPressed})
      : super(
          lookupMimeType(file.path) == 'application/pdf'
              ? Text(
                  path.basename(file.path),
                  style: Styles.text(context),
                )
              : Image.file(
                  file,
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
