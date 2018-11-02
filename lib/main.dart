import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  


 firebaseauth.instance.currentuser()  instead of storing user ?  

 -->  don't auto login.  store email to disk (not pasword).  check to see if currentuser() is null, if so,
 bring up sign in box with email filled out.    don't auto login.  otherwise, if the person logs out,
 next time they conme in it will auto login using emal and paswordl 

 - Signout in currentuser() is causing a crash.  it has been documented as a problem in flutter. 

 - need to store latitude and longitude on disk.  and at start of app.  if the user is not signed up, will not
   have an account, but we still need the lat and long to pull the bikes. 



*/