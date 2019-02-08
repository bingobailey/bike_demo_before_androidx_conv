import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- photos have been added to user directories. 
- add function in imageservice to download image (wrapping the image package) concatonate the correct URL
- create another widget within listtile for bikelistwidget that includes photo and username.  would be like adding
  a row in the title. the row would contiain two widgets; (1) one widget with two columes (photo and name), second widget
  with two columns  (model & action) action would be in smaller font. 

- channelist widget blowing up after modifications (adding username and photourl)

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/