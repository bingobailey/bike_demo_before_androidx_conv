import 'package:flutter/material.dart';


class AccountProfileWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _AccountProfileWidgetState();
  }


}


class _AccountProfileWidgetState extends State<AccountProfileWidget> {


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