import 'package:flutter/material.dart';

import 'package:bike_demo/chat/chatlistwidget.dart';
import 'package:bike_demo/widgets/userprofilewidget.dart';
import 'package:bike_demo/widgets/topicnotificationListWidget.dart'; 
import 'package:bike_demo/widgets/bikelistwidget.dart';
import 'package:bike_demo/utils/topic.dart';
import 'package:bike_demo/utils/tools.dart';

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

      // starts up and initalizes
      startUp();

    }

  @override
  void dispose() {
      _controller.dispose();  // dispose of the controller 
      super.dispose();
    }



  @override
  Widget build(BuildContext context) {

      return new Scaffold( 
 
// TODO: switched notificationlistwidget to be first in the tab sequence, so the bikelistwidget
//       would have time to get the lat and lng, the first time the user loads the app.   There may be
//       a better way to do this but for now this works. 

          resizeToAvoidBottomPadding: false,
          body: new TabBarView( // Create a TabView and place the pages inside.In order of tabs above
            controller: _controller,
            children: <Widget>[
              new TopicNotificationListWidget(),
              new BikeListWidget(),   
              new ChatListWidget(),
              new UserProfileWidget(),
            
            ]
          ),  


          bottomNavigationBar: new Material( 
            color: Colors.indigo,
             child: new TabBar(  // This is the same code used above
             controller: _controller,
             tabs: <Tab>[
              new Tab( icon: new Icon(Icons.notifications)),
              new Tab( icon: new Icon(Icons.directions_bike)),
              new Tab( icon: new Icon(Icons.chat)),
              new Tab( icon: new Icon(Icons.person)),
           ]))

        );
     
    }



  // Startsup and initializes
  void startUp () {
     new Tools().getGPSLocation(); // get the gps location
     new Topic().listen();  // We call the notification class to initiate listening for msg etc 
  }
 



} // end of class