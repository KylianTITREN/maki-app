import 'dart:async';

import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

typedef void CreateCallback(String uid);
typedef void StateChangedCallback(String state);
typedef void BadgeChangedCallback(int number);

class FirebaseUtils {
  static String parentFolder = FlavorConfig.isProduction() ? 'prod' : 'test';

  static void createFolder(String folderNumber, int shopId,
      {CreateCallback callback, VoidCallback errorCallback}) {
    if (folderNumber != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('mobile_folders')
          .push();

      reference.set({
        'folder_number': folderNumber,
        'id_enseigne': 9,
        'shop_id': shopId,
        'state': 'CREATED',
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }).then((success) {
        if (callback != null) {
          callback(reference.key);
        }
      }).catchError((error) {
        errorCallback();
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void createChat(String folderId, String folderNumber, int shopId, String shopName,
      {CreateCallback callback, VoidCallback errorCallback}) {
    if (folderId != null && Registry.activeMessage == true) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('chats')
          .push();

      reference.set({
        'mobile_folder_id': folderId,
        'mobile_folder_number':folderNumber,
        'shop_id': shopId,
        'shop_name':shopName,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }).then((success) {
        if (callback != null) {
          callback(reference.key);
        }
      }).catchError((error) {
        errorCallback();
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void setChatFolderId(String uid, String folderNumber, String folderId,
      {CreateCallback callback}) {
    if (uid != null && uid.isNotEmpty && folderNumber != null && folderNumber.isNotEmpty && folderId.isNotEmpty && folderId != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('chats')
          .child(uid);

      reference.update({'mobile_folder_id': folderId, 'mobile_folder_number': folderNumber}).then((success) {
        if (callback != null) {
          callback(reference.key);
        }
      }).catchError((error) {
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void updateShopId(String uid, int shopId, String shopName, {CreateCallback callback}) {
    if (uid != null && uid.isNotEmpty && shopId != null && shopName != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('chats')
          .child(uid);

      reference.update({'shop_id': shopId, 'shop_name': shopName}).then((success) {
        if (callback != null) {
          callback(reference.key);
        }
      }).catchError((error) {
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void setChatMessage(String uid, String text,
      {CreateCallback callback}) {
    if (uid != null && uid.isNotEmpty && text != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('chats')
          .child(uid)
          .child('messages')
          .push();

      reference.set({
        'message': text,
        'from': "APP",
        'created_at': DateTime.now().millisecondsSinceEpoch,
      }).then((success) {
        if (callback != null) {
          callback(reference.key);
        }
      }).catchError((error) {
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static StreamSubscription<Event> listenUnreadChat(String uid,
      {@required BadgeChangedCallback callback}) {
    return FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
        .child('chats')
        .child(uid)
        .onChildChanged
        .listen((Event event) {
      if (event.snapshot.value['messages'] != null && event.snapshot.value['messages'].isNotEmpty) {
        int index = 0;
        Map<dynamic, dynamic> values = event.snapshot.value['messages'];
        values.forEach((key, msg) {
          DateTime msgTime =
              DateTime.fromMillisecondsSinceEpoch(msg['created_at']);
          if (msgTime.isAfter(Registry.lastMsg)) {
            if (msg['from'] == 'BO') {
              index++;
            } else {
              index = 0;
              Registry.lastMsg = msgTime;
            }
          }
          callback(index);
        });
      }
    }, cancelOnError: false);
  }

  static void setFolderState(String uid, String state,
      {CreateCallback callback}) {
    if (uid != null && uid.isNotEmpty && state != null) {
      DatabaseReference reference = FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('mobile_folders')
          .child(uid);

      reference.update({'state': state}).then((success) {
        if (callback != null) {
          callback(reference.key);
        }
      }).catchError((error) {
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void getFolderComment(String uid, {Function callback(String value)}) {
    if (uid != null) {
      FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('mobile_folders')
          .child(uid)
          .child('comment')
          .once()
          .then((DataSnapshot snapshot) {
        if (callback != null) {
          callback(snapshot.value);
        }
      }).catchError((error) {
        print('Error: $error');
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void getAdvisorText(String uid, {Function callback(String value)}) {
    if (uid != null) {
      FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('mobile_folders')
          .child(uid)
          .child('adviser_text')
          .once()
          .then((DataSnapshot snapshot) {
        if (callback != null) {
          callback(snapshot.value);
        }
      }).catchError((error) {
        print('Error: $error');
        toast(Strings.textErrorOccurred);
      });
    }
  }

  static void deleteFolder(String uid, {VoidCallback callback}) {
    if (uid != null) {
      FirebaseDatabase.instance
          .reference()
          .child(parentFolder)
          .child('mobile_folders')
          .child(uid)
          .remove()
          .then((T) {
        if (callback != null) {
          callback();
        }
      });
    }
  }

  static StreamSubscription<Event> listenState(String uid, List<String> states,
      {@required StateChangedCallback callback}) {
    return FirebaseDatabase.instance
        .reference()
        .child(parentFolder)
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
