import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

 - Modify SQL tables and remove category table,  change category field to 'type' (DONE)
 - remove 'mfg' field and keep model   (DONE)
 - add model and comments to bikeaddwidget (DONE)
 - Test out submit button to ensure it saves it in db (DONE)

 - let the user determine. Maybe a check box ?  Size in CM ?  if checked, populate dropdown with cm, if not
 populate with classifications. Maybe just use one dropdown box and then just populate the box depending on
the selection. 
- Once this is working, make a checkpoint and sync


- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/