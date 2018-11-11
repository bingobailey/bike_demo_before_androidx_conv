
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:intl/intl.dart';   // don't remove this if u are using Duration, otherwise will crash



/*
  This class contains tools to help facilitate, UI and other tasks. 

  - LaunchURL 
  - showProgress Indicator
  - validate an email address
  - validate the password


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






} // end of class