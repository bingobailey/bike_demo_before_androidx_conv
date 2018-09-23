import 'package:firebase_auth/firebase_auth.dart';
 

 // This login class contains the attributes of the user logged in so we can access it
 // anywhere in the app.  It is implemented as a singleton. 
 class CurrentUser {

   // Attributes:
   FirebaseUser user;
   String tokenID; 
   List<String> providers;
   Exception e;

  //static final CurrentUser _singleton = new CurrentUser._internal(); // singleton

  static CurrentUser _instance;

  static CurrentUser getInstance() {
    if (_instance==null) {
      _instance = new CurrentUser();
    }
    return _instance;

  }



  // Methods:
   

    bool isLoggedIn() {
      if (user != null) return true;
      else return false;
    }

  String toString() {
    return("user=$user, tokenID=$tokenID, providers=${providers.toString()}, e=${e.toString()}");

  }
}