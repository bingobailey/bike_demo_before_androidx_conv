import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/toolbox/account.dart';
import 'package:bike_demo/widgets/bikeaddwidget.dart';

class BikeListWidget extends StatefulWidget {
 
  @override
    State<StatefulWidget> createState() {
      return new _BikeListWidgetState();
    }

}


class _BikeListWidgetState extends State<BikeListWidget>  with SingleTickerProviderStateMixin {

  SearchBar searchBar;
  double _latitude;
  double _longitude;

 // Webservice attributes
  String _service = 'XselectBikes.php';
  List _sqlDataRows; // rows retrieved from query. must store it toaccess the correct row when user clicks onitem

// We use this widget to switch out the progress indicator
  Widget _bodyWidget; 


  @override
    void initState() {
      super.initState();

      // get the location
      SharedPreferences.getInstance().then((prefs) {
          _latitude = prefs.getDouble('latitude');
          _longitude = prefs.getDouble('longitude');

// TODO: if latitude and longitude are null, might need to re-arrange this and call
//       geolocation here

           String whereClause = "status = 'WTD'";
          selectBikes( service: _service, whereClause: whereClause);
      });

      _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");

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



  // Run the webservice and build the SQLData and set it to the bodyWidget
  void selectBikes({String service, String whereClause}) {


    // TODO: radius should not be hardcoded here

    //var whereClause = "status = 'WTD' AND description LIKE '%dev%'";
    var payload = {'latitude':_latitude, 'longitude':_longitude,'radius':'13700', 'units':'km', 'whereClause':whereClause};

     new WebService().run(service: service, jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

          print("sqldata = ${sqldata.toString()}");

          setState(() {
             _sqlDataRows = sqldata.rows;  // need to assign it, so we can identify which item is clicked
             _bodyWidget = buildListWidget( sqlDataRows: sqldata.rows);
          });
        
          // for (var row in sqldata.rows) {
          //   print(row.toString());
          // }

        // Something went wrong with the http call
        } else {
          print("Http Error: ${sqldata.toString()}");
        }

     }).catchError((e) {
        print(" WebService error: $e");
     });

  } 



  // Using the SQL Data build the list widget
  Widget buildListWidget({List<dynamic> sqlDataRows}) {

    return new Center(
          child: new ListView.builder(
            itemCount: sqlDataRows.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(sqlDataRows[index]['description']),
                subtitle: new Text(sqlDataRows[index]['frame_size']),
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
            builder: (context)=>new BikeAddWidget(),
          ));
        }
      });

  }


  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

    print(_sqlDataRows[index].toString());

    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context)=>new MemberProfilePage( member: _sqlDataRows[index],),
    // ));
  }






} // end of class