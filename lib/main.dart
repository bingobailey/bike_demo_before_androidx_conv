import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- Code in message.dart to determine user is not working.  it's async.  need to remove it
  and use something that is more static.  look at Message.dart and MessageWidget.dart

- create another widget within listtile for bikelistwidget that includes photo and username.  would be like adding
  a row in the title. the row would contiain two widgets; (1) one widget with two columes (photo and name), second widget
  with two columns  (model & action) action would be in smaller font. 

- Create an algorithm that deletes channels in SQLDb and FB based on date (ie delete all <= date)

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/