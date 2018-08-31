import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


/*
 
 **************** N O T E **********

 Using any of the FirebaseAuth methods (signinwithemail etc) you must run
 with "Start without Debugging" so the proper exceptions are raised.  If you run any of these methods
 in debug mode, the platformexception will be thrown and you can't catch it.  It's an issue with VSC.


*/


class LoginResult {
  FirebaseUser user;
  String tokenID; 
  Exception e;
}



class Credentials  {

  // Attributes for Signing in with Phone No. 
  TextEditingController _smsCodeController = new TextEditingController();
  String verificationId;
  final String testSmsCode = '123456';
  final String testPhoneNumber = '+1 408-555-6969';

FirebaseAuth _auth = FirebaseAuth.instance;

  Credentials() {
  

    /*
      Here we can get the current user in cache if they are already logged in.
    */
     

      _auth.currentUser().then((user) {

          if (user!=null) {
            print("User is already logged in : $user");
            print("user uid = ${user.uid}"); // We could use this to link with MySQL db.  

          } else {
            print("User is not logged in");
          }
      }).catchError((e) {
          print("exception occurred in auth.CurrentUser() call: $e");

      });

  }
 

// Sign in with Email and Password
Future<LoginResult> signInWithEmailAndPassword({String email, String password}) async {

    LoginResult loginResult = new LoginResult(); 
    FirebaseUser user = await _auth.signInWithEmailAndPassword( password: password, email: email);
    
    try { 
    
     assert( user !=null );
     loginResult.user = user;
     loginResult.tokenID = await user.getIdToken();

     return loginResult;
     
    } catch( e ){
        /* 
        "Password is Invalid" - The user has a valid account (ie email address), but password is wrong
        "There is no user record corresponding to this Identifier" - The email entered does not exist.
        "The user account has been disabled by administrator" - Admin disabled the user from loggin in. 
        */
      print("Login Exception: $e "); 
      loginResult.e = e;
      return loginResult;

    }

    // _auth.signInWithEmailAndPassword(email: email, 
    // password: password ).then((user) {
    //   assert(user != null);  // If true, will throw an exception caught below
    //   assert(user.getIdToken() != null);

    //   // this info can be set with  auth.updateProfile( userprofile);  See create account. 
    //   print("user displayName: ${user.displayName}");
    //   print("user PhotoURL: ${user.photoUrl}");


    //    print("Login: $user");
    //    print("token: ${user.getIdToken()}");

    // }).catchError((e) {  // See the List below which will throw an exception
    //     /* 
    //     "Password is Invalid" - The user has a valid account (ie email address), but password is wrong
    //     "There is no user record corresponding to this Identifier" - The email entered does not exist.
    //     "The user account has been disabled by administrator" - Admin disabled the user from loggin in. 
    //     */
    //   print("Login Exception: $e "); 
    // });

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
  void createAccount() {

    // An example of creating a displayname and photo url and updating in firebase
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = "Joey";
    userUpdateInfo.photoUrl = "photo url goes here";

    _auth.createUserWithEmailAndPassword(email: "psimoj@gmail.com", 
    password: "dinkeydoo9").then((user) {
      assert(user !=null);
      
       assert(user.getIdToken() != null);
        // If user is not null, let's update the user profile, with displayname and photoURL if we
        // have it. 
        _auth.updateProfile(userUpdateInfo);

      // The UID we could use in the MySQL db as a link between the user account in Firebase and
      // the MySQL database.  
       
       String uid = user.uid;
       print("uid = $uid");

      /* NOTE:  user.sendEmailVerification() will send an email with a link. If the user clicks the 
        link, the email will be verified. This means is the property isEmailVerified in the user
        will be set to true.  If the link is not clicked, the user can still login, but the
        property isEmailVerified will be false. 

        If user.sendEmailVerification() is not used, the isEmailVerified will always be false.

      */
      //user.sendEmailVerification(); // Optional if u want the email verified. Does not effect logging in
      print("Create Account: $user");

    }).catchError((e) { // See below what would cause an exception to be thrown 
      /*
      "The email address is already in use by another account" - The email address entered is already setup
      */

      print("Create Account Exception: $e");
    });

  }


// Test sign in with Google

Future<String> testSignInWithGoogle() async {

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




// Begining Testing with SignInwith Phone Number

/*

  Testing with SignInWithPHoneNumber

  NOTE:  Need a real device to test the phone number verification. It will not work on an emulator. const

  Ensure; 
  - Phone verfication is enabled on firebase
  - latest json file is in the android project directory

  It appears the way this works is;

    (1) auth.verifyPhoneNumber(....) is called with the appropriate arguments. see testVerifyPhoneNumber()
    (2) It should then send a verification code to the phone
    (3) The user enters this code, then a another call is made...  see testSignInWithPhoneNumber(...)

*/


  Future<void> testVerifyPhoneNumber() async {

    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
          print("signinwithPhonenumber auto succeeded: $user");
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {

        print( 'Phone numbber verification failed. Code: ${authException.code}. Message: ${authException.message}');

    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      _smsCodeController.text = testSmsCode;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      _smsCodeController.text = testSmsCode;
    };

   
    await _auth.verifyPhoneNumber(
        phoneNumber: testPhoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

      
  }

  Future<String> testSignInWithPhoneNumber(String smsCode) async {

    final FirebaseUser user = await _auth.signInWithPhoneNumber(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _smsCodeController.text = '';

    print('signInWithPhoneNumber succeeded: $user');

    return 'signInWithPhoneNumber succeeded: $user';
  }
// End testing with sign in phone no




  // SignOut
  void signOut() {

    _auth.signOut().then((user) {
      print("User Signed Out"); 

    }).catchError((e) {
      print("Exception in signOut:$e");

    });

  }




} // End of class


