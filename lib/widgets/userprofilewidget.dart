import 'package:flutter/material.dart';


class UserProfileWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _UserProfileWidgetState();
  }


}


class _UserProfileWidgetState extends State<UserProfileWidget> {


@override
  Widget build(BuildContext context) {
   

return new Scaffold(
      appBar: new AppBar( title: new Text("Account Profile"), centerTitle: true,
      ),
      body: new Center(
         child: new Text("Account Profile"),
      ),
    
    );


  }  // build method


} // class