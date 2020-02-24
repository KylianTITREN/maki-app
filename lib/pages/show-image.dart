import 'package:flutter/material.dart';
import 'package:maki_app/models/Picture.dart';
import 'package:maki_app/utils/Dialogs.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';
import 'package:photo_view/photo_view.dart';

typedef ValueChangedCallback = void Function(
  List<Picture> allImages,
);

class ImagePage extends StatefulWidget {
  ImagePage(this.imageUrl, this.imageAsset, this.onValueChanged);

  final String imageUrl;
  final String imageAsset;
  final ValueChangedCallback onValueChanged;

  static get tag => '/Image';

  @override
  _ImagePageState createState() =>
      _ImagePageState(imageUrl, imageAsset, onValueChanged);
}

class _ImagePageState extends State<ImagePage> {
  _ImagePageState(this._imageUrl, this._imageAsset, this.onValueChanged);

  final String _imageUrl;
  final String _imageAsset;
  final ValueChangedCallback onValueChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: _imageUrl,
          child: Material(
            color: Colors.transparent,
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained,
              backgroundDecoration: BoxDecoration(color: Colors.black38),
              imageProvider: NetworkImage(_imageUrl),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 15,
          right: 22,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black, size: 25),
              onPressed: () => quitPage(context),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          right: 22,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red, size: 25),
              onPressed: () => processToDelete(_imageAsset, _imageUrl),
            ),
          ),
        ),
      ],
    );
  }

  void processToDelete(imgAsset, imgUrl) {
    ChoicesDialog(
      context,
      Text('Grrrr, tu es sûre de vouloir supprimer cette (sublime) photo ?'),
      actions: <String, VoidCallback>{
        'Annuler': () {
          quitDialog(context);
        },
        'Supprimer': () {
          quitDialog(context);
          quitPage(context);
          delay(
              () => FirebaseUtils.deleteImage(context, imgAsset, imgUrl,
                  callback: (newAllImages) => onValueChanged(newAllImages)),
              2000);
        }
      },
    ).show();
  }
}
