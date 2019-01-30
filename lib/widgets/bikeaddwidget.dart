import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/toolbox/webservice.dart';
import 'package:bike_demo/toolbox/notify.dart';
import 'package:bike_demo/toolbox/notification.dart';
import 'package:bike_demo/toolbox/tables.dart';


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
  
  String _selectedType;
  String _selectedSize;
  String _selectedAction;
  String _selectedModel;
  String _selectedComments; 
  bool _inCM=false;
  double _fontSize=20;
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
        appBar: new AppBar(
                title: const Text('Add Bike'), centerTitle: true,
                ),
         body: new Container(
                margin: EdgeInsets.only( top: 20.0, bottom: 20.0,  left: 20.0, right: 20.0),
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

                  buildTypeField(),
                  new SizedBox( height: 10.0,),

                  buildModelField(),
                  new SizedBox( height:20.0,),

                   buildCheckBox(),
                   buildSizeField(),
                   new SizedBox( height: 10.0,),

                  buildActionField(),
                  new SizedBox(height: 10.0,),

                  buildCommentsField(),
                  new SizedBox(height: 50.0,),

                  buildActionButton(), // this returns the add button or the progress indicator
                ],
              ),
          ),
        );
  }



  // Build Description Field
  Widget buildModelField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.left,
                decoration: const InputDecoration(
                  hintText: 'What bike?',
                  border: UnderlineInputBorder(),
                  labelText: 'Model',
                  icon: Icon(Icons.directions_bike),
                ),
                keyboardType: TextInputType.text,
                onSaved: (String value) { _selectedModel = value; },
                style: new TextStyle( fontSize: _fontSize, color: Colors.black, ),
              ),
    );
    
  } 



  // Build type Field
  Widget buildTypeField() {

  // Drop down list for types
  List<DropdownMenuItem <String>> typeMenuItems = []; 
  typeMenuItems = new Tables().types.map((val)=> new DropdownMenuItem(
      child: new Text(val), value: val,)).toList();

    return new Container(
          margin: EdgeInsets.only( left: 5.0, right: 10.0),
           
            child:  new ListTile(
              title: new DropdownButton(
                style: new TextStyle(fontSize: _fontSize, color: Colors.black),
              items: typeMenuItems,
              isExpanded: true,
              value: _selectedType,
              iconSize: _fontSize*2, // size of the drop arrow
              hint: new Text("Select a type", style: new TextStyle(fontSize: _fontSize),),
              onChanged: (value) {
                setState(() {                   
                  _selectedType=value;
                });
              }
            ),
              leading: new Icon(Icons.cast_connected),
            ),

    );
    
  } 


  // Build type Field
  Widget buildActionField() {

 // Drop down list for actions
  List<DropdownMenuItem <String>> actionMenuItems = []; 
  actionMenuItems = new Tables().actions.map((val)=> new DropdownMenuItem(
    child: new Text(val), value: val,)).toList();

    return new Container(
          margin: EdgeInsets.only( left: 5.0, right: 10.0),
           
            child:  new ListTile(
              title: new DropdownButton(
                style: new TextStyle(fontSize: _fontSize, color: Colors.black),
              items: actionMenuItems,
              isExpanded: true,
              value: _selectedAction,
              iconSize: _fontSize*2, // size of the drop arrow
              hint: new Text("Select an action", style: new TextStyle(fontSize: _fontSize),),
              onChanged: (value) {
                setState(() {                   
                  _selectedAction=value;
                });
              }
            ),
              leading: new Icon(Icons.cast_connected),
            ),

    );
    
  } 



 Widget buildCheckBox() {

   return new CheckboxListTile(
                  title: Text('Frame size in CM', style: new TextStyle(fontSize: _fontSize)),  
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _inCM,
                  onChanged: (bool newValue) {
                    setState(() {
                      _inCM = newValue;
                      _selectedSize=null;
                    });
                  });
 }


 Widget buildSizeField() {

   List<DropdownMenuItem <String>> sizeMenuItems = []; 
  // Populate the list depending on whether in CM or regular classifcation
   if(_inCM) {
     sizeMenuItems = new Tables().sizeCM.map((val)=> new DropdownMenuItem(
      child: new Text(val), value: val,)).toList();
   } else {
     sizeMenuItems = new Tables().sizeClassifications.map((val)=> new DropdownMenuItem(
      child: new Text(val), value: val,)).toList();
   }

    return new Container(
          margin: EdgeInsets.only( left: 5.0, right: 10.0),
           
            child:  new ListTile(
              title: new DropdownButton(
                style: new TextStyle(fontSize: _fontSize, color: Colors.black),
              items: sizeMenuItems,
              isExpanded: true,
              value: _selectedSize,
              iconSize: _fontSize*2, // size of the drop arrow
              hint: new Text("Select a size", style: new TextStyle(fontSize: _fontSize),),
              onChanged: (value) {
                setState(() {                   
                  _selectedSize=value;
                });
              }
            ),
              leading: new Icon(Icons.cast_connected),
            ),

    );
    
 }



  // Build Description Field
  Widget buildCommentsField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.left,
               maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Anything you want to add ?',
                  border: UnderlineInputBorder(),
                  labelText: 'Comments',
                  icon: Icon(Icons.directions_bike),
                ),
                keyboardType:  TextInputType.multiline,
                onSaved: (String value) { _selectedComments = value; },
                style: new TextStyle( fontSize: _fontSize, color: Colors.black, ),
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
          height: 75,
         child:  new RaisedButton(
          color: Colors.blue,
            child: new Text("Submit", style: new TextStyle( fontSize: _fontSize),),
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


       // TODO: should not hardcode "bikeAdded" here
     
      // Add the notification to the Firebase, which will send to all users listening to that topic
      String content = "Check it out ! " +  _selectedSize + " " + _selectedModel;
      new Notificaton().add( displayName: _displayName, 
                             content:content, 
                             topicName: "bikeAdded", 
                             uid: _uid);
         

      // Add the bike to the SQL DB
      var payload = {'uid':_uid,
          'model':_selectedModel, 
          'frame_size': _selectedSize,
          'action': _selectedAction,
          'type': _selectedType,
          'comments': _selectedComments,
          };

      new WebService().run(service: 'XinsertBike.php', jsonPayload: payload).then((sqldata){
        // Status code 200 indicates we had a succesful http call
        if (sqldata.httpResponseCode == 200) {
          widget._notify.callback(this); // we call a referesh on the list screen before popping this one
          Navigator.of(context).pop(); // Remove the add page, since we were successful 
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




