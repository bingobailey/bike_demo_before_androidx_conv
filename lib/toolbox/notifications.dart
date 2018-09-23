import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:bike_demo/toolbox/usertools.dart';
import 'package:bike_demo/toolbox/currentuser.dart';


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

print("inside notification initstate");

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
        This is the SCM token that can be used to send to a specific device. This allows
        peer to peer communication.  each user saves their token in the firebase db. 
        How would this work if the user gets a new phone ?  new token ? 
*/
         _firebaseMessaging.getToken().then((String token){
           print("token = $token");  //SCM token for this device. Can send  to specific user
      
            // This would be the uid of the person logged in
            String uid= "wV9aWBbmHgUySap10e1qgJrLMbv2"; // uid associated with the user
          
            // Update the user, now that we have the token

            // TODO:  The code below should be placed on the startup of the app, not here..
            // It updates the fcm token for the user logged in
            if ( CurrentUser.getInstance().isLoggedIn()) {
              UserTools userTools = new UserTools(); // This would be the user logged in 
              userTools.updateProfile( displayName: CurrentUser.getInstance().user.displayName, photoURL: CurrentUser.getInstance().user.photoUrl);
              userTools.updateFCMToken( fcmToken: token);
            }
      
         });

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

        // TODO:  This needs to be integrated with the topics on FB and whether the
        // user subscribes to those topics  (ie Added_bike etc)
        _firebaseMessaging.subscribeToTopic("topicOne");

    }


  @override
    Widget build(BuildContext context) {
  
      Widget text = new Text(textValue);
      Widget tapText = new GestureDetector( child: text, onTap: createChannel); 

      return new Scaffold( 
        appBar: new AppBar( title: new Text("Firebase Messaging"),),
         body: new Center( child: tapText,)


      ,);
    }



  void sendContactNotification() {

    // simon - Vx2GCPPs7AbnXb8hk8UTzo22UOw1
    // stevie "ZgrSJsAjeVeA8i11QPmGcse0k0h2"; 
    // chuppy  "wV9aWBbmHgUySap10e1qgJrLMbv2"; 

    // The from parms
    String uidFrom= "Vx2GCPPs7AbnXb8hk8UTzo22UOw1"; // simon
    String displayName = "Simon";
    String message = "what color";
    String datetime = DateTime.now().toString();

    // The To parms
    String uidTo = "wV9aWBbmHgUySap10e1qgJrLMbv2"; // chuppy
    
    print("sending notification");
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('notification/$uidTo/$uidFrom').set(
      {
      "msg":message,
      "datetime": datetime,
      "displayName": displayName,
      });

  }


  void updateUserInfo() {
    UserTools userTools = new UserTools();
    userTools.updateProfile( displayName: 'bingoX', photoURL: "howdeeURL");
  }
 
  void createChannel() {

    String simonUID = "Vx2GCPPs7AbnXb8hk8UTzo22UOw1";
    String  stevieUID =  "ZgrSJsAjeVeA8i11QPmGcse0k0h2"; 
    String chuppyUID =   "wV9aWBbmHgUySap10e1qgJrLMbv2"; 



      UserTools userTools = new UserTools();
      userTools.addChannel(  toUID: stevieUID,  toDisplayName: "stevie", title: "would like to talk", msg: "how much?" );
     // user.addChannel( chateeUID: simonUID , chateeDisplayName: "simon", title: "like  your bike", msg: "what size frame?" );
  
  }


  void getChannelList() {
    UserTools userTools = new UserTools();
    userTools.getChannelList().then((List list){
      list.forEach((channel){
        print("channelID: ${channel['channelID']}");
        print("title: ${channel['title']}");
        print("chateeUID:  ${channel['chateeUID']}");
      });

    });

  }

  


} // end of class
