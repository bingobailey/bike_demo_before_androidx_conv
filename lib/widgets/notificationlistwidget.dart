import 'package:flutter/material.dart';
import 'package:bike_demo/toolbox/topic.dart';


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
         child:  new GestureDetector( child: new Text("click me"), onTap: addActionTopicEntry,)
      ),
    
    );


  }  // build method


  // For Testing...
  void addActionTopicEntry() {
  
    //String topicName = 'Bike_added';
    String topicName = 'Review_posted';

    String uid = 'WzZx34drrrrzxwxxzdd';
    String displayName = "chuppy";
    String description = "nice review on Orbea";


    new Topic().addActionTopicEntry( topicName: topicName, 
            displayName: displayName, 
            uid: uid, 
            description: description);
  }

  void createAdTopic() {
    new Topic().createAdTopic();

  }


  void getActionTopicEntries() {
    //String topicName = 'Bike_added';
    String topicName = 'Review_posted';

    new Topic().getActionTopicEntries( topicName: topicName);


  }





} // class