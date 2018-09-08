import 'package:flutter/material.dart';
import '../chat/chatwidget.dart';
import '../toolbox/uitools.dart';

/*
chuppy  wV9aWBbmHgUySap10e1qgJrLMbv2    chuppy@gmail.com  aaaaaaaaa

Stevie  ZgrSJsAjeVeA8i11QPmGcse0k0h2     stevie@gmail.com  aaaaaaaaa

simonthetiger   Vx2GCPPs7AbnXb8hk8UTzo22UOw1   simon@yahoo.com   aaaaaaaaa
*/






class ListChatWidget extends StatefulWidget {

@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ListChatWidgetState();
  }

}


class _ListChatWidgetState extends State<ListChatWidget> {


  List chatList =["channelone", "channeltwo", "channelthree", "channelfour"];
  List _sqlDataRows; // rows retrieved from query. must store it toaccess the correct row when user clicks onitem
 
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
      buildSQLData();




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
  void buildSQLData() {
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


// ********** ACTION Methods



  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

    print("on tap hit");

  //   Navigator.push(context, MaterialPageRoute(
  //     builder: (context)=>new ChatWidget( channelID: sqlros,),
  //   ));

     Navigator.push(context, MaterialPageRoute(
       builder: (context)=>new ChatWidget( member: _sqlDataRows[index],),
     ));

   }




} // end of class