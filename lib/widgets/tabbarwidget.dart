import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/chat/chatlistwidget.dart';
import 'package:bike_demo/widgets/userprofilewidget.dart';
import 'package:bike_demo/widgets/notificationListWidget.dart'; 
import 'package:bike_demo/widgets/bikelistwidget.dart';
import 'package:bike_demo/toolbox/notification.dart';
import 'package:bike_demo/toolbox/currentuser.dart';

class TabBarWidget extends StatefulWidget {
  @override
  _TabBarWidgetState createState() => new _TabBarWidgetState();
}

// SingleTickerProviderStateMixin provides animation
class _TabBarWidgetState extends State<TabBarWidget>  with SingleTickerProviderStateMixin {

  // Need this to handle the tabs
  TabController _controller;

  @override
  void initState() {
      super.initState();
     _controller = new TabController( vsync: this, length: 4 );

      new Notificaton().listen();  // We call the notification class to initiate listening for msg etc 
      getGPSLocation(); // get the gps location

      // If we are logged in, set the user and the assoc parms
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user !=null) {
          CurrentUser.getInstance().user = user;
        }});

    }

  @override
  void dispose() {
      _controller.dispose();  // dispose of the controller 
      super.dispose();
    }



  @override
  Widget build(BuildContext context) {

      return new Scaffold( 
 
          resizeToAvoidBottomPadding: false,
          body: new TabBarView( // Create a TabView and place the pages inside.In order of tabs above
            controller: _controller,
            children: <Widget>[
              new BikeListWidget(),
              new NotificationListWidget(),
              new ChatListWidget(),
              new UserProfileWidget(),
            
            ]
          ),  


          bottomNavigationBar: new Material( 
            color: Colors.indigo,
             child: new TabBar(  // This is the same code used above
             controller: _controller,
             tabs: <Tab>[
              new Tab( icon: new Icon(Icons.directions_bike)),
              new Tab( icon: new Icon(Icons.notifications)),
              new Tab( icon: new Icon(Icons.chat)),
              new Tab( icon: new Icon(Icons.person)),
           ]))

          );
     
    }


  void getGPSLocation() {

      // Get the location of the device 
      new Geolocator().getCurrentPosition( desiredAccuracy: LocationAccuracy.best).then((Position p) {
        if (p==null) {
          // TODO:  If we cannot deterine location, probably need to display something 
          print("could not determine location");
        } else {
          
          print("location = {$p.toString()");

          // Save to disk
          SharedPreferences.getInstance().then((prefs) {
              prefs.setDouble('latitude',p.latitude);
              prefs.setDouble('longitude',p.longitude);
          });

        }
      });

  }







} // end of class