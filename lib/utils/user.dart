

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:bike_demo/services/webservice.dart';


class User {


  // Update the users fcm-token (firebase cloud messaging), which is associated with
  // each users' device.  This allows peer to peer communication
  void setFCMToken({String uid, String fcmToken}) {
  
    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return; // Need to ensure we have a valid ref before making the call
      ref.update( 
        {
          'fcm-token': fcmToken,
        });
  }


  // GET the FCM Token
  Future<String> getFCMToken({String uid}) async {
    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return null; // Need to ensure we have a valid ref before making the call
    DataSnapshot snapshot = await ref.once();
    return snapshot.value['fcm-token'];
  }


  // SET the displayName in auth and the database
  void setDisplayName({String uid, String displayName}) { 

    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
      if (ref==null) return; // Need to ensure we have a valid ref before making the call
        ref.update( 
          {
            'displayName': displayName,
          });

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

    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return null; // Need to ensure we have a valid ref before making the call
    DataSnapshot snapshot = await ref.once();
    return snapshot.value['displayName'];
  }


  // Set the Units (KM, or Miles)
  void setUnits({String uid, String units}) {
    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return; // Need to ensure we have a valid ref before making the call
      ref.update( 
        {
          'units': units,
        });
  }


  
  // GET the Units
  Future<String> getUnits({String uid}) async {
    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return null; // Need to ensure we have a valid ref before making the call
    DataSnapshot snapshot = await ref.once();
    return snapshot.value['units'];
  }



  // Set the Units (KM, or Miles)
  void setRadius({String uid, String radius}) {
    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return; // Need to ensure we have a valid ref before making the call
      ref.update( 
        {
          'radius': radius,
        });
  }


  
  // GET the Radius
  Future<String> getRadius({String uid}) async {
    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
    if (ref==null) return null; // Need to ensure we have a valid ref before making the call
    DataSnapshot snapshot = await ref.once();
    return snapshot.value['radius'];
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

/*
   NOTE:  Code kept here for example.  Channels no longer kept in FB.  Moved to SQL db

  // This associates a channel with the user and links the chatee. 
  void addChannel({String signedInUID, String toUID, String toDisplayName, String title }) {

    DatabaseReference ref = new FirebaseDatabase().reference().child("users/$signedInUID");
    if (ref==null) return; // Need to ensure we have a valid ref before making the call

    // We add the channel to the user so it will show up when we pull all the channels for this
    // user
      String channelID = signedInUID + "_" + toUID; // creats the channel to communicate on
      // .push inserts an auto key.  This makes it possible to get a list
      ref.child('channels').push().set(
          {
            'channelID': channelID,
            'title': title,
            'toUID': toUID,
            'toDisplayName' : toDisplayName,
            'datetime' :  DateTime.now().toString(),
          });

    }
*/


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


/*
    NOTE:  Keeping this code here for example.  Channels are not longer kept in FB but in 
    SQL Database

    // Get the list of channels associated with this user
    Future<List> getChannelList({String uid}) async {

      DatabaseReference ref = new FirebaseDatabase().reference().child("users/$uid");
      if (ref==null) return null; // Need to ensure we have a valid ref before making the call

      List _list = [];
      DatabaseReference channelRef = ref.child('channels');
      Query query = channelRef.orderByKey();
      DataSnapshot snapshot = await query.once(); // get the data

  
      if(snapshot.value==null) return []; // nothing found return empty list. 

      snapshot.value.forEach( (k,v) {
        _list.add(v);
      });

      return _list;
    }
*/




}