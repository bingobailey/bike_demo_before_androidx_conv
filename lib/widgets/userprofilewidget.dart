import 'package:flutter/material.dart';
import 'package:bike_demo/toolbox/currentuser.dart';


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
          appBar: new AppBar( title: new Text('Account'), centerTitle: true,
          ),
          body: new Center(
            child: _buildDisplayWidget(),
          ),
        
        );


  }  // build method



  Widget _buildDisplayWidget() {

    return new Text("acount work needed here");
   
  }



} // class