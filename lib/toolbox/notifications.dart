import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';



/*
Observations up to this point; 

See this doc to make sure you have the latest version and following the instructions on how-to
https://pub.dartlang.org/packages/firebase_messaging#-readme-tab-



-  To send messages from the console ; 
  https://console.firebase.google.com/project/pushnotifications-52982/notification

- The SCM token appears to change each time the app is run.  It's good
  for testing purposes, since you can send the msg immediate. 

- You can subsribe to a topic (most likely the preferred way in a real app), the topic
  will be created in Firebase, wen the app is run.  Topic names cannot contain special chars
  such as @ and .    

- When the App is running in foreground and you send a notification through the console
  via a topic, the onMessage: handler is called, but the message that is delivered 
  appears to be null.  It's also null when sending via token. 

- When the App is in the background and you send a notification through the console via
  topic, a bell will sound and if you pull down the notification bar, the notification 
  is deliverd with associated text etc.  If you click on the notfication it will bring up 
  app but none of the handlers are called, onMessage, onResume or onLaunch. 

- When the app is terminated and you send a message through the console via a topic, the 
  the console will indicate that the message was sent successfully.  When you run the app, 
  the app loads, but no handlers are called (ie onMessage etc) and nothing to indicate a
  notification has been delivered. 

 - SENDING Notification via APP; 

This is based on the following instructions;
https://firebase.google.com/docs/cloud-messaging/android/topic-messaging 

NOTE: "myproject-b5ae1" would be replaced with your project name on firebase console. 
      Not sure about Authorization..


POST https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send HTTP/1.1

Content-Type: application/json
Authorization: Bearer ya29.ElqKBGN2Ri_Uz...HnS_uNreA
{
  "message":{
    "topic" : "foo-bar",
    "notification" : {
      "body" : "This is a Firebase Cloud Messaging Topic Message!",
      "title" : "FCM Message"
      }
   }
}

If you want to send to people that have subscribed to dogs or cats then 
use the following; 

"message":{
    "condition": "'dogs' in topics || 'cats' in topics",
    "notification" : {
      "body" : "This is a Firebase Cloud Messaging Topic Message!",
      "title" : "FCM Message",
    }

This code below is according to the link below; 
https://pub.dartlang.org/packages/firebase_messaging#-readme-tab-

DATA='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "<FCM TOKEN>"}'
curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=<FCM SERVER KEY>"
Remove the notification property in DATA to send a data message.

*/




class NotificatonTest extends StatefulWidget {
  @override
  _NotificatonTestState createState() => new _NotificatonTestState();
}

class _NotificatonTestState extends State<NotificatonTest> {
  
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  String textValue = "hello world";



  @override
    void initState() {
      super.initState();

      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) {

            print("onMessage: ${message.toString()}");
          },
          onResume: (Map<String, dynamic> message) {
              print("onResume: ${message.toString()}");
          },
          onLaunch: (Map<String, dynamic> message) {
              print("onLaunch: ${message.toString()}");
          },
        );

        _firebaseMessaging.requestNotificationPermissions(
            const IosNotificationSettings(sound: true, badge: true, alert: true));

        _firebaseMessaging.onIosSettingsRegistered
                .listen((IosNotificationSettings settings) {
              print("Settings registered: $settings");
            });

/*
        This is the SCM token that can be used to send to a specific device. Note that
        the SCM token appears to change each time the program is run, making it 
        ineffective to use in a real application.  It's better used for testing 
        since it's immediate. 
*/
        // _firebaseMessaging.getToken().then((String token){
        //   print("token = $token");  //SCM token for this device. Can send  to specific user
        // });

/*
        When the app is run, it creates the topic in Firebase.  Then you can 
        send messages to the topic.  Note that topics cannot contain "." or "@" or
        other special characters. The email address psimoj@gmail.com, where the "@" was
        replaced with _at_ and the "."  was replaced with _dot_    
        Using the email address as the topic will allow one user to send a 
        notification to another user. You could also take the topic and easily 
        convert it back to the real email address. 
        NOTE:  You can also create a system wide topic, if you want to send a push 
        notification to all users using the app. 
*/
        _firebaseMessaging.subscribeToTopic("topicOne");

    }


  @override
    Widget build(BuildContext context) {
  
      Widget text = new Text(textValue);
      Widget tapText = new GestureDetector( child: text, onTap: sendMessage,);

      return new Scaffold( 
        appBar: new AppBar( title: new Text("Firebase Messaging"),),
         body: new Center( child: tapText,)


      ,);
    }


void sendMessage() {

String fcmServerKey = "AAAALtyq7bI:APA91bEedIvGaZavpfUoot_26Hn9UzPSPgfyIIrV0E3zUe4QxLt0r9YnJi0HWuQZsF8w1RQ1n2nJwX6haoCM4-_VOe5u94U9bOlxZ7LnVSp2q8Yk1Qds35HHghBOOrGHasZHIqJ_XNxH";
/*
DATA='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "<FCM TOKEN>"}'
curl https://fcm.googleapis.com/fcm/send -H "Content-Type:application/json" -X POST -d "$DATA" -H "Authorization: key=<FCM SERVER KEY>"
*/

  // Lets set the headers
    var headers = {
       HttpHeaders.contentTypeHeader: 'application/json',
       HttpHeaders.authorizationHeader : 'key=$fcmServerKey',
      };

  String  payload ='{"notification": {"body": "this is a body","title": "this is a title"}, "priority": "high", "data": {"name": "bingobailey", click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"}, "to": "$fcmServerKey"}';
  String url = "https://fcm.googleapis.com/fcm/send";

    http.post(
       url, 
       headers: headers,
        body: jsonEncode(payload),
    ).then((http.Response response) {
       print(response.body);

    }).catchError((e) {
       print(e);

    });


}








} // end of class
