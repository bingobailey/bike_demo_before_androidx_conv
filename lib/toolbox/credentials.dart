import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Attributes
  FirebaseUser user;
  FirebaseAuth _auth = FirebaseAuth.instance;

 
  // Get the current user, if logged in
  Future<LoginResult> getCurrentUser() async {
      LoginResult loginResult = new LoginResult();
      FirebaseUser user = await _auth.currentUser();
      if(user != null ) {
        loginResult.user = user;
        loginResult.tokenID = await user.getIdToken();
      }
      return loginResult;
  }




// Send Password Reset email
  Future<LoginResult> sendPasswordResetEmail({String email}) async {

    LoginResult loginResult = new LoginResult();
    try {
      await _auth.sendPasswordResetEmail( email: email);
    } catch(e){

    /* Errors:
      no email address ->  Given String is empty or null
      wrong email address-->  There is no user record corresponding to this identifier. The user may have been deleted.
    */
      loginResult.e = e;
    }

    return loginResult;

  }

  // Sign in with Email and Password
  Future<LoginResult> signInWithEmailAndPassword({String email, String password}) async {

    LoginResult loginResult = new LoginResult(); 
    // We use the try catch block here so we can push the results into LoginResult,
    // so we don't have to catch the error on the calling program
    try { 
     FirebaseUser user = await _auth.signInWithEmailAndPassword( password: password, email: email);
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
      loginResult.e = e;
      return loginResult;
    }
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



  // SignOut
  void signOut() {

    _auth.signOut().then((user) {
      print("User Signed Out"); 

    }).catchError((e) {
      print("Exception in signOut:$e");

    });

  }




} // End of class


