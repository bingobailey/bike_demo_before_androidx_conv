import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- when a user adds a bike, if they click on that bike in the bikelistwidget it brings up the chat 
  screen which essentially allows them to chat with themselves.  Need to come up with a way that 
  either displays a contact button or chat button if not the same user.  when the user clicks 
  on the button it displays the chat screen.  Instead of photo in leading: maybe put the button
  there.  

- need to look at passing Notify on ShowAccount,  after logging in, show it refreshes the screen. 


*/