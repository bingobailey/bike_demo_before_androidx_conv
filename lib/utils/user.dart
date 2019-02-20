

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bike_demo/services/webservice.dart';
import 'package:bike_demo/services/firebaseservice.dart';
import 'package:bike_demo/utils/topic.dart';
import 'package:bike_demo/services/imageservice.dart';



class User {


  Widget getAvatar({String uid, String imageName, String displayName}) {

    String imageURL =ImageService().getImageURL(uid: uid, imageName: imageName);
    return  new Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                imageURL)
                        )
                    )),
                new Text(displayName,
                    textScaleFactor: 1.5)
              ],
            )
            
            );


  }



  // Retireive the current user logged in.  If user is not logged in, fbuser will be null
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser fbuser = await FirebaseAuth.instance.currentUser();
    return fbuser;
  }


  // Update the users fcm-token (firebase cloud messaging), which is associated with
  // each users' device.  This allows peer to peer communication
  void setFCMToken({String uid, String fcmToken}) {
    new FirebaseService().setProperty(rootDir:'users/$uid', propertyName:'fcm-token', propertyValue: fcmToken );
  }



  // GET the FCM Token
  Future<String> getFCMToken({String uid}) async {
    String fcmToken = await new FirebaseService().getProperty(rootDir: 'users/$uid', propertyName: 'fcm-token');
    return fcmToken;
  }


  // SET the displayName in auth and the database
  void setDisplayName({String uid, String displayName}) { 

      new FirebaseService().setProperty(rootDir: 'users/$uid',propertyName: 'displayName', propertyValue: displayName);

      // Also must update the authentication database
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user != null) {
          // Also must update the authentication database
          var userUpdateInfo = new UserUpdateInfo();
          userUpdateInfo.displayName = displayName;
          user.updateProfile(userUpdateInfo);
        }
      });
  }


  // GEt the Display Name
  Future<String> getDisplayName({String uid}) async {
    String displayName = await new FirebaseService().getProperty(rootDir: 'users/$uid', propertyName: 'displayName');
    return displayName;
  }


  // Set the radius
  Future<void> setRadius({String uid, double radius}) async {
     new FirebaseService().setProperty(rootDir: 'users/$uid',propertyName: 'radius', propertyValue: radius);
  }

  // Get radius
  Future<double> getRadius({String uid}) async {
    double radius = await new FirebaseService().getProperty(rootDir: 'users/$uid', propertyName: 'radius');
    return radius;
  }

  // Set the units (ie 'km'  or 'm')
  Future<void> setUnits({String uid, String units}) async {
     new FirebaseService().setProperty(rootDir: 'users/$uid',propertyName: 'units', propertyValue: units);
  }

  // GEt units
  Future<String> getUnits({String uid}) async {
    String units = await new FirebaseService().getProperty(rootDir: 'users/$uid', propertyName: 'units');
    return units;
  }



  // Return a list of the topics the user is not subscribed to 
  Future<List> getTopicsNotSubscribed({String uid}) async {

    List list = await new FirebaseService().getKeys(rootDir: 'users/$uid/topicsNotSubscribed');
    return list;
  }



  // Return a list of the topics the user is not subscribed to 
  Future<List> getTopicsSubscribed({String uid}) async {

    List topics = await new Topic().getTopicList();
    List notSubscribedTopics = await this.getTopicsNotSubscribed(uid: uid);

    if (notSubscribedTopics != null) {
        notSubscribedTopics.forEach((item){
          topics.remove(item);
        });
    }

    return topics;
  }


  // Add the topic the user is not subscribed to 
  void unsubscribeFromTopic({String uid, String topic}) {

    new FirebaseService().setProperty(
                                        rootDir: 'users/$uid/topicsNotSubscribed', 
                                    propertyName: topic, 
                                    propertyValue: true);
  }



  // We actually remove the topic from the user if they subscribe to it, so we can just use
  // the default topics as subscribed.  Any topics listed under the user are not subscribed to
  void subscribeToTopic({String uid, String topic}) {

    new FirebaseService().setProperty(
                                        rootDir: 'users/$uid/topicsNotSubscribed', 
                                    propertyName: topic, 
                                    propertyValue: null);
  }



  // Add the channel for chat associated with the user

  Future<Map<String,dynamic>> addChannel( {String signedInUID, String toUID, String bikeID}) async {

   String channelID = signedInUID + '_' + toUID + '_' + bikeID.toString();
    bool status=false;
    String msg;

      // Make the call to the SQL DB and store the user
      var payload = {
        'uid_from':signedInUID,
        'uid_to':toUID, 
        'bike_id': bikeID, 
        'channel_id':channelID
         };
      // NOTE: We place the await in front of the webservice because it is an async function located within
      // another async function. 
      await new WebService().run(service: 'XinsertChannel.php', jsonPayload: payload).then((sqldata){
        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {
         // we should be good here
           status=true;
        
        } else {// Something went wrong with the http call
          status=false;
          msg = sqldata.toString();
          print("Http Error: ${sqldata.toString()}");
        }
      }).catchError((e) {
          status=false;
          msg = e.toString();
          print(" WebService error: $e");
      });


    // Package up the result and return it 
    Map result = Map<String,dynamic>();
    result['status'] = status;
    result['msg'] =msg;
    result['channel_id'] = channelID;

    return result;
       
 }


    // Get the list of channels associated with this user
    Future<List> getChannelList({String uid}) async {

      List list=[];
      var payload = {'uid':uid};
      SQLData sqlData = await new WebService().run(service: 'XselectChannels.php', jsonPayload: payload);
       if (sqlData.httpResponseCode == 200) {
            list = sqlData.rows;
            for (var row in sqlData.rows) {
              print(row.toString());
            }
          // Something went wrong with the http call
        } else {
            print("Http Error: ${sqlData.toString()}");
        }

      return list;
    
    }



}

