import 'package:flutter/material.dart';

import './toolbox/webservice.dart';
import './toolbox/uitools.dart';
import './memberprofilepage.dart';

import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'WebService Example',
      theme: ThemeData.light(),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  
  // Webservice attributes
  String wsLocation;
  WebService ws; 
  List _rows; // this is the rows coming back from the db query

  // We use this widget to switch out the progress indicator
  Object _guiWidget; 

  UITools uitools; 

  @override
    void initState() {
      super.initState();

      _guiWidget = new Text("howdee doo");

      uitools = new UITools();

      // Instantiate the webservice
     
      //wsLocation = "http://www.mtbphotoz.com/prod/PHP/";
      wsLocation = "http://www.mtbphotoz.com/bikedemo/php/";
      ws = new WebService(wsLocation: wsLocation); 
    }


  @override
  Widget build(BuildContext context) {
   
    return new Scaffold(
      appBar: new AppBar( title: new Text("WebService Example"),
      actions: <Widget>[
        new IconButton( 
          icon: new Icon(Icons.get_app),
           onPressed: onGetDataClicked,)
      ],
      ),
      body: new Center(
         child: _guiWidget,
      ),
    );
  }


  void onGetDataClicked() {

    setState(() {
      _guiWidget = uitools.showProgressIndicator( title: "Loading...");
    });
    
    // Select all the members
     var payload = {"requestor":"JoeBiker"};
     //ws.run( service: "XselectMembersAll.php", jsonPayload: payload);

     ws.run(service: "XselectMembersAll.php", jsonPayload: payload).then((sqldata){

        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {

          setState(() {
             _rows = sqldata.rows;        
             _guiWidget = getList();
          });
        
          for (var row in sqldata.rows) {
            print(row.toString());
           // print("username: ${row['username']} country:${row ['country']}"); 
          }

        // Something went wrong here with the http call
        } else {
          print(sqldata.toString());
        }

     }).catchError((e) {
        print(e);
     });

        
  } // end of onData clicked method

  

  // this populates the list widgets
  Widget getList() {

    return new Center(
          //child: new ListView(children: _list,),
          child: new ListView.builder(
            itemCount: _rows.length,
            itemBuilder:(BuildContext context, int index) {
              return new ListTile(
                title: new Text(_rows[index]['username']),
                subtitle: new Text(_rows[index]['country']),
                leading: getImage( keystore: _rows[index]['photo_key_store'], image: _rows[index]['photo_profile_name']),
                onTap: ()=> _onTapItem(context, index),
              );
            } ,
          )
        );

  }


  void _onTapItem(BuildContext context, int index) {

    Navigator.push(context, MaterialPageRoute(
      builder: (context)=>new MemberProfilePage( member: _rows[index],)
    ));
  }


//final imageURL = "http://www.mtbphotoz.com/prod/Photo/p/p4/p4pgquai6q/aol6b4je.jpg";

  Widget getImage({String keystore, String image}) {

     // String imageURL = "http://www.mtbphotoz.com/prod/Photo/p/p4/p4pgquai6q/aol6b4je.jpg";


    String imageURL = "http://www.mtbphotoz.com/prod/Photo/" + 
          keystore.substring(0,1) + "/" +
          keystore.substring(0,2) + "/" +
          keystore + "/" +
          image;


      return new Container(

          child: new CachedNetworkImage(
            imageUrl:imageURL,
            placeholder: new CircularProgressIndicator(),
            errorWidget: new Icon(Icons.error),
            fit: BoxFit.contain,
            // width: 60.0,
            // height:60.0,
            httpHeaders: null,
          ) ,
          width: 60.0,
          height: 60.0,

      );

  }



} // end of class





