import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/notify.dart';
import 'package:bike_demo/toolbox/notification.dart';

class _BikeData {
  String description = '';
  String framesize = '';
  String category = '';
  String password = '';
  String username = '';
  
  String toString() {
    return ("email=$description password=$password username=$username");
  }

}


class BikeAddWidget extends StatefulWidget {
  final Notify _notify;

  BikeAddWidget(this._notify); // the constructory which we pass the object we want notified after the bike is added
  
  @override
    State<StatefulWidget> createState() {
      return new _BikeAddWidgetState();
    }

}


class _BikeAddWidgetState extends State<BikeAddWidget>  {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLoading=false;
  _BikeData _bikeData = new _BikeData();

  String _uid;
  String _displayName;

  @override
    void initState() {
      super.initState();
     
      // Get the UID of the user signed in
      FirebaseAuth.instance.currentUser().then((FirebaseUser fbuser) {
        if (fbuser !=null) {
          _uid = fbuser.uid;
          _displayName = fbuser.displayName;
        }
      });

    }


  // The main widget builder
   @override
     Widget build(BuildContext context) {

      return new Scaffold(
         body: new Container(
                margin: EdgeInsets.only( top: 100.0, bottom: 50.0,  left: 50.0, right: 50.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                ) ,
                child: buildAddBikeForm(),
          ),
        );
      
     } // build method



  // Build the Account Form
  Widget buildAddBikeForm() {
   return new Form(
          key: _formKey,
          child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  buildDescriptionField(),
                  new SizedBox( height: 10.0,),
                  buildFrameSizeField(),
                  new SizedBox( height: 10.0,),
                 // buildPasswordField(),
                  new SizedBox( height: 20.0,),
                  buildActionButton(), // this returns the add button or the progress indicator
                ],
              ),
          ),
        );
  }



  // Build Description Field
  Widget buildDescriptionField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'what bike',
                  border: UnderlineInputBorder(),
                  labelText: 'Bike Description',
                  icon: Icon(Icons.directions_bike),
                ),
                keyboardType: TextInputType.text,
                onSaved: (String value) { _bikeData.description = value; },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
              ),
    );
    
  } 



  // Build Description Field
  Widget buildFrameSizeField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'Frame Size',
                  border: UnderlineInputBorder(),
                  labelText: 'Frame Size',
                  icon: Icon(Icons.format_size),
                ),
                keyboardType: TextInputType.text,
                onSaved: (String value) { _bikeData.framesize = value; },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
              ),
    );
    
  } 



  // Either returns the progress indicator (if loading) or the login button
  Widget buildActionButton() {
    return (_isLoading ? new CircularProgressIndicator():buildAddButton());
  }


  // Build login button
  Widget buildAddButton() {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.blue,
            child: new Text("Add Bike", style: new TextStyle( fontSize: 20.0),),
            onPressed: _onAddPressed,
        ),
         
      );
  }



  // Login button
  void _onAddPressed() {
  
    String status = "WTD";  // TODO status, terms and category should not be hardcoded here
    String terms = "evening or weekends";
    String category = "mountain biking";

    // First tools form, then save if OK
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // This executes the onSave: methods on each field

     // Setloading to true, and refresh the screen so the progress indicator shows up
      setState(() {
        _isLoading=true;
       });


       // TODO: should not hardcode "bikeAdded" here
     
      // Add the notification to the Firebase, which will send to all users listening to that topic
      String content = "Check it out ! " +  _bikeData.framesize + " " + _bikeData.description;
      new Notificaton().add( displayName: _displayName, 
                             content:content, 
                             topicName: "bikeAdded", 
                             uid: _uid);
         

      // Add the bike to the SQL DB
      var payload = {'uid':_uid,
          'description':_bikeData.description, 
          'frame_size': _bikeData.framesize,
          'status': status,
          'terms': terms,
          'category': category,
          };

      new WebService().run(service: 'XinsertBike.php', jsonPayload: payload).then((sqldata){
        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {
          
          widget._notify.callback(this); // we call a referesh on the list screen before popping this one
          
          Navigator.of(context).pop(); // Remove the add page, since we were successful 

          print("sqldata = ${sqldata.toString()}");
        // Something went wrong with the http call
        } else {
          print("Http Error: ${sqldata.toString()}");
        }
      }).catchError((e) {
          print(" WebService error: $e");
      });

    }

  }




  } // end of class




