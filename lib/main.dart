import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- Chat and chat list not working correctly (duplicating channels & target chats not showing up in chat list)
  - initiate a chat with baily (logged in as chuppy) and verify that one channel is created in FB
  - log in as baily and see if the chat shows up in the chat list  (before it wasn't)
  

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/