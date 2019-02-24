import 'package:flutter/material.dart';
import 'package:bike_demo/widgets/tabbarwidget.dart';


void main() {
  runApp(new MaterialApp(
     home: new TabBarWidget(), 
  ));
}


/*
TODO:  

- Add more details about the user in the chatwidget title, maybe avatar, bike name details etc.

- Continue work on userprofilewidget
   implement feature to select photo
   add units
   allow which topics to subscribe to

- imagepicker module is causing app to crash
- when not logged in, when bikelist shows it just locks up in a loop with progress indicator
- when not logged in, accessing userprofilewidget, gets locked up in loop with progress indicator
- Getting errors when running the app.  it seems to work but the errors should be fixed. 
- 'bikeAdded' is hardcoded as a notification when adding a bike 
- Are notifications working (ie listening etc )?
- Add ability to dismiss (dismissable) / delete chats in chatlist


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