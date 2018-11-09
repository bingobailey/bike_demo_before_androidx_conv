import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- Create screen to display bike after clicking on bike from bikelistwidget.  this screen should contain a 
  'send a message' button to the user of the bike.  user must be logged in to use the 'send a message'.  
  'send a message' button should display the chat screen with the associated user. 
- When a user adds a bike, send the notification to firebase

*/