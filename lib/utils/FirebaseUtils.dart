import 'dart:async';

import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

typedef void CreateCallback(String uid);
typedef void StateChangedCallback(String state);

class FirebaseUtils {
  static void createFolder(String folderNumber, {CreateCallback callback}) {
    assert(folderNumber != null);

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('test').child('mobile_folders').push();

    reference.set({
      'folder_number': folderNumber,
      'id_enseigne': 9,
      'state': 'CREATED',
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }).then((success) {
      if (callback != null) {
        callback(reference.key);
      }
    }).catchError((error) {
      Page.toast(Strings.textErrorOccurred);
    });
  }

  static void setFolderState(String uid, String state, {CreateCallback callback}) {
    assert(uid != null && state != null);

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('test').child('mobile_folders').child(uid);

    reference.update({'state': state}).then((success) {
      if (callback != null) {
        callback(reference.key);
      }
    }).catchError((error) {
      Page.toast(Strings.textErrorOccurred);
    });
  }

  static void deleteFolder(String uid, {VoidCallback callback}) {
    assert(uid != null);

    FirebaseDatabase.instance
        .reference()
        .child('test')
        .child('mobile_folders')
        .child(uid)
        .remove()
        .then((T) {
      if (callback != null) {
        callback();
      }
    });
  }

  static StreamSubscription<Event> listenState(String uid, List<String> states,
      {@required StateChangedCallback callback}) {
    return FirebaseDatabase.instance
        .reference()
        .child('test')
        .child('mobile_folders')
        .child(uid)
        .child('state')
        .onValue
        .listen((Event event) {
      String state = event.snapshot.value;
      if (states.contains(state)) {
        callback(state);
      }
    }, cancelOnError: false);
  }
}
