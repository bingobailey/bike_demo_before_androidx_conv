import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:bike_demo/toolbox/user.dart';
import 'package:bike_demo/toolbox/webservice.dart';


/*
 **************** N O T E **********

 Using any of the FirebaseAuth methods (signinwithemail etc) you must run
 with "Start without Debugging" so the proper exceptions are raised.  If you run any of these methods
 in debug mode, the platformexception will be thrown and you can't catch it.  It's an issue with VSC.

*/

class Account  {

  // Attributes
  FirebaseUser user;
  FirebaseAuth _auth = FirebaseAuth.instance;


// Send Password Reset email
  Future<bool> sendPasswordResetEmail({String email}) async {

    bool sendStatus = false; 
    try {
      await _auth.sendPasswordResetEmail( email: email);
      sendStatus=true;
    } catch(e){

    /* Errors:
      no email address ->  Given String is empty or null
      wrong email address-->  There is no user record corresponding to this identifier. The user may have been deleted.
    */
      sendStatus=false;

      // TODO:  need to return a value null or the exception instead of boolean
      print("Error in sendpasswordresetemail: ${e.toString()}");
    }
    return sendStatus; 
  }



  // Sign in with Email and Password
  Future<Map<String,dynamic>> signInWithEmailAndPassword({String email, String password}) async {

    String msg;
    bool signInStatus=false;
    // We use the try catch block here so we can push the results into CurrentUser,
    // so we don't have to catch the error on the calling program
    try { 
     FirebaseUser fbuser = await _auth.signInWithEmailAndPassword( password: password, email: email);
     assert( fbuser !=null );

      // get the token and assign it to the uid.  this is also called in create account, 
      // but we also do it here in case there is a problem. 
      new FirebaseMessaging().getToken().then((String fcmToken){
            new User().setFCMToken(uid: fbuser.uid, fcmToken: fcmToken);
      });

     signInStatus=true;
     
    } catch( e ){
        /* 
        "Password is Invalid" - The user has a valid account (ie email address), but password is wrong
        "There is no user record corresponding to this Identifier" - The email entered does not exist.
        "The user account has been disabled by administrator" - Admin disabled the user from loggin in. 
        */

      // TODO: probably should return null or the exception instead of boolean
      print("Error signing in: ${e.toString()}");
      signInStatus=false;
      msg=e.toString();
    }

    Map map =Map<String,dynamic>(); 
    map['status'] = signInStatus;
    map['msg'] =msg;


    return map;
  }



// Sign in anonymously
/*
  Each time this is called, it creates an anonymous user account in Firebase. 
*/
  void signInAnonymously() {
    _auth.signInAnonymously().then((user) {
     assert(user !=null); 
      print("SignInAnonomously: $user");

    }).catchError((e) { // Not sure what would cause exceptions to be thrown
        print("SignInAnonomously Exception: $e");
    });
  }



// Create user Account with Email and Password
  Future<bool> createAccount({String email, String username, String password, double latitude, double longitude}) async {

    bool createAccountStatus=false;

    // An example of creating a displayname and photo url and updating in firebase
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = username;
   // userUpdateInfo.photoUrl = "photo url goes here";

    try {
      FirebaseUser fbuser = await _auth.createUserWithEmailAndPassword( email: email, password: password);

      assert( fbuser !=null );

      User user = new User(); // create the user so we can do updates

      // set the displayname, associated with the uid
      user.setDisplayName(uid: fbuser.uid, displayName: username);
      // get the token and assign it to the uid 
      new FirebaseMessaging().getToken().then((String fcmToken){
            user.setFCMToken(uid: fbuser.uid, fcmToken: fcmToken);
      });

      // Make the call to the SQL DB and store the user
      var payload = {'uid':fbuser.uid,'username':username, 'email': email, 'latitude':latitude, 'longitude':longitude};
      new WebService().run(service: 'XinsertUser.php', jsonPayload: payload).then((sqldata){
        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {
          print("sqldata = ${sqldata.toString()}");
        // Something went wrong with the http call
        } else {
          print("Http Error: ${sqldata.toString()}");
        }
      }).catchError((e) {
          print(" WebService error: $e");
      });


      /* NOTE:  user.sendEmailVerification() will send an email with a link. If the user clicks the 
        link, the email will be verified. This means is the property isEmailVerified in the user
        will be set to true.  If the link is not clicked, the user can still login, but the
        property isEmailVerified will be false. 

        If user.sendEmailVerification() is not used, the isEmailVerified will always be false.

      */
      //user.sendEmailVerification(); // Optional if u want the email verified. Does not effect logging in

      createAccountStatus=true;
    } catch(e){
      /*
      "The email address is already in use by another account" - The email address entered is already setup
      */
      // TODO: probably should return null or exception instead of boolean
        print("Error creating account: ${e.toString()}");
        createAccountStatus=false;
    }
    return createAccountStatus;
       
  } // Create account method



// Sign in with Google
Future<String> signInWithGoogle() async {

    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken,);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print( 'signInWithGoogle succeeded: $user');
    return 'signInWithGoogle succeeded: $user';
  }



} // End of class


