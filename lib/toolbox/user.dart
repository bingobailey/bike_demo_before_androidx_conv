
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

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
          FirebaseAuth.instance.updateProfile(userUpdateInfo);
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



  // *** Chat  Methods ***

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



} // end of class