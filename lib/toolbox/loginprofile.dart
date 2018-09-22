import 'package:firebase_auth/firebase_auth.dart';
 

 // This login class contains the attributes of the user logged in so we can access it
 // anywhere in the app.  It is implemented as a singleton. 
 class LoginProfile {

   // Attributes:
   FirebaseUser user;
   String tokenID; 
   List<String> providers;
   Exception e;

  static final LoginProfile _singleton = new LoginProfile._internal(); // singleton


  // Methods:
   
    factory LoginProfile() {
      return _singleton;
    }

    LoginProfile._internal(){
      // any initialization goes here.. 
    }

  String toString() {
    return("user=$user, tokenID=$tokenID, providers=${providers.toString()}, e=${e.toString()}");

  }
}