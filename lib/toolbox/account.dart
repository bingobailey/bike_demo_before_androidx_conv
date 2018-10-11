import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/loginwidget.dart';
import 'package:bike_demo/widgets/signupwidget.dart';
import 'package:bike_demo/toolbox/currentuser.dart';

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

 
  // Determine if current user is logged in.  If so, update the static vars
  // in the CurrentUser class

// TODO:  The code below should be moved to another method upon startup of the app
// to update CurrentUser().  should not be called from credentials
  Future<bool> isLoggedIn() async {

      bool loginStatus=false;
      //CurrentUser CurrentUser = new CurrentUser();
      FirebaseUser user = await _auth.currentUser();
      if(user != null ) {
        CurrentUser.getInstance().user = user;
        CurrentUser.getInstance().tokenID = await user.getIdToken();
        loginStatus=true;
      }
      return loginStatus;
  } 



// Fetch the providers (ie how they logged in)
 Future<bool> fetchProvidersForEmail({String email}) async {
   
   // NOTE: if an email address is not found in firebase it will return a empty list
   // a provider of "password" indicates the user signed in with email and password
    bool fetchStatus=false;
    try {
      List<String> providers = await _auth.fetchProvidersForEmail( email: email);
      CurrentUser.getInstance().providers = providers;
      fetchStatus=true;
    } catch (e) {
      CurrentUser.getInstance().e = e;
    }
  
    return fetchStatus;
 }



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
      CurrentUser.getInstance().e = e;
    }
    return sendStatus; 
  }



  // Sign in with Email and Password
  Future<bool> signInWithEmailAndPassword({String email, String password}) async {

    bool signInStatus=false;
    // We use the try catch block here so we can push the results into CurrentUser,
    // so we don't have to catch the error on the calling program
    try { 
     FirebaseUser user = await _auth.signInWithEmailAndPassword( password: password, email: email);
     assert( user !=null );
     CurrentUser.getInstance().user = user;
     CurrentUser.getInstance().tokenID = await user.getIdToken();
     signInStatus=true;
     
    } catch( e ){
        /* 
        "Password is Invalid" - The user has a valid account (ie email address), but password is wrong
        "There is no user record corresponding to this Identifier" - The email entered does not exist.
        "The user account has been disabled by administrator" - Admin disabled the user from loggin in. 
        */
      CurrentUser.getInstance().e = e;
      signInStatus=false;
    }
    return signInStatus;
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
  Future<bool> createAccount({String email, String username, String password}) async {

    bool createAccountStatus=false;

    // An example of creating a displayname and photo url and updating in firebase
    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = username;
   // userUpdateInfo.photoUrl = "photo url goes here";

    try {
      FirebaseUser user = await _auth.createUserWithEmailAndPassword( email: email, password: password);

      assert( user !=null );
      CurrentUser.getInstance().user = user;
      CurrentUser.getInstance().tokenID = await user.getIdToken();
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

      createAccountStatus=true;
    } catch(e){
      /*
      "The email address is already in use by another account" - The email address entered is already setup
      */
        CurrentUser.getInstance().e = e; 
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




// This dialog alerts the user they need to login, create or create an account
 void showAccountAccess({BuildContext context, String title}) {

   showDialog( context: context, 
    builder: (BuildContext context) {

      return new SimpleDialog(
         contentPadding: EdgeInsets.all(20.0),
         title: new Text(title),
          children: <Widget>[

              // Login Button
              new MaterialButton( 
                height: 50.0,
                minWidth: 200.0,
                child: new Text("Login", style: new TextStyle( fontSize: 20.0) ,),
                  onPressed: () {
                    Navigator.of(context).pop(); // Remove the dialog box
                    Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>new LoginWidget(),
                     ));

                  },
                  color: Colors.blue[200],
              ),
                  
              new SizedBox( height: 30.0,),

              // Sign Up Button
              new MaterialButton( 
                height: 50.0,
                minWidth: 150.0,
                 child: new Text("Sign Up", style: new TextStyle( fontSize: 20.0) ,),
                 onPressed: () {
                     Navigator.of(context).pop(); // Remove the dialog box
                     Navigator.push(context, MaterialPageRoute(
                           builder: (context)=>new SignUpWidget(),
                      ));
                  },
                  color: Colors.green[200],
              ),
                  
              new SizedBox( height: 30.0,),

              // Cancel Button
              new MaterialButton( 
                height: 50.0,
                minWidth: 200.0,
                child: new Text("Cancel", style: new TextStyle( fontSize: 20.0) ,),
                  onPressed: () {
                    Navigator.of(context).pop(); // remove the dialog box
                  }, 
                  color: Colors.red[200],
              ),
           ],
                       
      );

   });

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


