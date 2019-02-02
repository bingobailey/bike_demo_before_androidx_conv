import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  
  
  - COMMIT Changes to GIT before continuing with changes below. 
  - Create SQL Table name 'Channel'  with the following fields
    UIDFrom
    UIDTo
    BikeID
    Date
    channel_id  (which will be composed of UIDFrom_UIDTo_BikeID)

    -When a user initates a chat, instead of creating a channel in the FB, create the record
    in the SQL table. 
    - remove the 'channel' node from FB
    - In chat list widget, make call to sqldb using UIDFrom or UIDTo (user either iniated call, or another user
      iniated the call to that user) SORTED by descending date. 
      
    - Change chat list  ListTile to show the username on the left instead of a subtitle.  

    - Make Font bigger (use default font) on chat list widget
    - Consider making a tool to get database calls easier by hiding more of the complexity. 



- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/