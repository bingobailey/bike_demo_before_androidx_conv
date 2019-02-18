import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/constants/globals.dart';
import 'package:bike_demo/utils/user.dart';

import 'package:bike_demo/utils/topic.dart';

class UserProfileWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _UserProfileWidgetState();
  }
}


class _UserProfileWidgetState extends State<UserProfileWidget> {


@override
  void initState() {
    super.initState();

  // TODO:  Testing purposes only 

  String uid = "l2DAcHjx79VfwWfZyM4IUUjMKs72";

     new Topic().getTopicList().then((List list){
      
      print('topiclist = $list');
    });

    //new Topic().addNotification(uid: uid, content: 'my context', displayName: 'bingo baily', photoURL: 'kurlphoto', topic: 'advertisement', websiteURL: 'myurl.com');

  
    // new FirebaseService().setProperty(rootDir: "users/$uid", propertyName: 'displayName', propertyValue: 'chuppy');

    // new FirebaseService().getProperty(rootDir: "users/$uid", propertyName: 'displayName').then((dynamic name) {
    //   print("name = $name");
    // });

    // Map property =Map<String,dynamic>(); 
    // property.putIfAbsent('bikeAdded', ()=>true);
    // property.putIfAbsent('advertisement', ()=>false);
    
    //new User().unsubscribeFromTopic(uid: uid, topic: 'advertisement');
    //new User().unsubscribeFromTopic(uid: uid, topic: 'bikeAdded');

    new User().subscribeToTopic(uid: uid, topic: 'advertisement');


    new User().getTopicsSubscribed(uid:uid).then(( List list) {
      print("unsubs topics = $list");

    });


     //new FirebaseService().setProperty(rootDir: "users/$uid",  propertyName: 'topics', propertyValue:property);

    //new FirebaseService().removeProperty(rootDir: "users/$uid/topics", propertyName: 'advertisement' );

    //new FirebaseService().removeNode(rootDir: "users/$uid", node: 'topics');

    // new FirebaseService().getKeys(rootDir: "topics").then((List list) {
    //   print("key list = $list");
    // });

    // new FirebaseService().getProperty(rootDir: 'users/$uid', propertyName: 'topics').then((dynamic value) {
    //   print("value = $value");

    // });


    // new FirebaseService().getProperties(rootDir: "users/$uid/topics").then((List list){
    //   list.forEach((item){
    //     print("item = $item");
    //   });

    


    //new User().setSubscribedTopics(uid:uid, topicList: list );




  }



@override
  Widget build(BuildContext context) {
   
    return new Scaffold(
          appBar: new AppBar( title: new Text('Account',style:TextStyle(fontSize:baseFontLarger),), centerTitle: true,
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