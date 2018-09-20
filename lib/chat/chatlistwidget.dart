import 'package:flutter/material.dart';
import '../chat/chatwidget.dart';
import '../toolbox/uitools.dart';
import '../toolbox//user.dart';

/*
chuppy  wV9aWBbmHgUySap10e1qgJrLMbv2    chuppy@gmail.com  aaaaaaaaa

Stevie  ZgrSJsAjeVeA8i11QPmGcse0k0h2     stevie@gmail.com  aaaaaaaaa

simonthetiger   Vx2GCPPs7AbnXb8hk8UTzo22UOw1   simon@yahoo.com   aaaaaaaaa
*/




class ChatListWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ChatListWidgetState();
  }

}


class _ChatListWidgetState extends State<ChatListWidget> {

  List _sqlDataRows; // rows retrieved from query. must store it toaccess the correct row when user clicks onitem
 
  List _channels; 

  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 


  @override
    void initState() {
      // TODO: implement initState
      super.initState();

      // We build the sql rows as JSON here for testing.  This will ultimately be retrieved through webservice
      // and should match the format
      _sqlDataRows = [

          {
            'channelID':"channelone",
            'username': "chuppy",
            'email': "psimoj@gmail.com",
            'bike' : 'transition sentintal', 
            'time' : '2 hrs ago',
          },

          {
            'channelID':"channeltwo",
            'username': "stevie",
            'email': "stevie@gmail.com",
            'bike' : 'ibis ripmo',
            'time' : '1 week ago',
          },

          {
            'channelID':"channelthree",
            'username': "chuppy",
            'email': "simonthetiger@yahoo.com",
            'bike' : 'yeti sb 150',
            'time' : '1 hr ago',
          },

      ];

     _bodyWidget = new UITools().showProgressIndicator( title: "Loading...");
      
      String uid = "wV9aWBbmHgUySap10e1qgJrLMbv2"; // current user logged in 

      User user = new User(  uid: uid );
      user.getChannelList().then((List channels){
        _channels = channels; // We store it so we can access it when  user clicks
        setState(() {
          _bodyWidget = buildChannelListWidget( channels: channels);
        });

      });


     // runSQLQuery();

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

// Run the webservice and build the SQLData and set it to the bodyWidget
  void runSQLQuery() {
      // here we would execute webservice call .  for now we just load it the model

       _bodyWidget = buildListWidget( sqlDataRows: _sqlDataRows);

  }


  // Using the SQL Data build the list widget
  Widget buildListWidget({List<dynamic> sqlDataRows}) {

    return new Center(
          child: new ListView.builder(
            itemCount: sqlDataRows.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(sqlDataRows[index]['username']),
                subtitle: new Text(sqlDataRows[index]['bike']),
                trailing: new Text(sqlDataRows[index]['time']),
               // leading: getImage( keystore: sqlDataRows[index]['photo_key_store'], image: sqlDataRows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
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
       builder: (context)=>new ChatWidget( channel: _channels[index],),
     ));

   }




} // end of class