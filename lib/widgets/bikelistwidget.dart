import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/toolbox/account.dart';
import 'package:bike_demo/widgets/bikeaddwidget.dart';
import 'package:bike_demo/toolbox/notify.dart';
import 'package:bike_demo/chat/chatwidget.dart';
import 'package:bike_demo/toolbox/user.dart';


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

AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Center( child: new Text('Bikes Wanted !',)),
      actions: [searchBar.getSearchAction(context)]
    );
  }  


  void refreshScreen() {

      // get the location
      SharedPreferences.getInstance().then((prefs) {
          double latitude = prefs.getDouble('latitude');
          double longitude = prefs.getDouble('longitude');

// TODO: if latitude and longitude are null, might need to re-arrange this and call
//       geolocation here
          String whereClause = "status = 'WTD'"; 
          selectBikes( service: _service, whereClause: whereClause, latitude: latitude, longitude: longitude);
      });

      _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");

  }



  // Run the webservice and build the SQLData and set it to the bodyWidget
  void selectBikes({String service, String whereClause, double latitude, double longitude}) {

    // TODO: radius should not be hardcoded here.  set by user parms
    double radius = 25.0;

    // TODO:  units should not be hardcoded here.  set by parms
    //        acceptable values:  km   or  m   

    String units = 'm';

    //var whereClause = "status = 'WTD' AND description LIKE '%dev%'";
    var payload = {'latitude':latitude, 'longitude':longitude,'radius':radius, 'units':units, 'whereClause':whereClause};

     new WebService().run(service: service, jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

          //print("sqldata = ${sqldata.toString()}");

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
                title:  Text(sqlDataRows[index]['description']),
                subtitle:  Text(sqlDataRows[index]['frame_size']),
                trailing: new Text(sqlDataRows[index]['distance'] + units),
                leading: getImage( uid: sqlDataRows[index]['uid'], image: sqlDataRows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }

// TODO: Need to retrieve the proper image for each user

// Get the image associated with the user( ie their avatar )
  Widget getImage({String uid, String image}) {

    image = 'elf.jpg';

    String imageURL = "http://www.mtbphotoz.com/bikedemo/photos/" + uid + "/" + image;

      return new SizedBox( 
        child: Image.network(imageURL),
         height: 60.0,
          width: 60.0,
        );
  }





// *** ACTION METHODS ****

void _onSubmittedSearch(String value) {
  String whereClause = "status = 'WTD' AND description LIKE '%$value%'";
  selectBikes( service: _service, whereClause: whereClause);
}

void _onClickedAdd(BuildContext context) {

     FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (user ==null) { // not logged in
          new Account().showAccountAccess( context: context, title: "To add a bike you have to be logged in");
        } else {
          // Display the add bike widget ..
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>new BikeAddWidget(this),
          ));
        }
      });




  }


  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

    print(_sqlDataRows[index].toString());



     FirebaseAuth.instance.currentUser().then((FirebaseUser fbuser) {
        if (fbuser ==null) { // not logged in
          new Account().showAccountAccess( context: context, title: "Must be signed in to contact user");
        } else { // user is logged in, continue

          // Get the user displayname that needs to be contacted, then add the channel
          new User().getDisplayName(uid: _sqlDataRows[index]['uid']).then((String toDisplayName) {
          new User().addChannel( signedInUID: fbuser.uid,
                    title: _sqlDataRows[index]['description'],
                    toDisplayName: toDisplayName,
                    toUID: _sqlDataRows[index]['uid'],
              );
          });

          // TODO: should have a cleaner way than to reproduce creating the channel again here
            String channelID = fbuser.uid + "_"  +  _sqlDataRows[index]['uid'];
            Map<dynamic,dynamic> channel = new Map();
            channel['channelID'] = channelID;
            channel['title'] = _sqlDataRows[index]['description'];
            print("channelid = ${channel['channelID']}");

            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>new ChatWidget( channel: channel,
                currentUserDisplayName: fbuser.displayName,),
              ));
        }
    });

  }


 void callback(Object obj) {
   refreshScreen();
 }
      
      
    




} // end of class