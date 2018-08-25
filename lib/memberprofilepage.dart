import 'package:flutter/material.dart';

class MemberProfilePage extends StatefulWidget {

    // attributed passed in
    final Map<String,dynamic> member;
    
    // constructor
    MemberProfilePage({this.member});

    @override
      State<StatefulWidget> createState() {
        return new MemberProfilePageState();
      }
}



class MemberProfilePageState extends State<MemberProfilePage> {

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Scaffold(
         appBar: new AppBar( title: new Text(widget.member['username']),),
          body: new Center( child: Text(widget.member.toString())),
      );
    }


}