import 'package:flutter/material.dart';
import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/toolbox/uitools.dart';
import 'package:bike_demo/toolbox/currentuser.dart';

/*
chuppy  wV9aWBbmHgUySap10e1qgJrLMbv2    chuppy@gmail.com  aaaaaaaaa

Stevie  ZgrSJsAjeVeA8i11QPmGcse0k0h2     stevie@gmail.com  aaaaaaaaa

simonthetiger   Vx2GCPPs7AbnXb8hk8UTzo22UOw1   simon@yahoo.com   aaaaaaaaa
*/




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

      // Only show list if logged in
      if (CurrentUser.getInstance().isAuthenticated()) {
        _bodyWidget = new UITools().showProgressIndicator( title: "Loading...");
        CurrentUser.getInstance().getChannelList().then((List channels){
          _channels = channels; // We store it so we can access it when  user clicks
          setState(() {
            _bodyWidget = buildChannelListWidget( channels: channels );
          });

        });
      } else {
        _bodyWidget = new Text("not logged in");
      }
    


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



  // Using the SQL Data build the list widget
  Widget buildChannelListWidget({List<dynamic> channels}) {

    return new Center(
          child: new ListView.builder(
            itemCount: channels.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(channels[index]['chateeDisplayName']),
                subtitle: new Text(channels[index]['title']),
                trailing: new Text(channels[index]['datetime']),
               // leading: getImage( keystore: sqlDataRows[index]['photo_key_store'], image: sqlDataRows[index]['photo_profile_name']),
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