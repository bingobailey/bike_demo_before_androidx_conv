
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:bike_demo/services/firebaseservice.dart';
import 'package:bike_demo/utils/user.dart';

class Topic {

  // Add the notification to the topic. Note that photoURL and websiteURL are optional
  void addNotification({  
              String topic, 
              String displayName, 
              String uid, 
              String content, 
              String photoURL, 
              String websiteURL}) {

      // we create a map object so we can send it to firebase to be added as a node
       Map node =  {
           'photoURL' : photoURL,
           'websiteURL' : websiteURL,
            'displayName': displayName,
            'uid' : uid,
            'content': content,
            'datetime' : DateTime.now().toString(),
        };


      new FirebaseService().addChild(rootDir: 'topics/$topic', childNode: node); 

  }


  // Get the list of notifications associated with the topic
   Future<List> pullNotifications({String topic}) async {

     // The values associated with each topic (ie key), are the notifications
     List topicNotifications = await new FirebaseService().getValues(rootDir: "topics/$topic");
     return topicNotifications;
   }


  // Get a list of all the topics
  Future<List> getTopicList() async {

    // The keys are the topics
    List topicList = await new FirebaseService().getKeys(rootDir: "topics");
    return topicList;
  }




  // Subsribe to listening to the topics
  void listen() {
 
      FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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
 

        // Get a list of all topics the user has subscribed and start listenting 
        new User().getTopicsSubscribed().then((List list) {
        list.forEach((topic) {
            _firebaseMessaging.subscribeToTopic(topic);
          });
        });

    }




 
}