
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';


class Topic {

  DatabaseReference _ref; 

  Topic() {
    _ref = FirebaseDatabase.instance.reference().child('topics');
  }

  // Add the notification to the topic. Note that photoURL and websiteURL are optional
  void addNotification({  @required String topicName, 
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
    Future<List> getNotifications({String topicName}) async {

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



}