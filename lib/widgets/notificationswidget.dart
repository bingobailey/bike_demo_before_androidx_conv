import 'package:flutter/material.dart';


class NotificationsWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _NotficationsWidgetState();
  }
}


class _NotficationsWidgetState extends State<NotificationsWidget> {


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