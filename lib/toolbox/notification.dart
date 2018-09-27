
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:bike_demo/toolbox/currentuser.dart';


class Notificaton {
  
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
 


  void listen() {
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
 
      // Get the fcm token from the device and set it (will ultimately insert it into fb)
      if ( CurrentUser.getInstance().isAuthenticated()) {
         _firebaseMessaging.getToken().then((String fcmToken){
              CurrentUser.getInstance().fcmToken = fcmToken;
         });
      }

        // TODO:  This needs to be integrated with the topics on FB and whether the
        // user subscribes to those topics  (ie Added_bike etc)

        print("subscribing to topics..");
        _firebaseMessaging.subscribeToTopic("Review_posted");
        _firebaseMessaging.subscribeToTopic("Bike_added");

    }





  } // end of class
