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
  
    //String topicName = 'Bike added';
    String topicName = 'Review_posted';

    String uid = 'zzzzz3zxwxxzdd';
    String displayName = 'fast biker again';
    String description = "just posted review on yeti 575";


    new Topic().addActionTopicEntry( topicName: topicName, 
            displayName: displayName, 
            uid: uid, 
            description: description);
  }

  void createAdTopic() {
    new Topic().createAdTopic();

  }


  void getActionTopicEntries() {
    //String topicName = 'Bike added';
    String topicName = 'Review posted';

    new Topic().getActionTopicEntries( topicName: topicName);


  }





} // class