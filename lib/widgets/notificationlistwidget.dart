import 'package:flutter/material.dart';
import 'package:bike_demo/toolbox/topic.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/toolbox/account.dart';




/*
This class displays all the notifications associated with a topic(s)

*/


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
      appBar: new AppBar( title: new Text("Notifications"), centerTitle: true,
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
                title: new Text(topics[index]['content']),
                subtitle: new Text(topics[index]['displayName']),
               trailing: new Text(new Tools().getDuration(datetime:topics[index]['datetime'])),
               // leading: getImage( keystore: sqlDataRows[index]['uid'], image: sqlDataRows[index]['photo']),
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
    reviewPostedList = await new Topic().getNotifications( topicName: "reviewPosted");
    bikeAddedList = await new Topic().getNotifications( topicName: "bikeAdded");
    advertisementList = await new Topic().getNotifications( topicName: "advertisement");

    List topicList = [reviewPostedList, bikeAddedList, advertisementList].expand((x) => x).toList();
    topicList.sort((a,b) => a['datetime'].compareTo(b['datetime']));
      
   // For some reason the sort method is sorting it in decending order.  so we reverse the list
   // to return the list in acsending order
    return topicList.reversed.toList();
  }



// ********** ACTION Methods

// for testing only..

// TODO:  This method was used for testing but should be inserted into another class when the user
// adds a bike, promotes an advertisement etc. 

void addEntry() {


      //String topicName = 'bikeAdded';
      String topicName = 'advertisement';
      String uid = 'xxxxzzzwww333';
      String displayName = "Yeti Cycles";
      String content = "See the new SB 150 !!";
      new Topic().addNotification( topicName: topicName, 
              displayName: displayName, 
              uid: uid,
              content: content,
              photoURL : "https://www.yeti.com/avatar.jpg",
              );

}




  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user ==null) {
             new Account().showAccountAccess( context: context, title: "To view notifications you have to be logged in");
         } else {
            // TODO: display notifcation, user is logged in
            print("notification hit ${_topics[index]['content']}");
         }

        });
    

    // //   //String topicName = 'bikeAdded';
    //   String topicName = 'reviewPosted';
    //   String uid = 'zzzxxx';
    //   String displayName = "chuppy";
    //   String content = "posted new review on primer";
    //   new Topic().addTopicEntry( topicName: topicName, 
    //           displayName: displayName, 
    //           uid: uid, 
    //           content: content);

      


      // //Create the add topic
      // String displayName = "Yeti";
      // String websiteURL = "https://www.yeticycles.com";
      // String content = "New SB150 is here !";
      // new Topic().addAdTopic( displayName: displayName, content: content, websiteURL: websiteURL);

   }


   




} // end of class