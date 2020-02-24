import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:maki_app/FlavorConfig.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/models/Dico.dart';
import 'package:maki_app/models/Message.dart';
import 'package:maki_app/models/Picture.dart';
import 'package:maki_app/models/Recette.dart';
import 'package:maki_app/models/Video.dart';
import 'package:maki_app/utils/Page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as Path;

typedef void CreateCallback(String uid);
typedef void ImageCallback(List<Picture> allImages);
typedef void RecetteCallback(List<Recette> allRecettes);
typedef void StateChangedCallback(String state);
typedef void BadgeChangedCallback(int number);

class FirebaseUtils {
  static String parentFolder = FlavorConfig.isProduction() ? 'prod' : 'dev';

  //ALL CREATE

  static void createRecette(String icon, String name, String preparation,
      {String ingredients,
      String time,
      String hot,
      CreateCallback callback,
      VoidCallback errorCallback}) {
    if (name != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('recettes')
          .push();

      Map<String, String> timestamp = ServerValue.timestamp;

      Registry.allRecettes.insert(
          0,
          Recette(
              createdAt: timestamp.toString(),
              name: name,
              icon: icon,
              preparation: preparation,
              ingredients: ingredients,
              time: time,
              hot: hot));

      reference.set({
        'icon': icon,
        'name': name,
        'preparation': preparation,
        'ingredients': ingredients,
        'time': time,
        'hot': hot,
        'created_at': timestamp,
      }).then((success) {
        if (callback != null) {
          print(reference.key);
          callback(reference.key);
        }
      }).catchError((error) {
        errorCallback();
        toast(
            'Une erreur est survenue, veuillez contacter le développeur ou rédemarrer l\'app');
      });
    }
  }

  static void updateMessage({CreateCallback callback}) {
    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('message');

    reference.update({
      'read': "true",
    }).then((success) {
      if (callback != null) {
        callback(reference.key);
      }
    }).catchError((error) {
      print(error);
    });
  }

  static void createDico(String from, String word,
      {CreateCallback callback, VoidCallback errorCallback}) {
    if (from != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('dico')
          .child(from)
          .child('words')
          .push();

      //ADD TO ARRAY
      if (Registry.allDico.where((dico) => dico.from == from).isNotEmpty) {
        Registry.allDico
            .where((dico) => dico.from == from)
            .first
            .words
            .insert(0, word);
      } else {
        Registry.allDico.add(Dico(from: from, words: [word]));
      }

      reference.set({
        'word': word,
        'created_at': ServerValue.timestamp,
      }).then((success) {
        if (callback != null) {
          print(reference.key);
          callback(reference.key);
        }
      }).catchError((error) {
        errorCallback();
        toast(
            'Une erreur est survenue, veuillez contacter le développeur ou rédemarrer l\'app');
      });
    }
  }

