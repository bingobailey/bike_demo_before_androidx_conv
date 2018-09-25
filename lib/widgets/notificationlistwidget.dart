import 'package:flutter/material.dart';


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
         child: new Text("notifications"),
      ),
    
    );


  }  // build method


} // class