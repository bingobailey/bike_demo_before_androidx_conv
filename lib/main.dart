import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}




/*
TODO:  

- identify anwhere in app hardcoding is done with topics

- on userprofilewiget
   create xupdateUser.php
   implement selectUser to update properties (ie _email, imageName, etc)
   use progressLoaderINdicator()
   once properties are updated, issue setstate()
   add units
   allow select photo
   allow which topics to subscribe to


- displayname is not unique, does that cause a problem ? since email is not shown
  how do you distinguish between two users if they have the same displayname/username ?

    code copies from stackoverflow:

          A better solution for you may be to use your unique username as the /users/ node's child keys instead of the 
          uid values. Then, when a new user tries picking a username (say "jacob"), you can use a Firebase 
          query to check if the username is taken:

          usersRef.startAt(null, "jacob").endAt(null, "jacob").on("value", function(snapshot) {
            if (snapshot.val() === null) {
              // username not taken
            } else {
              // username taken
            }  
          });


  
- Start work on charging explore;
    in app purchases


- Create an algorithm that deletes channels in SQLDb and FB based on date (ie delete all <= date)

- see signupwidget  do not allow signing up without latitude or longitude 
- see bikelistwidget.  if lat and lng are null, call gps again and/or show a widget in the 
- see bikeaddwidget.  if you cannot get lat and long, prevent adding a bike otherwise it won't work. 
       
_bodyWidget that contains a button to get the gps again.  with description why. 
  

*/