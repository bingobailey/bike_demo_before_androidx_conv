
import 'dart:async';
import 'package:location/location.dart';    // For getting location 
import 'package:flutter/services.dart';    // For PlatformException

/*
NOTE: This progam demonstrates the use of getting the location; 
- SEE the dependency location added to pubspec.yaml
- SEE getLocation function
- SEE https://pub.dartlang.org/packages/location#-readme-tab- 
      on specific implementation reqs for each platform
*/

class LocationService {
    

  // This function gets the location 
  Future<Map> getLocation() async {

    // The location will be a map variable
     Map<String,double> currentLocation;

    
    // Initialize an instance of the Location class
    Location location = new Location();

    try {
     currentLocation = await location.getLocation(); // Make a call to get the location
     print("Latitude: ${currentLocation['latitude']}  Longitude: ${currentLocation['longitude']}");

    } on PlatformException {
      print("Unable to determine Location");
      currentLocation = null;
    }
    return currentLocation;
  }

}