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
  List<String> providers;
  Exception e;

  String toString() {
    return("user=$user, tokenID=$tokenID, providers=${providers.toString()}, e=${e.toString()}");

  }
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


// Fetch the providers (ie how they logged in)
 Future<LoginResult> fetchProvidersForEmail({String email}) async {
   
   // NOTE: if an email address is not found in firebase it will return a empty list
   // a provider of "password" indicates the user signed in with email and password
    LoginResult loginResult = new LoginResult();
    try {
      List<String> providers = await _auth.fetchProvidersForEmail( email: email);
      loginResult.providers = providers;
    } catch (e) {
      loginResult.e = e;
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
    return loginResult; // if loginResult.e is null, it was successful
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
  Future<LoginResult> createAccount({String email, String username, String password}) async {

    // An example of creating a displayname and photo url and updating in firebase
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = username;
   // userUpdateInfo.photoUrl = "photo url goes here";

    LoginResult loginResult = new LoginResult();

    try {
      FirebaseUser user = await _auth.createUserWithEmailAndPassword( email: email, password: password);

      assert( user !=null );
      loginResult.user = user;
      loginResult.tokenID = await user.getIdToken();
      _auth.updateProfile(userUpdateInfo);

      // NOTE: This is where we would make the call the SQL DB to create the account there as well.
      // The UID we could use in the MySQL db as a link between the user account in Firebase and
      // the MySQL database.

      /* NOTE:  user.sendEmailVerification() will send an email with a link. If the user clicks the 
        link, the email will be verified. This means is the property isEmailVerified in the user
        will be set to true.  If the link is not clicked, the user can still login, but the
        property isEmailVerified will be false. 

        If user.sendEmailVerification() is not used, the isEmailVerified will always be false.

      */
      //user.sendEmailVerification(); // Optional if u want the email verified. Does not effect logging in

     return loginResult;
    } catch(e){
      /*
      "The email address is already in use by another account" - The email address entered is already setup
      */
        loginResult.e = e; 
        return loginResult;
    }
       
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



  // SignOut
  void signOut() {

    _auth.signOut().then((user) {
      print("User Signed Out"); 

    }).catchError((e) {
      print("Exception in signOut:$e");

    });

  }




} // End of class


