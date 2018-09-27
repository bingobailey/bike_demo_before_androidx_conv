import 'package:flutter/material.dart';
import 'package:bike_demo/toolbox/topic.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class NotificationListWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _NotficationListWidgetState();
  }
}


class _NotficationListWidgetState extends State<NotificationListWidget> {


@override
  Widget build(BuildContext context) {
   

return new Scaffold(
      appBar: new AppBar( title: new Text("Notifications"), centerTitle: true,
      ),
      body: new Center(
         child:  new Text("hello")
      ),
    
    );


  }  // build method


  // For Testing...
  void addActionTopicEntry() {
  
    String topicName = 'Bike_added';
    //String topicName = 'Review_posted';

    String uid = 'XXXXdrrrrzxwxxzdd';
    String displayName = "stevie";
    String description = "Large Santa Cruz Hightower ";


    new Topic().addActionTopicEntry( topicName: topicName, 
            displayName: displayName, 
            uid: uid, 
            description: description);
  }

  void createAdTopic() {
    new Topic().createAdTopic();

  }


  Future<List> getActionTopics() async {
    List bikeAddedList;
    List reviewPostedList; 

    reviewPostedList = await new Topic().getActionTopicEntries( topicName: "Review_posted");
    bikeAddedList = await new Topic().getActionTopicEntries( topicName: "Bike_added");

    List actionTopicList = [reviewPostedList, bikeAddedList].expand((x) => x).toList();
    actionTopicList.sort((a,b) => a['datetime'].compareTo(b['datetime']));
      
    return actionTopicList;
  }



  // Using the SQL Data build the list widget
  Widget buildActionTopicListWidget({List<dynamic> actionTopics}) {

    return new Center(
          child: new ListView.builder(
            itemCount: actionTopics.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(actionTopics[index]['description']),
                subtitle: new Text(actionTopics[index]['displayName']),
                trailing: new Text(actionTopics[index]['datetime']),
               // leading: getImage( keystore: sqlDataRows[index]['photo_key_store'], image: sqlDataRows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }



  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {
      print("tapped it");

   }




  void getActionTopicEntries() {
    //String topicName = 'Bike_added';
    String topicName = 'Review_posted';

    DateTime now = DateTime.now();
   
    new Topic().getActionTopicEntries( topicName: topicName).then((List list) {

        print("items for $topicName");

        // The default order is ascending.  We need the latest dates (newer) at the top
        // so we need reverse the list
        List rList = list.reversed.toList();
        rList.forEach((item) {
          print("displayName= ${item['displayName']}");
          print("description= ${item['description']}");
          print("datetime= ${item['datetime']}");
          print("uid= ${item['uid']}");

          DateTime dt = DateTime.parse(item['datetime']);
          Duration duration = now.difference(dt);
          print("days= ${duration.inDays}");
          print("hrs = ${duration.inHours}");


        });


        


    });


  }





} // class