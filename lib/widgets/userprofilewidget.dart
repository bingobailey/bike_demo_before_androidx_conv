import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
    return new RaisedButton(child: new Text("sign out"), onPressed: _signOut,);
   
  }


  void _signOut() {
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user !=null) {
          print("user signing out");
          FirebaseAuth.instance.signOut();
        } else {
          print("user not signed in");
        }
      });

  }


} // class