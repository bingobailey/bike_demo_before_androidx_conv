import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/constants/globals.dart';
import 'package:bike_demo/services/webservice.dart';
import 'package:bike_demo/utils/user.dart';
import 'package:bike_demo/utils/topic.dart';
import 'package:bike_demo/services/imageservice.dart';

class UserProfileWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _UserProfileWidgetState();
  }
}


class _UserProfileWidgetState extends State<UserProfileWidget> {


  String _displayName;
  String _imageName;
  String _email;
  String _uid;



@override
  void initState() {
    super.initState();

    new User().getCurrentUser().then((FirebaseUser fbuser) {
      if (fbuser !=null) {
        selectUser(uid: fbuser.uid);
      }
    });

  }




@override
  Widget build(BuildContext context) {
   
    return new Scaffold(
          appBar: new AppBar( title: new Text('Account',style:TextStyle(fontSize:baseFontLarger),), centerTitle: true,
          ),
          body: new Center(
            child: buildUserProfileWidget(),
          ),
        );


  }  // build method



  Widget buildUserProfileWidget() {

    return Container(child: Column(children: <Widget>[

      buildAvatar(uid: _uid, imageName: _imageName, displayName: _displayName),


        ],
    
      ),
    
    );



    return new RaisedButton(child: new Text("sign out"), onPressed: _signOut,);
   
  }


  Widget buildAvatar({String uid, String imageName, String displayName}) {

    return new User().getAvatar(uid: uid, imageName: imageName, displayName: displayName);

  }



  Future<void> selectUser({String uid}) async {

    var payload = {
      'uid':uid
      };

     new WebService().run(service: 'XselectUser.php', jsonPayload: payload).then((sqldata){

        if (sqldata.httpResponseCode == 200) {
          // Status code 200 indicates we had a succesful http call

          setState(() {
            // Only one row is returned for the user, so we get can use the index [0]
            _email = sqldata.rows[0]['email'];
            _displayName = sqldata.rows[0]['displayName'];
            _imageName = sqldata.rows[0]['imageName'];
            _uid =sqldata.rows[0]['uid'];            
          });

        } else {
          // Something went wrong with the http call
          print("Http Error: ${sqldata.toString()}");
        }

     }).catchError((e) {
        print(" WebService error: $e");
     });



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