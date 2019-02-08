import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/chat/channelheader.dart';
import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/services/firebaseservice.dart';
import 'package:bike_demo/constants/globals.dart';


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
  String _currentUserDisplayName;

  @override
    void initState() {
      super.initState();

      FirebaseAuth.instance.currentUser().then((FirebaseUser fbuser) {
        if (fbuser !=null) {

          _currentUserDisplayName = fbuser.displayName;
          _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");
           new FireBaseService().getChannelList(uid: fbuser.uid).then((List channels){
             _channels = channels; // We need to assign this so we can detect the user selection
            setState(() {
              _bodyWidget = buildChannelListWidget( channels: _channels );
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
      appBar: new AppBar( title: new Text("Messages", style: TextStyle( fontSize: baseFontLarger),), centerTitle: true,
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
                 title: new Text(channels[index]['frame_size'] + ' - ' + channels[index]['year'] + ' ' +  channels[index]['model'], style: TextStyle(fontSize: baseFont,)),
                subtitle: new Text(channels[index]['username'],style: TextStyle(fontSize: baseFontSmaller),), // new Text(channels[index]['toDisplayName']),
                trailing: new Text(new Tools().getDuration(UTCdatetime:channels[index]['datetime']),
                                style: TextStyle(fontSize: baseFontSmaller),   ),
               // leading: getImage( keystore: channels[index]['uid'], image: channels[index]['photoName']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );  

  }



// ********** ACTION Methods

  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

    // We create the channel header and pass it on...
  
    ChannelHeader channelHeader = new ChannelHeader(
                                  channelID: _channels[index]['channel_id'],
                                      title: _channels[index]['frame_size'] + ' - ' + _channels[index]['year'] + ' ' +  _channels[index]['model'], 
                                displayName: _currentUserDisplayName);

     Navigator.push(context, MaterialPageRoute(
       builder: (context)=>new ChatWidget( channelHeader:channelHeader,),
     ));

    }



} // end of class