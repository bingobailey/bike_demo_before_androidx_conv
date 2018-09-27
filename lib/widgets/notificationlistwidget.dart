import 'package:flutter/material.dart';
import 'package:bike_demo/toolbox/topic.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:bike_demo/toolbox/currentuser.dart';
import 'package:bike_demo/toolbox/uitools.dart';




class NotificationListWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _NotificationListWidgetState();
  }

}


class _NotificationListWidgetState extends State<NotificationListWidget> {
 
  List _actionTopics; 

  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 
  String currentUserDisplayName;

  @override
    void initState() {
      super.initState();


      // Only show list if logged in
      if (CurrentUser.getInstance().isAuthenticated()) {
        _bodyWidget = new UITools().showProgressIndicator( title: "Loading...");
        getActionTopics().then((List actionTopics){
          _actionTopics = actionTopics; // We store it so we can access it when  user clicks
          setState(() {
            _bodyWidget = buildActionListWidget( actionTopics: actionTopics );
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
  Widget buildActionListWidget({List<dynamic> actionTopics}) {

    return new Center(
          child: new ListView.builder(
            itemCount: actionTopics.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(actionTopics[index]['description']),
                subtitle: new Text(actionTopics[index]['displayName']),
                trailing: new Text(getDuration(datetime:actionTopics[index]['datetime'] )),
               // leading: getImage( keystore: sqlDataRows[index]['photo_key_store'], image: sqlDataRows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }



  // Retrieve all the action topics
  Future<List> getActionTopics() async {
    List bikeAddedList;
    List reviewPostedList; 

    reviewPostedList = await new Topic().getActionTopicEntries( topicName: "Review_posted");
    bikeAddedList = await new Topic().getActionTopicEntries( topicName: "Bike_added");

    List actionTopicList = [reviewPostedList, bikeAddedList].expand((x) => x).toList();
    actionTopicList.sort((a,b) => a['datetime'].compareTo(b['datetime']));
      
    return actionTopicList;
  }


  String getDuration({String datetime}) {

      String timeElapsed;

      DateTime dt = DateTime.parse(datetime);
      Duration duration = DateTime.now().difference(dt);
      if (duration.inHours >=24 ) {
        timeElapsed = "${duration.inDays}d";
      } else {
        timeElapsed = "${duration.inHours}h";

      }
      // print("days= ${duration.inDays}");
      // print("hrs = ${duration.inHours}");

      return timeElapsed;

  }



// ********** ACTION Methods

  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {
    print("tapped it");


              String topicName = 'Bike_added';
              //String topicName = 'Review_posted';

              String uid = 'zzzxxx';
              String displayName = "simon";
              String description = "intense primer medium ";


              new Topic().addActionTopicEntry( topicName: topicName, 
                      displayName: displayName, 
                      uid: uid, 
                      description: description);
            }


   }




} // end of class