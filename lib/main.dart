import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- Incorporate getting topics from FB (see firebaseservice.gettopics)
  and not hard coding the topics anwywhere.  
- Implement a feature in the user fb, where they can subsribe or unscribe to topics. 
  include "topics" and the topic list under each user (if exist it's subscribed to by that user)

- Start work on User Profile tab.  
  add radius
  allow to select photo 
  add units (miles /km)
  allow topics to be subscribed to
  bikes you have listed
    allow capability to delete. 
  
- Start work on charging explore;
    in app purchases



- Create an algorithm that deletes channels in SQLDb and FB based on date (ie delete all <= date)

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/