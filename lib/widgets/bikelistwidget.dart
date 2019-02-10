import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bike_demo/services/webservice.dart';
import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/widgets/bikeaddwidget.dart';
import 'package:bike_demo/toolbox/notify.dart';
import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/chat/channelheader.dart';
import 'package:bike_demo/services/firebaseservice.dart';
import 'package:bike_demo/constants/globals.dart';



class BikeListWidget extends StatefulWidget {
 
  @override
    State<StatefulWidget> createState() {
      return new _BikeListWidgetState();
    }

}


class _BikeListWidgetState extends State<BikeListWidget>  with SingleTickerProviderStateMixin implements Notify {

  SearchBar searchBar;

 // Webservice attributes
  String _service = 'XselectBikes.php';
  List _sqlDataRows; // rows retrieved from query. must store it toaccess the correct row when user clicks onitem
  String _uid;

  double _latitude;
  double _longitude; 

// We use this widget to switch out the progress indicator
  Widget _bodyWidget; 

  @override
    void initState() {
      super.initState();
      refreshScreen();
    }


  // Constructor 
  _BikeListWidgetState() {
    searchBar = new SearchBar(
          inBar: false,
          setState: setState,
          onSubmitted: _onSubmittedSearch,
          buildDefaultAppBar: buildAppBar,
          onClosed: () {
            print("closed");
          }
        );

  }


  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: searchBar.build(context) ,
        body: new Center(
         child: _bodyWidget,
        ),
          floatingActionButton: new FloatingActionButton(
          tooltip: 'Add a bike', // used by assistive technologies
          child: Icon(Icons.add),
          onPressed: ()=>_onClickedAdd(context),
        ),
      );

    } // build method


// build the app bar with the search capability
AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Center( child: new Text('Bikes', style: TextStyle(fontSize: baseFontLarger),)),
      actions: [searchBar.getSearchAction(context)]
    );
  }  



// Refresh the screen, get user logged in, preferences, build where clause.  its called at 
// beginning of program and after a bike has been added
  void refreshScreen() {

    // assign the uid to the user logged in
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user!=null) {
          _uid = user.uid;
        }
      });

      // get the location
        SharedPreferences.getInstance().then((prefs) {
          _latitude = prefs.getDouble('latitude');
          _longitude = prefs.getDouble('longitude');



// TODO: if latitude and longitude are null, might need to re-arrange this and call
//       geolocation here
          String whereClause = "'1=1'"; // We use this to display all the bikes initially
          selectBikes(whereClause: whereClause);
      });

      _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");
  }



  // Run the webservice and build the SQLData and set it to the bodyWidget
  void selectBikes({@required String whereClause }) {

    // TODO: radius should not be hardcoded here.  set by user parms
    double radius = 25.0;

    // TODO:  units should not be hardcoded here.  set by parms
    //        acceptable values:  km   or  m   

    String units = 'm';

    var payload = {
      'latitude':_latitude, 
      'longitude':_longitude,
      'radius':radius, 
      'units':units, 
      'whereClause':whereClause
      };

     new WebService().run(service: _service, jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

          print("sqldata = ${sqldata.toString()}");

// TODO:  need to display something if no rows are found.  right now it just comes back 
// with a blank screen. 

          setState(() {
             _sqlDataRows = sqldata.rows;  // need to assign it, so we can identify which item is clicked
             _bodyWidget = buildListWidget( sqlDataRows: sqldata.rows, units: units);
          });
        
           for (var row in sqldata.rows) {
             print(row.toString());
           }

        // Something went wrong with the http call
        } else {
          print("Http Error: ${sqldata.toString()}");
        }

     }).catchError((e) {
        print(" WebService error: $e");
     });

  } 



  // Using the SQL Data build the list widget
  Widget buildListWidget({List<dynamic> sqlDataRows, String units}) {

    return new Center(
          child: new ListView.builder(
            itemCount: sqlDataRows.length,
            itemBuilder:(BuildContext context, int index) {
              return  ListTile(
                title:  Text(sqlDataRows[index]['frame_size'] + ' - ' + sqlDataRows[index]['year'] + ' ' + sqlDataRows[index]['model'] + '\n' + sqlDataRows[index]['action'], style: new TextStyle(fontSize: baseFont),),
                subtitle:  Text(sqlDataRows[index]['comments'], style:new TextStyle(fontSize: baseFontSmaller)),
                leading: new Text(sqlDataRows[index]['distance'] + units , style: new TextStyle(fontSize: baseFontSmaller),),
                trailing: buildChatIcon(context: context, index: index), 
                isThreeLine:true,
              );
            } ,
          )
        );

  }



Widget buildChatIcon({BuildContext context, int index}) {
  if(_sqlDataRows[index]['uid'] == _uid) return null; // same user, not need to chat with themselves
  else return new IconButton(icon: new Icon(Icons.chat, size: 40.0, color: Colors.green,), onPressed:()=>letsChat(context,index), );
}


// *** ACTION METHODS ****

void _onSubmittedSearch(String value) {
  String whereClause = "model LIKE '%$value%'";
  selectBikes(whereClause: whereClause);
}

void _onClickedAdd(BuildContext context) {

     FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user ==null) { // not logged in
          new Tools().showAccountAccess( context: context, title: "To add a bike you have to be logged in");
        } else {
          // Display the add bike widget ..
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>new BikeAddWidget(this),
          ));
        }
      });
  }


// Open the chat if user is logged in
  void letsChat(BuildContext context, int index) {
   
     FirebaseAuth.instance.currentUser().then((FirebaseUser fbuser) {
        if (fbuser ==null) { // not logged in
          new Tools().showAccountAccess( context: context, title: "Must be signed in to contact user");
        } else { // user is logged in, continue


          // Add the channel to SQL DB
          new FireBaseService().addChannel( 
                    signedInUID: fbuser.uid,
                    bikeID: _sqlDataRows[index]['bike_id'],
                    toUID: _sqlDataRows[index]['uid'],
              ).then((Map<String,dynamic> result) {
                print('sqlmessage from addchannel ${result['msg']}');

                // If we got true, then we added the channel successfully, where channel_id will be returned in result
                if (result['status']==true) {
                    
                      // Create the channelheader and pass it on to chat widget
                      ChannelHeader channelHeader = new ChannelHeader(
                                                channelID: result['channel_id'],
                                                    title: _sqlDataRows[index]['frame_size'] + ' - ' + _sqlDataRows[index]['year'] + ' ' +  _sqlDataRows[index]['model'], 
                                              displayName: fbuser.displayName);

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>new ChatWidget( channelHeader: channelHeader),
                      ));
                }

                
              });


            // // Create the channel_ID and pass it to the chat widget so discussion can begin
            // String channelID = fbuser.uid + "_"  +  _sqlDataRows[index]['uid'] + '_' + _sqlDataRows[index]['bike_id'];
            // Map<dynamic,dynamic> channel = new Map();
            // channel['channel_id'] = channelID;
            // channel['title'] = _sqlDataRows[index]['model'];
            
           
        }
    });

  }


    // used by notify on the calling object to refresh the screen after adding a bike
  void callback(Object obj) {
    refreshScreen();
  }
      
      


} // end of class