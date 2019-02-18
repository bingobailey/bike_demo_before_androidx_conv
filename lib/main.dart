import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- Test out placing bikelistwidget first in the tab sequence and see if the gps works
- display dialog box if lat and long are null, to retry getting position.  REtry Cancel etc. 


- identify anwhere in app hardcoding is done with topics
- start on userprofilewidet (see below)

- Start work on User Profile tab.  
  add radius
  allow to select photo 
  add units (miles /km)
  allow topics to be subscribed to
  bikes you have listed
    allow capability to delete. 
  
- Start work on charging explore;
    in app purchases

- Might need to store general location lat and long, instead of exact location.  or use a more relaxed accuracy 
  method

- Create an algorithm that deletes channels in SQLDb and FB based on date (ie delete all <= date)

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/