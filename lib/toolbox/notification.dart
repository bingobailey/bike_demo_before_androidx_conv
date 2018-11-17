
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';




/*
  This class registers listening to topics. 
*/

class Notificaton {
  
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  DatabaseReference _ref; 
  String rootNode = 'topics';

  Notificaton() {
    _ref = FirebaseDatabase.instance.reference().child(rootNode);
  }



  // Add the notification to the topic. Note that photoURL and websiteURL are optional
  void add({  @required String topicName, 
                          @required String displayName, 
                          @required String uid, 
                          @required String content, 
                          String photoURL, String websiteURL}) {
      DatabaseReference topicRef = _ref.child(topicName);
      topicRef.push().set(
        {
           'photoURL' : photoURL,
           'websiteURL' : websiteURL,
            'displayName': displayName,
            'uid' : uid,
            'content': content,
            'datetime' : DateTime.now().toString(),
        });
  }




    // Get the list of notifications associated with the topic
    Future<List> pull({String topicName}) async {

      if (_ref==null) return null; // Need to ensure we have a valid ref before making the call
      List _list = [];
      DatabaseReference _channelRef = _ref.child(topicName);
      Query query = _channelRef.orderByKey();
      DataSnapshot snapshot = await query.once(); // get the data

      if (snapshot.value==null) return []; // return an empty list.  Nothing found

      snapshot.value.forEach( (k,v) {
        _list.add(v);
        // print("k = $k");
        // print("topic = $topicName");
        // print("content = ${v['content']}");
        // print("displayname = ${v['displayName']}");
      });

      return _list;
    }



  // we call this method when we want to register for listening to fcm
  void listen() {
 
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) {  // executes when the app is running
            // print("onMessage: ${message.toString()}");

            // // Pulling info out of the message
            // print("onMessage title = ${message['notification']['title']}");
            // print("onMessage body = ${message['notification']['body']}");
            // print("onMessage source = ${message['data']['source']}");

          },
          onResume: (Map<String, dynamic> message) {  // executes when app is in background
              print("onResume: ${message.toString()}");
          },
          onLaunch: (Map<String, dynamic> message) {  // executes when app is not loaded
              print("onLaunch: ${message.toString()}");
          },
        );

        _firebaseMessaging.requestNotificationPermissions(
            const IosNotificationSettings(sound: true, badge: true, alert: true));

        _firebaseMessaging.onIosSettingsRegistered
                .listen((IosNotificationSettings settings) {
              print("Settings registered: $settings");
            });
 
        // TODO:  Right now we have the topics hardcoded.  Should be based on the user's
        // profile.  The default could be turned on
        _firebaseMessaging.subscribeToTopic("reviewPosted");
        _firebaseMessaging.subscribeToTopic("bikeAdded");
        _firebaseMessaging.subscribeToTopic("advertisement");

    }



} // end of class
