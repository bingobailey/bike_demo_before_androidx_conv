import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/chat/channelheader.dart';
import 'package:bike_demo/utils/tools.dart';
import 'package:bike_demo/utils/user.dart';
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
          _bodyWidget = new Tools().showProgressIndicator();
           new User().getChannelList(uid: fbuser.uid).then((List channels){
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


  // Using the SQL Data build the list widget
  Widget buildChannelListWidget({List<dynamic> channels}) {

    return new Center(
          child: new ListView.builder(
            itemCount: channels.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                 contentPadding: EdgeInsets.fromLTRB(25.0, 10.0, 20.0, 10.0) ,
                 title: new Text(channels[index]['frameSize'] + ' - ' + channels[index]['year'] + ' ' +  channels[index]['model'], style: TextStyle(fontSize: baseFont,)),
                //subtitle: new Text(channels[index]['displayName'],style: TextStyle(fontSize: baseFontSmaller),), 
                trailing: Row(children: <Widget>[
                            new Text(new Tools().getDuration(utcDatetime:channels[index]['datetime']),
                                 style: TextStyle(fontSize: baseFontSmaller),   ),
                            new Icon(Icons.chevron_right),
                ],
                mainAxisSize:MainAxisSize.min ,
                ),         
                leading: new User().getAvatar(
                          uid:channels[index]['uid'],
                          imageName: channels[index]['imageName'],
                          displayName: channels[index]['displayName'],
                          imageSize: 40.0,
                          fontSize: baseFontSmaller,
                      ),
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
                                  channelID: _channels[index]['channelID'],
                                      title: _channels[index]['frameSize'] + ' - ' + _channels[index]['year'] + ' ' +  _channels[index]['model'], 
                                displayName: _currentUserDisplayName);

     Navigator.push(context, MaterialPageRoute(
       builder: (context)=>new ChatWidget( channelHeader:channelHeader,),
     ));

    }



} // end of class