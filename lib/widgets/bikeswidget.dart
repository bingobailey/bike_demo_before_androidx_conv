import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/tools.dart';

class BikesWidget extends StatefulWidget {

  @override
    State<StatefulWidget> createState() {
      return new _BikesWidgetState();
    }

}


class _BikesWidgetState extends State<BikesWidget>  with SingleTickerProviderStateMixin {

  SearchBar searchBar;

 // Webservice attributes
  String _service = 'XselectBikes.php';
  List _sqlDataRows; // rows retrieved from query. must store it toaccess the correct row when user clicks onitem

// We use this widget to switch out the progress indicator
  Widget _bodyWidget; 


  @override
    void initState() {
      super.initState();

      _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");

      String whereClause = "status = 'WTD'";
      selectBikes( service: _service, whereClause: whereClause);
    }

  // Constructor 
  _BikesWidgetState() {
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
        onPressed: _onClickedAdd,
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

    //var whereClause = "status = 'WTD' AND description LIKE '%dev%'";
    var payload = {'latitude':'-35.305', 'longitude':'149.114','radius':'13700', 'units':'km', 'whereClause':whereClause};

     new WebService().run(service: service, jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

          print("sqldata = ${sqldata.toString()}");

          setState(() {
             _sqlDataRows = sqldata.rows;  // need to assign it, so we can identify which item is clicked
             _bodyWidget = buildListWidget( sqlDataRows: sqldata.rows);
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
  Widget buildListWidget({List<dynamic> sqlDataRows}) {

    return new Center(
          child: new ListView.builder(
            itemCount: sqlDataRows.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(sqlDataRows[index]['description']),
                subtitle: new Text(sqlDataRows[index]['frame_size']),
             //   leading: getImage( uid: sqlDataRows[index]['uid'], image: sqlDataRows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }


// Get the image associated with the user( ie their avatar )
  Widget getImage({String uid, String image}) {

    String imageURL = "http://www.mtbphotoz.com/prod/Photo/" + uid + "/" + image;

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

void _onClickedAdd() {
  print("add clicked");

}


  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

    print(_sqlDataRows[index].toString());

    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context)=>new MemberProfilePage( member: _sqlDataRows[index],),
    // ));
  }






} // end of class