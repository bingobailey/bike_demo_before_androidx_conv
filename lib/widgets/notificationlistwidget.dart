import 'package:flutter/material.dart';
import 'package:bike_demo/toolbox/topic.dart';
import 'dart:async';
import 'package:intl/intl.dart';   // don't remove this if u are using Duration, otherwise will crash

import 'package:bike_demo/toolbox/currentuser.dart';
import 'package:bike_demo/toolbox/tools.dart';




class NotificationListWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _NotificationListWidgetState();
  }

}


class _NotificationListWidgetState extends State<NotificationListWidget> {
 
  List _topics; 

  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 
  String currentUserDisplayName;

  @override
    void initState() {
      super.initState();


      // Only show list if logged in
      if (CurrentUser.getInstance().isAuthenticated()) {
        _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");
        getTopics().then((List topics){
          _topics = topics; // We store it so we can access it when  user clicks
          setState(() {

              // _bodyWidget = new Center(
              //    child: new GestureDetector( child: new Text("click me"), onTap: addEntry,)
              // );

            _bodyWidget = buildTopicListWidget( topics: topics );

          });

        });
      } else {
        _bodyWidget = new Text("not logged in");
      }
    


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



  // Using the SQL Data build the list widget
  Widget buildTopicListWidget({List<dynamic> topics}) {

    return new Center(
          child: new ListView.builder(
            itemCount: topics.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(topics[index]['content']),
                subtitle: new Text(topics[index]['displayName']),
                trailing: new Text(getDuration(datetime:topics[index]['datetime'] )),
               // leading: getImage( keystore: sqlDataRows[index]['photo_key_store'], image: sqlDataRows[index]['photo_profile_name']),
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

    reviewPostedList = await new Topic().getNotifications( topicName: "reviewPosted");
    bikeAddedList = await new Topic().getNotifications( topicName: "bikeAdded");
    advertisementList = await new Topic().getNotifications( topicName: "advertisement");

    List topicList = [reviewPostedList, bikeAddedList, advertisementList].expand((x) => x).toList();
    topicList.sort((a,b) => a['datetime'].compareTo(b['datetime']));
      
   // For some reason the sort method is sorting it in decending order.  so we reverse the list
   // to return the list in acsending order
    return topicList.reversed.toList();
  }


  String getDuration({String datetime}) {

      String timeElapsed;

      DateTime dt = DateTime.parse(datetime);
      Duration duration = DateTime.now().difference(dt);

      if (duration.inHours < 1) {
           timeElapsed = "${duration.inMinutes}m";
           return timeElapsed;
      }

      if (duration.inHours < 24) {
            timeElapsed = "${duration.inHours}h";
           return timeElapsed;
      }

      if (duration.inHours > 24) {
            timeElapsed = "${duration.inDays}d";
           return timeElapsed;
      }
     

      // print("days= ${duration.inDays}");
      // print("hrs = ${duration.inHours}");

      return timeElapsed;

  }



// ********** ACTION Methods

// for testing only..

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

    print("notification hit ${_topics[index]['content']}");

    new Tools().launchURL( url: "https://www.yeticycles.com");




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