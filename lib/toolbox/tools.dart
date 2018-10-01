
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class Tools {

  BuildContext context;


  // Methods:

    // Show the progress indicator
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






} // end of class