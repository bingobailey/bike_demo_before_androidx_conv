
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

    // simon - Vx2GCPPs7AbnXb8hk8UTzo22UOw1
    // stevie "ZgrSJsAjeVeA8i11QPmGcse0k0h2"; 
    // chuppy  "wV9aWBbmHgUySap10e1qgJrLMbv2"; 


// This class updates all the user info, profile and channels etc. 

class User {

  // Attributes
  String uid;
  DatabaseReference _ref;

  // Constructor
  User({this.uid}) {
   _ref = new FirebaseDatabase().reference().child("users").child(this.uid);
  }
  

// ***  Methods *** 

// Update the user's profile with display name and photoURL
void updateProfile({String displayName, String photoURL}) {
  // we use update so it won't overrite other fields.  if you use set() instead it will
  // wipe out properties that are not being updated in this call. 
  _ref.update( 
    {
      'displayName': displayName,
      'photoURL' : photoURL,
    });
}

// Update the user's photo 
void updatePhoto({String photoURL}){
 _ref.update( 
    {
      'photoURL' : photoURL,
    });
}

// Update the users fcm-token (firebase cloud messaging), which is associated with
// each users' device.  This allows peer to peer communication
void updateFCMToken({String fcmToken}) {
 _ref.update( 
    {
      'fcm-token': fcmToken,
    });
}


// This associates a channel with the user and links the chatee. 
void createChannel({String chateeUID, String title }) {
    String channelID = uid + "_" + chateeUID; // creats the channel to communicate on
    // .push inserts an auto key.  This makes it possible to get a list
    _ref.child('channels').push().set(
        {
          'channelID': channelID,
          'title': title,
          'chateeUID': chateeUID,
          'datetime' :  DateTime.now().toString(),
        });

  }


  // Get the list of channels associated with this user
  Future<List> getChannelList() async {

    List _list = [];
    DatabaseReference _channelRef = _ref.child('channels');
    Query query = _channelRef.orderByKey();
    DataSnapshot snapshot = await query.once(); // get the data

    snapshot.value.forEach( (k,v) {
       _list.add(v);
       print("k = $k");
       print("title = ${v['title']}");
     });

     return _list;
   }
 





} // end of class