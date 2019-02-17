import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  
- In topic.dart, add in user method (getSubscribedTopics).  If no topics are found for the user,
  by default the user is subscribed to all topics.  we want to do it this way because if not, we would
  be required to store all the topics for each user, not necessary.  also anytime a new topic is added, the user w
  will by default be subscribed to it without having to do anything.  If  topic exists, check to see if the property is true 
  (subsribed) or false not subscribed.  the reason is, on the profile widget if the user turns the subscrption off,
  then we well set the topic property to 'false'.  if they turn it back on again, it will be set to true.  
  
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



- Create an algorithm that deletes channels in SQLDb and FB based on date (ie delete all <= date)

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/