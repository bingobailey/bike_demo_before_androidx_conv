
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bike_demo/toolbox/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


/*
  This class registers listening to topics. 
*/

class Notificaton {
  
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

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
 
      // Get the fcm token from the device and set it (will ultimately insert it into fb)

      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user !=null) {
            _firebaseMessaging.getToken().then((String fcmToken){
            new User().setFCMToken(uid: user.uid, fcmToken: fcmToken);
         });
        }
      });


        // TODO:  Right now we have the topics hardcoded.  Should be based on the user's
        // profile.  The default could be turned on
        _firebaseMessaging.subscribeToTopic("reviewPosted");
        _firebaseMessaging.subscribeToTopic("bikeAdded");
        _firebaseMessaging.subscribeToTopic("advertisement");

    }




  } // end of class
