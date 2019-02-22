import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/services/webservice.dart';
import 'package:bike_demo/utils/tools.dart';
import 'package:bike_demo/widgets/bikeaddwidget.dart';
import 'package:bike_demo/utils/notify.dart';
import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/chat/channelheader.dart';
import 'package:bike_demo/utils/user.dart';
import 'package:bike_demo/constants/globals.dart';
import 'package:bike_demo/services/locationservice.dart';



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
  Future<void> refreshScreen() async {

      _bodyWidget = new Tools().showProgressIndicator();

      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user!=null) {
          _uid = user.uid;
       }

      String whereClause = "'1=1'"; // We use this to display all the bikes initially
      selectBikes(whereClause: whereClause);
      
  }



  // Run the webservice and build the SQLData and set it to the bodyWidget
  Future<void> selectBikes({@required String whereClause }) async {

      // Let's get the location and send it along with the query
      Location location = await new LocationService().getGPSLocation();
      double latitude = location.latitude;
      double longitude = location.longitude;

      // Get the radius and unit from the user
      double radius = await new User().getRadius(uid: _uid);
      String units = await new User().getUnits(uid: _uid);
      if (radius==null || radius==0.0) radius = cRadius;
      if (units== null) units =cUnits;


    var payload = {
      'latitude':latitude, 
      'longitude':longitude,
      'radius':radius, 
      'units':units, 
      'whereClause':whereClause
      };

     new WebService().run(service: _service, jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

// TODO:  need to display something if no rows are found.  right now it just comes back 
// with a blank screen. 

          setState(() {
             _sqlDataRows = sqldata.rows;  // need to assign it, so we can identify which item is clicked
             _bodyWidget = buildListWidget( sqlDataRows: sqldata.rows, units: units);
          });

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

              // If it's a different user, don't return a dismissable object (ie user can only delete their own)
              if (sqlDataRows[index]['uid'] !=_uid) {

                return buildListItem(context: context, index: index, sqlDataRows: sqlDataRows, units: units);
              
              } else { // This listing was by the user so they can delete it, we return dismissible

                return Dismissible(
                  key: Key(index.toString()), 
                  background: Container(
                    color: Colors.red, 
                    padding: EdgeInsets.only(right: 20.0),
                    child: new Icon(Icons.delete, color: Colors.white,), 
                    alignment: Alignment.centerRight,),
                  onDismissed: (direction) {
                    setState(() {
                      deleteBike(index: index,  bikeID: sqlDataRows[index]['bike_id']);
                    });
                  },
                  child: buildListItem(context: context, index: index, sqlDataRows: sqlDataRows, units: units) ,
                );
              }
          
            } ,
          )
        );

  }


Widget buildListItem({BuildContext context, int index, List<dynamic> sqlDataRows, String units}) {

            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  ListTile( 

                  leading:  new User().getAvatar(
                          uid:sqlDataRows[index]['uid'],
                          imageName: sqlDataRows[index]['imageName'],
                          displayName: sqlDataRows[index]['displayName'],
                          imageSize: 50.0,
                          fontSize: baseFontSmaller,
                    ),

                    title: Text(sqlDataRows[index]['frameSize'] + ' - ' + sqlDataRows[index]['year'] + ' ' + sqlDataRows[index]['model'], style: TextStyle(fontSize: baseFont),),
                    subtitle: Text(sqlDataRows[index]['action'], style:new TextStyle(fontSize: baseFontSmaller)),
                    trailing: Text(sqlDataRows[index]['distance'] + ' ' + units , style: new TextStyle(fontSize: baseFontSmaller),),
                  ),

                  ListTile(
                    title: Text(sqlDataRows[index]['comments'], style: TextStyle(fontSize: baseFontSmaller),),
                    trailing: buildContactButton(index: index, context: context),
                  )

                ],
              ),
            );

}

 
Widget buildContactButton({BuildContext context, int index}) {

 if(_sqlDataRows[index]['uid'] == _uid) return SizedBox(height: 1, width: 1,); // same user, not need to chat with themselves
  else return  RaisedButton(
                           child: const Text('CONTACT', style: TextStyle( color: Colors.white),),
                           onPressed:()=>letsChat(context,index),
                           color: Colors.green[300],
                         );
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
          new User().addChannel( 
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
        }
    });

  }


    // used by notify on the calling object to refresh the screen after adding a bike
  void callback(Object obj) {
    refreshScreen();
  }
      
  // Remove bike from list and delete it from SQL DB
  void deleteBike({int index, String bikeID}) {

    _sqlDataRows.removeAt(index); // remove the item from the sqlrows, 

    // Call the delete bike service to delete the bike out of the SQL DB
    var payload = {
      'bike_id':bikeID,
      };

     new WebService().run(service: 'XdeleteBike.php', jsonPayload: payload).then((sqldata){

        if (sqldata.httpResponseCode == 200) {
         // Status code 200 indicates we had a succesful http call
        } else {
         // Something went wrong with the http call
          print("Http Error: ${sqldata.toString()}");
        }
     }).catchError((e) {
        print(" WebService error: $e");
     });

  }





} // end of class