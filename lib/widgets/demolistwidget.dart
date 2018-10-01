import 'package:flutter/material.dart';

import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/tools.dart';
import 'package:bike_demo/memberprofilepage.dart';


class DemoListWidget extends StatefulWidget {
 
  @override
  _DemoListWidgetState createState() => new _DemoListWidgetState();
}

// We make the DemoListWidgetState private so it doesnt' pop up as a code suggestion
// When using the IDE.  You would use DemoListWidget, not DemoListWidgetState in other programs.
class _DemoListWidgetState extends State<DemoListWidget> {
  
  // Webservice attributes
  String wsLocation;
  WebService ws; 
  List _sqlDataRows; // rows retrieved from query. must store it toaccess the correct row when user clicks onitem

  // We use this widget to switch out the progress indicator
  Widget _bodyWidget; 


  @override
    void initState() {
      super.initState();
       

print("inside demolistwidget initstate");

      // Instantiate the webservice
      //wsLocation = "http://www.mtbphotoz.com/prod/PHP/";
      wsLocation = "http://www.mtbphotoz.com/bikedemo/php/";
      ws = new WebService(wsLocation: wsLocation); 

      _bodyWidget = new Tools().showProgressIndicator( title: "Loading...");
      runSQLQuery();
    }


  @override
  Widget build(BuildContext context) {
   
    return new Scaffold(
      appBar: new AppBar( title: new Text("Bikes Wanted For Demo"), centerTitle: true,
      ),
      body: new Center(
         child: _bodyWidget,
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add a bike', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: _onClickedAdd,
      ), 

    );
  }


  // Run the webservice and build the SQLData and set it to the bodyWidget
  void runSQLQuery() {
    
    // Select all the members
     var payload = {"requestor":"JoeBiker"};
     //ws.run( service: "XselectMembersAll.php", jsonPayload: payload);

     ws.run(service: "XselectMembersAll.php", jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

          setState(() {
             _sqlDataRows = sqldata.rows;  // need to assign it, so we can identify which item is clicked

           //  print(_sqlDataRows.toString());


             _bodyWidget = buildListWidget( sqlDataRows: sqldata.rows);
          });
        
          for (var row in sqldata.rows) {
           // print(row.toString());
           // print("username: ${row['username']} country:${row ['country']}"); 
          }

        // Something went wrong here with the http call
        } else {
          print(sqldata.toString());
        }

     }).catchError((e) {
        print(e);
     });

  } 

  

  // Using the SQL Data build the list widget
  Widget buildListWidget({List<dynamic> sqlDataRows}) {

    return new Center(
          child: new ListView.builder(
            itemCount: sqlDataRows.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(sqlDataRows[index]['username']),
                subtitle: new Text(sqlDataRows[index]['country']),
                leading: getImage( keystore: sqlDataRows[index]['photo_key_store'], image: sqlDataRows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }


// Get the image associated with the user( ie their avatar )
  Widget getImage({String keystore, String image}) {

     // String imageURL = "http://www.mtbphotoz.com/prod/Photo/p/p4/p4pgquai6q/aol6b4je.jpg";

    String imageURL = "http://www.mtbphotoz.com/prod/Photo/" + 
          keystore.substring(0,1) + "/" +
          keystore.substring(0,2) + "/" +
          keystore + "/" +
          image;

      return new SizedBox( 
        child: Image.network(imageURL),
         height: 60.0,
          width: 60.0,
        );
  }





  // ***************  Action Methods ****************************


  // Floating action add button
  void _onClickedAdd() {

    print("clicked add");
  }


  // user clicked on a list item
  void _onTapItem(BuildContext context, int index) {

    Navigator.push(context, MaterialPageRoute(
      builder: (context)=>new MemberProfilePage( member: _sqlDataRows[index],),
    ));
  }






} // end of class





