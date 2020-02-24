import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/header.dart';
import 'package:maki_app/components/skeleton.dart';
import 'package:maki_app/models/Picture.dart';
import 'package:maki_app/pages/show-image.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';

class GalleriePage extends StatefulWidget {
  static get tag => '/Gallerie';

  @override
  _GalleriePageState createState() => _GalleriePageState();
}

class _GalleriePageState extends State<GalleriePage> {
  List<Picture> _allImages;

  @override
  void initState() {
    FirebaseUtils.getImagesLink();
    setState(() {
      _allImages = Registry.allImages;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      menuIcon: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 45),
        child: Column(
          children: <Widget>[
            CustomHeader(
              icon: '📸',
              title: 'maki gallerie',
              func: () => showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text("Sélectionner un moyen d'importer votre photo"),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                          onPressed: () => _showCamera(),
                          child: Text("Appareil photo")),
                      CupertinoActionSheetAction(
                        onPressed: () => _showImagePicker(),
                        child: Text("Photothèque"),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Fermer'),
                      isDefaultAction: true,
                      onPressed: () {
                        Navigator.pop(context, 'Fermer');
                      },
                    )),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.count(
                    primary: false,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                    children: _allImages != null
                        ? _allImages
                            .map(
                              (data) => FutureBuilder(
                                future: _getImage(context, data.asset),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done)
                                    return Container(
                                      child: snapshot.data,
                                    );

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Container(
                                        padding: EdgeInsets.all(40),
                                        child: CircularProgressIndicator());

                                  return Container();
                                },
                              ),
                            )
                            .toList()
                        : [],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    FirebaseUtils.uploadFile(context, image, callback: (newAllImages) {
      setState(() {
        _allImages = newAllImages;
      });
    });
    quitDialog(context);
  }

  void _showCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    FirebaseUtils.uploadFile(context, image, callback: (newAllImages) {
      setState(() {
        _allImages = newAllImages;
      });
    });
    quitDialog(context);
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    GestureDetector m;
    await FirebaseUtils.loadImage(context, image).then((downloadUrl) {
      m = GestureDetector(
        onTap: () => topPage(
            context,
            ImagePage(downloadUrl.toString(), image, (newAllImages) {
              setState(() {
                _allImages = newAllImages;
              });
              toast('Image supprimée ! ✅', gravity: ToastGravity.CENTER);
            })),
        child: Hero(
          tag: downloadUrl.toString(),
          child: Material(
            color: Colors.transparent,
            child: Image.network(
              downloadUrl.toString(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    });

    return m;
  }
}
