
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:intl/intl.dart';   // don't remove this if u are using Duration, otherwise will crash
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bike_demo/widgets/loginwidget.dart';
import 'package:bike_demo/widgets/signupwidget.dart';

/*
  This class contains tools to help facilitate, UI and other tasks. 

  - LaunchURL 
  - showProgress Indicator
  - validate an email address
  - validate the password
  - getDuration (diff between times)
  - showAccountAccess   (for logging in or signing up)


*/

class Tools {

  BuildContext context;

    // Show the progress indicator along with the title (optional)
    Widget showProgressIndicator({String title}) {
      if (title==null) {
          return new CircularProgressIndicator();
      } else 
      return new Column( mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new CircularProgressIndicator(), 
          new Padding(  padding: const EdgeInsets.all(5.0)),
          new Text(title)],);
    }


  // Launch the URL in the browser
  // NOTE: setting forceSafariVC and forceWebView to false, opens the url in the browser, which might
  // be the safest option.  If you set forceSafariVC and forceWebview to true, it will force to open 
  // within the app (webview) on both android and iOS 

  Future launchURL({String url}) async {
    if (await canLaunch(url)) {
      await launch( url, forceSafariVC: false, forceWebView: false);
    } else {
      print("unable to launch URL");
    }

  }

    // Validate email
    String validateEmail(String value) {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return 'Please enter a valid email';
        else
          return null;  // returning null indicates the validation has passed
      }


      // Validate password
      String validatePassword(String value) {
        if (value.length < 8) {
          return 'Must be at least 8 characters';
        } else
          return null;  // returning null indicates the validation passed
      }



  // Return the amount of min, or hours or days from the time the notifcation was posted until
  // now
  String getDuration({String datetime}) {

      String timeElapsed;

      DateTime dt = DateTime.parse(datetime);
      Duration duration = DateTime.now().difference(dt);

      if (duration.inHours < 1) {
           timeElapsed = "${duration.inMinutes}m";
           return timeElapsed;
      }

      if (duration.inHours < 24) {
            timeElapsed = "${duration.inHours}h";
           return timeElapsed;
      }

      if (duration.inHours > 24) {
            timeElapsed = "${duration.inDays}d";
           return timeElapsed;
      }
     
      return timeElapsed;

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


  // Get the Location
  Future<Position> getGPSLocation() async {
      // Get the location of the device 
      Position p = await Geolocator().getCurrentPosition( desiredAccuracy: LocationAccuracy.best);
      if (p==null) {
        // TODO:  If we cannot deterine location, probably need to display something 
          print("could not determine location");
      } else {

        // Save to disk
        SharedPreferences.getInstance().then((prefs) {
             prefs.setDouble('latitude',p.latitude);
            prefs.setDouble('longitude',p.longitude);
        });
      }

      return p;
  
   }






} // end of class