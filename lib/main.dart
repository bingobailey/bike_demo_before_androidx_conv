import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- Change CurrentUser  to 'User' class without a singleton. 
   store the signin user UID to disk. 
   to get the current user, user use firebaseauth.currentuser() as in the rest of the code 
   change methods to accept uid along with other methods.  such as setEmail(uid, email);
   in this way, you will be able to use User class methods, on any user.
   don't remove CurrentUser class.  create a new class User, and slowly add methods to this class and
   replace the other methods using CurrentUser class. once everything is working with User, then you can remove
   CurrentUser class.  

- When a user adds a bike, send the notification to firebase

*/