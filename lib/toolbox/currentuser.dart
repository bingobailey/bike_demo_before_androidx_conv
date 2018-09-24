import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

   String _uid;
   String _displayName;
   String _email;
   String _photoURL;
   String _password;  // TODO:  Need to save password to disk or save date to disk then if x
                      // amount of time has passed, force re-login. 
   String _fcmToken;    // this is the device token to send fcm messages

  // Constructor
  CurrentUser() {
      // We load the parms from disk, if they exists
      SharedPreferences.getInstance().then((prefs) {
        _uid = prefs.getString("uid"); 
        print("uid = ${prefs.getString("uid")}");
        _displayName = prefs.getString("displayName"); 
        _email = prefs.getString("email"); 
        _photoURL = prefs.getString("photoURL"); 
        _fcmToken = prefs.getString("fcmToken");
        // If we have a UID, let's assign the reference
        if(_uid !=null) {
           _ref = new FirebaseDatabase().reference().child("users/$_uid"); 
        }

      });

  }


  // *** GET and SET Methods ****

  String get uid => _uid;
  String get displayName => _displayName;
  String get email => _email;
  String get photoURL => _photoURL;
  FirebaseUser get user => _user;

  // User has been set after being authenticated, we store each
  // parm so we can access and save it to disk, until the next authentication
  set user(FirebaseUser user) {
    _user = user; 
    _uid = user.uid;
    _displayName = user.displayName;
    _email= user.email;
    _photoURL = user.photoUrl;
    // We also get a reference to the firebase database where we store user parms. 
    _ref = new FirebaseDatabase().reference().child("users/$_uid");

  // Since we have the fresh data, Save it to disk
  SharedPreferences.getInstance().then((prefs) {
          prefs.setString('uid', _uid);
          prefs.setString('displayName', _displayName);
          prefs.setString('email', _email);
          prefs.setString('photoURL', _photoURL);

      });
  }

  // This is the token from the device that allows us to send firebase cloud messages (fcm)
  set fcmToken(String token){
    _fcmToken = token;
      SharedPreferences.getInstance().then((prefs) {
          prefs.setString('fcmToken', _fcmToken);  // store it to disk
      });

      // If we have the _UID, go ahead and update the user and the token
      if (_uid !=null) {
          updateProfile( displayName: _displayName, photoURL: _photoURL);
          updateFCMToken( fcmToken: token);
      }

  }


  // The static method call or Singleton, to ensure we only have one instance of this in the app
  static CurrentUser getInstance() {
    if (_instance==null) {
      _instance = new CurrentUser();
    }
    return _instance;
  }



  // **** METHODS **** 

  // Does this user have an fcm token yet ?
  bool hasFCMToken() {
    if(_fcmToken !=null ) return true;
    else return false;
  }

  // Update the user's profile with display name and photoURL
  void updateProfile({String displayName, String photoURL, String email}) {
    // we use update so it won't overrite other fields.  if you use set() instead it will
    // wipe out properties that are not being updated in this call. 

    if (_ref==null) return; // Need to ensure we have a valid ref before making the call
    _ref.update( 
      {
        'displayName': displayName,
        'email' : email,
        'photoURL' : photoURL,
      });
  }

// TODO:  updateProfile and updatePhoto should also write the contents to disk via sharedprefs

  // Update the user's photo 
  void updatePhoto({String photoURL}){
    if (_ref==null) return; // Need to ensure we have a valid ref before making the call
    _ref.update( 
        {
          'photoURL' : photoURL,
        });
  }


  // Update the users fcm-token (firebase cloud messaging), which is associated with
  // each users' device.  This allows peer to peer communication
  void updateFCMToken({String fcmToken}) {

     if (_ref==null) return; // Need to ensure we have a valid ref before making the call
    _ref.update( 
        {
          'fcm-token': fcmToken,
        });
  }



  // This associates a channel with the user and links the chatee. 
  void addChannel({String toUID, String toDisplayName, String title, String msg }) {

    if (_ref==null) return; // Need to ensure we have a valid ref before making the call

    // We add the channel to the user so it will show up when we pull all the channels for this
    // user
      String channelID = _uid + "_" + toUID; // creats the channel to communicate on
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
            'name': CurrentUser.getInstance()._displayName,
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

      snapshot.value.forEach( (k,v) {
        _list.add(v);
        print("k = $k");
        print("title = ${v['title']}");
      });

      return _list;
    }



    // Does the user have a valid UID, if so we should be good, otherwise,
    // they need to login or create an account
    bool isAuthenticated() {
      if (_uid != null) return true;
      else return false;
    }

  String toString() {
    return("displayName=$_displayName, uid=$_uid, email=$_email, photoURL=$_photoURL, fcmToken=$_fcmToken, tokenID=$tokenID, providers=${providers.toString()}, e=${e.toString()}");

  }

  // TODO: need to use a function to remove login info from disk when user signs out.
  // can't use clear() if you are going to save other parms such as radius, search settings etc.


}