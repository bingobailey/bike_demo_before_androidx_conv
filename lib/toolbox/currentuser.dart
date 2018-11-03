import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bike_demo/toolbox/account.dart';

import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


 // This login class contains the attributes of the user logged in so we can access it
 // anywhere in the app.  It is implemented as a singleton. 
 class CurrentUser {

   // Attributes:
  static CurrentUser _instance;

   FirebaseUser _user;  // comes from login
   String tokenID;  // this comes from the login
   List<String> providers;  // from login
   Exception e;
   DatabaseReference _ref;  // reference to  update firebase with user, chat etc

   String _email;
   String _password;  // TODO:  Need to save password to disk or save date to disk then if x
                      // amount of time has passed, force re-login. 
   String _fcmToken;    // this is the device token to send fcm messages
   String _units;     // KM or MI  for radius calc
   String _radius;    // The radius to conduct the location search 
   
  // This method should be called at the start of the app loading. Because it's async
  // it might take a few seconds to load
  void loadDiskSettings() {
    // We load the parms from disk, if they exists 
      SharedPreferences.getInstance().then((prefs) {
        _email = prefs.getString("email"); 
        _password = prefs.getString("password");
      });

  }


  // *** GET and SET Methods ****

  FirebaseUser get user => _user;
  
  String get email => _email;
  String get password => _password;
  String get units => _units;
  String get radius => _radius;
  String get fcmToken => _fcmToken;
 

  // The static method call or Singleton, to ensure we only have one instance of this in the app
  static CurrentUser getInstance() {
    if (_instance==null) {
      _instance = new CurrentUser();
     // _instance.loadDiskSettings();
     
    }
    return _instance;
  }



  // User has been set after being authenticated, we store each
  // parm so we can access and save it to disk, until the next authentication
  set user(FirebaseUser user) {

    _user = user;

    // We also get a reference to the firebase database where we store user parms. 
    _ref = new FirebaseDatabase().reference().child("users/$user.uid");

  // Since we have the fresh data, Save it to disk
  SharedPreferences.getInstance().then((prefs) {  
          prefs.setString('email', user.email); 
      });
  }


  void signInWithEmailAndPassword(){

    new Account().signInWithEmailAndPassword( email: _email, password: _password).then((bool isSuccessful) {

       if(isSuccessful) {
        _instance._ref = new FirebaseDatabase().reference().child("users/$_instance._user.uid"); 
        _instance.loadFirebaseSettings(); 
         print("signin successful");
       } else {
         print("signin UNsucessful");
       }

    });


  }

  Future<void> loadFirebaseSettings() async {

    DataSnapshot snapshot = await _ref.once();
    print("snapshot = ${snapshot.value.toString()}");


  }



  // **** Set METHODS **** 

  // Update the users fcm-token (firebase cloud messaging), which is associated with
  // each users' device.  This allows peer to peer communication
  set fcmToken(String fcmToken) {
    _fcmToken = fcmToken;

     if (_ref==null) return; // Need to ensure we have a valid ref before making the call
      _ref.update( 
        {
          'fcm-token': _fcmToken,
        });
  }




  // Does this user have an fcm token yet ?
  bool hasFCMToken() {
    if(_fcmToken !=null ) return true;
    else return false;
  }




  // Update the user's profile with display name and photoURL
  set displayName(String displayName) {
   
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = displayName;
    FirebaseAuth.instance.updateProfile(userUpdateInfo);

  }




  // Update the user's profile with display name and photoURL
  set email(String email) {
    // we use update so it won't overrite other fields.  if you use set() instead it will
    // wipe out properties that are not being updated in this call. 
    _email = email;

    FirebaseAuth.instance.updateEmail( email: email);

      // since we updated database, save it to disk 
      SharedPreferences.getInstance().then((prefs) {
          prefs.setString('email',_email);
      });
  }


  // Update the user's photo 
  set photoURL(String photoURL){
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.photoUrl = photoURL;
    FirebaseAuth.instance.updateProfile(userUpdateInfo);
  }




  // Update the user's profile with display name and photoURL
  set password(String password) {
    // we use update so it won't overrite other fields.  if you use set() instead it will
    // wipe out properties that are not being updated in this call. 
    _password = password;

      // since we updated database, save it to disk 
      SharedPreferences.getInstance().then((prefs) {
          prefs.setString('password',_password);
      });
  }


// Update the user's profile with display name and photoURL
  set units (String units) {
    // we use update so it won't overrite other fields.  if you use set() instead it will
    // wipe out properties that are not being updated in this call. 
    _units=units;

    if (_ref==null) return; // Need to ensure we have a valid ref before making the call
    _ref.update( 
      {
        'units': _units,
      });
  }




// Update the user's profile with display name and photoURL
  set radius(String radius) {
    // we use update so it won't overrite other fields.  if you use set() instead it will
    // wipe out properties that are not being updated in this call. 
    _radius = radius;

    if (_ref==null) return; // Need to ensure we have a valid ref before making the call
    _ref.update( 
      {
        'radius' : _radius
      });
  }




  // This associates a channel with the user and links the chatee. 
  void addChannel({String toUID, String toDisplayName, String title, String msg }) {

    if (_ref==null) return; // Need to ensure we have a valid ref before making the call

    // We add the channel to the user so it will show up when we pull all the channels for this
    // user
      String channelID = _user.uid + "_" + toUID; // creats the channel to communicate on
      // .push inserts an auto key.  This makes it possible to get a list
      _ref.child('channels').push().set(
          {
            'channelID': channelID,
            'title': title,
            'toUID': toUID,
            'toDisplayName' : toDisplayName,
            'datetime' :  DateTime.now().toString(),
          });

      // We also need to add the channel on the chat table so it will fire a notification to the
      // chatee. 

    // We push the message, which is coming from the person logged in. 
      DatabaseReference chatRef = new FirebaseDatabase().reference().child('chat/$channelID');
      chatRef.push().set(
        {
            'name': CurrentUser.getInstance()._user.uid,
            'content': msg,
            'datetime' : DateTime.now().toString(),
        });

    }


    // Get the list of channels associated with this user
    Future<List> getChannelList() async {

      if (_ref==null) return null; // Need to ensure we have a valid ref before making the call
      List _list = [];
      DatabaseReference _channelRef = _ref.child('channels');
      Query query = _channelRef.orderByKey();
      DataSnapshot snapshot = await query.once(); // get the data

      if(snapshot.value==null) return []; // nothing found return empty list. 

      snapshot.value.forEach( (k,v) {
        _list.add(v);
      });

      return _list;
    }


  void logout() {

      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user !=null) {
          print("user signing out");
          FirebaseAuth.instance.signOut();
        } else {
          print("user not signed in");
        }
      });

  }


}