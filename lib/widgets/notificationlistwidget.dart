import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/toolbox/Notification.dart';
import 'package:bike_demo/constants/globals.dart';

class NotificationListWidget extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return new _NotificationListWidgetState();
  }

}


class _NotificationListWidgetState extends State<NotificationListWidget> {
 
  List _topics;  // need this so we can associate which index the use clicks on

  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 
  String currentUserDisplayName;

  @override
    void initState() {
      super.initState();

      // display the notifications
      _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");
      getTopics().then((List topics){
        _topics = topics; // We store it so we can access it when  user clicks
        setState(() {
          _bodyWidget = buildTopicListWidget( topics: topics );
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
  Widget buildTopicListWidget({List<dynamic> topics}) {

    return new Center(
          child: new ListView.builder(
            itemCount: topics.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(topics[index]['content'], style: TextStyle(fontSize: baseFont),  ),
                subtitle: new Text(topics[index]['displayName'],style: TextStyle(fontSize: baseFontSmaller),    ),
               trailing: new Text(new Tools().getDuration(utcDatetime:topics[index]['datetime']),
                              style: TextStyle(fontSize: baseFontSmaller),   ),
               // leading: getImage( key: sqlDataRows[index]['uid'], image: sqlDataRows[index]['photo']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }



  // Retrieve all the  topics
  Future<List> getTopics() async {
    List bikeAddedList;
    List reviewPostedList; 
    List advertisementList;

    // TODO:  topics are hardcoded here, but should be based on user's profile, whether they 
    // subscribe or not to a topic
    reviewPostedList = await new Notificaton().pull(topicName: "reviewPosted");
    bikeAddedList = await new Notificaton().pull( topicName: "bikeAdded");
    advertisementList = await new Notificaton().pull( topicName: "advertisement");

    List topicList = [reviewPostedList, bikeAddedList, advertisementList].expand((x) => x).toList();
    topicList.sort((a,b) => a['datetime'].compareTo(b['datetime']));
      
   // For some reason the sort method is sorting it in decending order.  so we reverse the list
   // to return the list in acsending order
    return topicList.reversed.toList();
  }



// ********** ACTION Methods

  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user ==null) {
             new Tools().showAccountAccess( context: context, title: "To view notifications you have to be logged in");
         } else {
            // TODO: display notifcation, user is logged in
            print("notification hit ${_topics[index]['content']}");
         }

        });


   }





} // end of class