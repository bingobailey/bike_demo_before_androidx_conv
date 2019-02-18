
import 'package:geolocator/geolocator.dart';


class Location {
  double latitude;
  double longitude;

  Location({this.latitude,this.longitude});

  String toString() {
    return 'latitude=$latitude,  longitude=$longitude';
  }
}



class LocationService {

  // Get the Location
  Future<Location> getGPSLocation() async {
      // Get the location of the device 
      Position p = await Geolocator().getCurrentPosition( desiredAccuracy: LocationAccuracy.low);
      if (p==null) {
          print("could not determine location");
          return null;
      }

      Location location = new Location(latitude: p.latitude, longitude: p.longitude);
      return location;
   }



}