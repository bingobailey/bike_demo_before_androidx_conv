import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/utils/tools.dart';
import 'package:bike_demo/constants/globals.dart';
import 'package:bike_demo/utils/topic.dart';
import 'package:bike_demo/utils/user.dart';


class NotificationListWidget extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return new _NotificationListWidgetState();
  }

}


class _NotificationListWidgetState extends State<NotificationListWidget> {
 
  List _notifications; // need this so we can associate which index the use clicks on

  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 
  String currentUserDisplayName;

  @override
    void initState() {
      super.initState();

      // display the notifications
      _bodyWidget = new Tools().showProgressIndicator();
      getNotifications().then((List notifications){
        _notifications = notifications; // We store it so we can access it when  user clicks
        setState(() {
          _bodyWidget = buildNotificationsListWidget( notifications: notifications );
        });
      });
    
    }



// *********** BUILD methods

  @override
    Widget build(BuildContext context) {

      return new Scaffold(
      appBar: new AppBar( title: new Text("Notifications", style: TextStyle(fontSize: baseFontLarger ),), centerTitle: true,
      ),
      body: new Center(
         child: _bodyWidget,
      ),

    );
  }



// TODO: need to get leading: image, see below

  // Using the SQL Data build the list widget
  Widget buildNotificationsListWidget({List<dynamic> notifications}) {

    return new Center(
          child: new ListView.builder(
            itemCount: notifications.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(notifications[index]['content'], style: TextStyle(fontSize: baseFont),  ),
                subtitle: new Text(notifications[index]['displayName'],style: TextStyle(fontSize: baseFontSmaller),),
               trailing: new Text(new Tools().getDuration(utcDatetime:notifications[index]['datetime']),
                              style: TextStyle(fontSize: baseFontSmaller),   ),
               // leading: new ImageService().getImage( key: sqlDataRows[index]['uid'], image: sqlDataRows[index]['photo']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }



  // Retrieve the notifications
  Future<List> getNotifications() async {
   
    // Let's get the subscribed topics from the user
    List subscribedTopics =[];
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user ==null) { // not logged in, so default to all topics
        subscribedTopics = await new Topic().getTopicList();
    } else {
        subscribedTopics = await new User().getTopicsSubscribed(uid: user.uid);
    }
        
    // Let's pull the notifications associated with each topic from fb
    List topicNotification=[];
    List notifications=[];
    int i=0;
    while (i < subscribedTopics.length) {
      topicNotification = await new Topic().pullNotifications(topic: subscribedTopics[i++]);
      notifications.addAll(topicNotification);
    }

    // Now we sort the list by date (which sorts ascending), then reverse the list to make it descending. 
    notifications.sort((a,b) => a['datetime'].compareTo(b['datetime' ]));
    return notifications.reversed.toList();

  }



// ********** ACTION Methods

  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user ==null) {
             new Tools().showAccountAccess( context: context, title: "To view notifications you have to be logged in");
         } else {
            // TODO: display notifcation, user is logged in
            print("notification hit ${_notifications[index]['content']}");
         }

        });
   }





} // end of class