  static Future uploadFile(BuildContext context, File image,
      {ImageCallback callback}) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(image.path)}');

    StorageUploadTask uploadTask = storageReference.putFile(image);

    List<Picture> addedImage;

    setImagesLink('images/${Path.basename(image.path)}', callback: (newImage) {
      addedImage = newImage;
    });

    await uploadTask.onComplete.then((value) {
      callback(addedImage);
    });

    storageReference.getDownloadURL().then((fileURL) {
      loadImage(context, 'images/${Path.basename(image.path)}');
    });
  }

  static void setImagesLink(String imageAsset,
      {ImageCallback callback, VoidCallback errorCallback}) {
    if (imageAsset != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('images')
          .push();

      Map<String, String> timestamp = ServerValue.timestamp;

      //ADD TO ARRAY
      Registry.allImages
          .insert(0, Picture(asset: imageAsset, addedAt: timestamp.toString()));

      callback(Registry.allImages);

      reference.set({
        'asset': imageAsset,
        'added_at': timestamp,
      });
    }
  }

  //ALL GET

  static List<Video> getVideos(
      {CreateCallback callback, VoidCallback errorCallback}) {
    FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('videos')
        .once()
        .then((DataSnapshot snapshot) {
      List<Video> allVideos = List<Video>();
      for (var values in snapshot.value) {
        allVideos.add(Video.fromAJson(values));
      }
      Registry.allVideos = allVideos;
    });
    return Registry.allVideos;
  }

  static Message getMessage(BuildContext context,
      {CreateCallback callback, VoidCallback onSuccess}) {
    FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('message')
        .once()
        .then((DataSnapshot snapshot) {
      Registry.message = Message(
        title: snapshot.value['title'] != null ? snapshot.value['url'] : '',
        content:
            snapshot.value['content'] != null ? snapshot.value['content'] : '',
        read: snapshot.value['read'] != null ? snapshot.value['read'] : '',
        url: snapshot.value['url'] != null ? snapshot.value['url'] : '',
      );
      if (Registry.message.read == 'false') {
        onSuccess();
      }
    });
    return Registry.message;
  }

  static List<Recette> getRecettes(
      {CreateCallback callback, VoidCallback errorCallback}) {
    FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('recettes')
        .once()
        .then((DataSnapshot snapshot) {
      List<Recette> allRecettes = List<Recette>();
      Map<dynamic, dynamic> values = snapshot.value;
      values != null
          ? values.forEach((uid, data) {
              allRecettes.add(Recette(
                  uid: uid,
                  icon: data['icon'],
                  name: data['name'],
                  ingredients: data['ingredients'],
                  preparation: data['preparation'],
                  time: data['time'],
                  hot: data['hot'],
                  createdAt: data['created_at'].toString()));
            })
          : allRecettes = [];
      allRecettes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      Registry.allRecettes = allRecettes;
    });
    return Registry.allRecettes;
  }

  static List<String> getNames(
      {CreateCallback callback, VoidCallback errorCallback}) {
    FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('names')
        .once()
        .then((DataSnapshot snapshot) {
      List<String> allNames = List<String>();
      for (var values in snapshot.value) {
        allNames.add(values);
      }
      Registry.allNames = allNames;
    });
    return Registry.allNames;
  }

  static List<Dico> getDico(
      {CreateCallback callback, VoidCallback errorCallback}) {
    FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('dico')
        .once()
        .then((DataSnapshot snapshot) {
      List<Dico> allDicos = List<Dico>();
      Map<dynamic, dynamic> values = snapshot.value;
      values != null
          ? values.forEach((from, words) {
              List<String> allWords = List<String>();
              words.forEach((k, word) {
                word.forEach((k, word) {
                  allWords.add(word['word']);
                });
              });
              allWords.sort((a, b) => a.compareTo(b));
              allDicos.add(Dico(from: from, words: allWords));
            })
          : allDicos = [];
      allDicos.sort((a, b) => a.from.compareTo(b.from));
      Registry.allDico = allDicos;
    });
    return Registry.allDico;
  }

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }

  static List<Picture> getImagesLink(
      {CreateCallback callback, VoidCallback errorCallback}) {
    FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('images')
        .once()
        .then((DataSnapshot snapshot) {
      List<Picture> allImages = List<Picture>();
      Map<dynamic, dynamic> values = snapshot.value;
      values != null
          ? values.forEach((key, value) {
              allImages.add(Picture(
                  addedAt: value['added_at'].toString(),
                  asset: value['asset']));
            })
          : allImages = [];
      allImages.sort((a, b) => b.addedAt.compareTo(a.addedAt));
      Registry.allImages = allImages;
    });
    return Registry.allImages;
  }

  //ALL DELETE

  static Future<dynamic> deleteImage(
      BuildContext context, String imageAsset, String imageUrl,
      {ImageCallback callback}) async {
    if (imageAsset != null && imageUrl != null) {
      StorageReference photoRef =
          FirebaseStorage.instance.ref().child(imageAsset);
      photoRef.delete();

      String snapShotKeyToDel;

      Registry.allImages.removeWhere((image) => image.asset == imageAsset);

      FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('images')
          .orderByChild("asset")
          .equalTo(imageAsset)
          .once()
          .then((DataSnapshot snapshot) {
        Map map = snapshot.value;
        snapShotKeyToDel = map.keys.toList()[0].toString();
        FirebaseDatabase.instance
            .reference()
            .child(parentFolder)
            .child("images")
            .child(snapShotKeyToDel)
            .remove()
            .then((value) {
          callback(Registry.allImages);
        });
      });
    }
  }

  static void deleteRecette(String uid, {RecetteCallback callback}) {
    if (uid != null) {
      FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('recettes')
          .child(uid)
          .remove()
          .then((T) {
        Registry.allRecettes.removeWhere((recette) => recette.uid == uid);
        if (callback != null) {
          callback(Registry.allRecettes);
        }
      });
    }
  }
}
