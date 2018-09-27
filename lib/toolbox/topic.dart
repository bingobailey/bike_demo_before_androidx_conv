

import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class Topic {

  DatabaseReference _ref; 


  Topic() {
    _ref = FirebaseDatabase.instance.reference().child('topics');

  }


  void addActionTopicEntry({String topicName, String displayName, String uid, String description}) {
      DatabaseReference chatRef = _ref.child("actions/$topicName");
      chatRef.push().set(
        {
            'displayName': displayName,
            'uid' : uid,
            'description': description,
            'datetime' : DateTime.now().toString(),
        });
  }



    // Get the list of channels associated with this user
    Future<List> getActionTopicEntries({String topicName}) async {

      if (_ref==null) return null; // Need to ensure we have a valid ref before making the call
      List _list = [];
      DatabaseReference _channelRef = _ref.child('actions/$topicName');
      Query query = _channelRef.orderByKey();
      DataSnapshot snapshot = await query.once(); // get the data

      snapshot.value.forEach( (k,v) {
        _list.add(v);
        // print("k = $k");
        // print("topic = $topicName");
        // print("description = ${v['description']}");
        // print("displayname = ${v['displayName']}");
      });

      return _list;
    }






  void createAdTopic() {

   DatabaseReference chatRef = _ref.child('advertisement');
      chatRef.push().set(
        {
            'companyName': 'Yeti Bikes',
            'websiteURL' : 'https://www.yeticycles.com',
            'content': 'come check out our new models',
            'datetime' : DateTime.now().toString(),
        });

  }


}