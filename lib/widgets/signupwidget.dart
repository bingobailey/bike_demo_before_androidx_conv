
import 'package:flutter/material.dart';

import 'package:bike_demo/utils/account.dart';
import 'package:bike_demo/utils/tools.dart';
import 'package:bike_demo/services/locationservice.dart';


class AccountData {
  String email = '';
  String password = '';
  String displayName = '';
  double latitude;
  double longitude;
  Tools tools = new Tools();

  String toString() {
    return ("email=$email password=$password displayName=$displayName");
  }

}
 

class SignUpWidget extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return new _SignUpWidgetState();
    }
}

class _SignUpWidgetState extends State<SignUpWidget> {
  // Attributes: 
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
 
  AccountData _accountData;
  Account _account;
  bool _isLoading=false;

  @override
     initState()  {
      super.initState();

        _accountData = new AccountData();
        _account = new Account();

        new LocationService().getGPSLocation().then((Location location) {
          _accountData.latitude =location.latitude;
          _accountData.longitude =location.longitude;
        });

          // TODO:  if latitude and longitdue are null, should call geolocation again.

    }


//                ********** Build Methods ************


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
                child: buildAccountForm(),
          ),
        );
      
     } // build method



  // Build the Account Form
  Widget buildAccountForm() {
   return new Form(
          key: _formKey,
          child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  builddisplayNameField(),
                  new SizedBox( height: 10.0,),
                  buildEmailField(),
                  new SizedBox( height: 10.0,),
                  buildPasswordField(),
                  new SizedBox( height: 20.0,),
                  buildActionButton(), // this returns the signup button or the progress indicator
                ],
              ),
          ),
        );
  }



  // Build Email Address Field
  Widget buildEmailField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                  border: UnderlineInputBorder(),
                  labelText: 'email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (String value) { _accountData.email = value; },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                validator: _accountData.tools.validateEmail,
                
              ),
    );
    
  } 



  // Build displayName Field
  Widget builddisplayNameField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Your display name',
                  border: UnderlineInputBorder(),
                  labelText: 'Display Name',
                  icon: Icon(Icons.person_outline),

                ),
                keyboardType: TextInputType.text,
                onSaved: (String value) { _accountData.displayName = value; },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                validator: (String value) { if ( value.length < 3 ) return 'Must be at least 3 characters'; } ,
                
              ),
    );
    
  } 



  // Build Password Field
  Widget buildPasswordField() {
    return new Container(
            margin: EdgeInsets.only( left: 25.0, right: 25.0),
                child: TextFormField(
                
                textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      hintText: 'Must be at least 8 characters',
                      border: UnderlineInputBorder(),
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (String value) { _accountData.password=value; },
                  style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                  validator: _accountData.tools.validatePassword,
                ),

     );

  }



// We call this the action button, it either returns the signup button or the progress indicator
Widget buildActionButton() {
  return (_isLoading ? new CircularProgressIndicator():buildSignUpButton());
}
            


 // Build SignUp button
  Widget buildSignUpButton() {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.green,
            child: new Text("Sign Up", style: new TextStyle( fontSize: 20.0),),
            onPressed: _onSignUpPressed,
        ),
         
      );
  }



  //                    ********  Action Methods *********

  // Sign Up button
  void _onSignUpPressed() {

    // First validate form, then save if OK
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // This executes the onSave: methods on each field

    // Setloading to true, and refresh the screen so the progress indicator shows up
      setState(() {
        _isLoading=true;
       });

      // Create the Account
      _account.createAccount( 
        email: _accountData.email, 
        password: _accountData.password, 
        displayName: _accountData.displayName,
        latitude: _accountData.latitude,
        longitude: _accountData.longitude,
        ).then( ( Map<String,dynamic> result) { 
          
          bool isSuccessful = result['status'];
          String msg = result['msg'];

          // We've returned so set loading to false and refresh the screen
          setState(() {
            _isLoading=false;              
          });

              // User was successfully created in firebase authentication account
          if (isSuccessful) {
            Navigator.of(context).pop(); // success so, remove this screen
          }
          else {

            // TODO: determine if msg is email address already used, then display that
            // otherwise display msg
              print("Error creating user account");
            }
              
        });
    }
  }
  


} // end class
