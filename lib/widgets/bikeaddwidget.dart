import 'package:flutter/material.dart';

import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/currentuser.dart';

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
 
  @override
    State<StatefulWidget> createState() {
      return new _BikeAddWidgetState();
    }

}


class _BikeAddWidgetState extends State<BikeAddWidget>  {


  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLoading=false;
  _BikeData _bikeData = new _BikeData();

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
            child: new Text("Add", style: new TextStyle( fontSize: 20.0),),
            onPressed: _onAddPressed,
        ),
         
      );
  }





  // Login button
  void _onAddPressed() {
   
    // First tools form, then save if OK
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // This executes the onSave: methods on each field

     // Setloading to true, and refresh the screen so the progress indicator shows up
      setState(() {
        _isLoading=true;
       });

    String uid = CurrentUser.getInstance().uid;


      print('Printing the bike data.');
      print('descripton: ${_bikeData.description}');
      print('framesize: ${_bikeData.framesize}');
      print('uid : $uid');
  

      // Make the call to the SQL DB
      var payload = {'uid':uid,'description':_bikeData.description, 'frame_size': _bikeData.framesize};
      new WebService().run(service: 'XinsertBike.php', jsonPayload: payload).then((sqldata){
        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {
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




