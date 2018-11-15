import 'package:flutter/material.dart';
import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/toolbox/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatListWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    return new _ChatListWidgetState();
  }

}


class _ChatListWidgetState extends State<ChatListWidget> {
 
  List _channels; 
  
  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 
  String currentUserDisplayName;

  @override
    void initState() {
      super.initState();

      FirebaseAuth.instance.currentUser().then((FirebaseUser fbuser) {
        if (fbuser !=null) {
          _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");
           new User().getChannelList(uid: fbuser.uid).then((List channels){
            _channels = channels; // We store it so we can access it when  user clicks
            setState(() {
              _bodyWidget = buildChannelListWidget( channels: channels );
            });
          });
        } else {
            setState(() {
             _bodyWidget = new Text("not logged in");
            });
        }
      });

    }



// *********** BUILD methods

  @override
    Widget build(BuildContext context) {

      return new Scaffold(
      appBar: new AppBar( title: new Text("Chat List"), centerTitle: true,
      ),
      body: new Center(
         child: _bodyWidget,
      ),
     
    );
  }


// TODO: need to get leading: image. see below

  // Using the SQL Data build the list widget
  Widget buildChannelListWidget({List<dynamic> channels}) {

    return new Center(
          child: new ListView.builder(
            itemCount: channels.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                 title: new Text(channels[index]['title']),
                subtitle: new Text(channels[index]['toDisplayName']),
                trailing: new Text(new Tools().getDuration(datetime:channels[index]['datetime'])),
               // leading: getImage( keystore: sqlDataRows[index]['uid'], image: sqlDataRows[index]['photo']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }




// ********** ACTION Methods

  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {
     Navigator.push(context, MaterialPageRoute(
       builder: (context)=>new ChatWidget( channel: _channels[index],
       currentUserDisplayName:currentUserDisplayName,),
     ));

   }



} // end of class