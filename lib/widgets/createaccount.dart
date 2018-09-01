
import 'package:flutter/material.dart'; 
import '../toolbox/credentials.dart';


class _AccountData {
  String email = '';
  String password = '';
  String username = '';
}
 

class CreateAccountWidget extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return new _CreateAccountWidgetState();
    }
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {

  // Attributes: 
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _AccountData _accountData = new _AccountData();
  Credentials _credentials = new Credentials();



//                ********** Build Methods ************

  // build the main widget

   @override
     Widget build(BuildContext context) {

      return new SafeArea(
         child: new Container(
                margin: EdgeInsets.only( top: 100.0, bottom: 50.0,  left: 50.0, right: 50.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                ) ,
                child: buildAccountForm(),
                
          ),
                  
        );
      
     } // build method


  // Build the LoginForm
  Widget buildAccountForm() {
   return new Form(
          key: _formKey,
          child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  buildEmailField(),
                  new SizedBox( height: 10.0,),
                  buildPasswordField(),
                  new SizedBox( height: 20.0,),
                  buildSubmitButton(),
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
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (String value) { _accountData.email = value; },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                validator: _validateEmail,
                
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
                  hintText: '>= 8 chars',
                  border: UnderlineInputBorder(),
                    labelText: 'password',
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (String value) { _accountData.password=value; },
                  style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                  validator: _validatePassword,
                ),

     );

  }

            
 // Build login button
  Widget buildSubmitButton() {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.green,
            child: new Text("Submit", style: new TextStyle( fontSize: 20.0),),
            onPressed: _onSubmitPressed,
        ),
         
      );
  }




  //                    ********  Action Methods *********


  // Login button
  void _onSubmitPressed() {

    // First validate form, then save if OK
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // This executes the onSave: methods on each field

      print('Printing the login data.');
      print('Email: ${_accountData.email}');
      print('Password: ${_accountData.password}');

      // ==> This is where we would call the actual login

  
      //credentials.createAccount();

      _credentials.signInWithEmailAndPassword( email: _accountData.email, password: _accountData.password).then((loginResult) {
        print("user= ${loginResult.user}");
        print("tokenid = ${loginResult.tokenID}");
        print("e = ${loginResult.e}");
      });

    }
  }
  

// Validate email
String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Not a valid email';
    else
      return null;  // returning null indicates the validation has passed
  }

  // Validate password
  String _validatePassword(String value) {
    if (value.length < 8) {
      return 'The Password must be at least 8 characters.';
    } else
      return null;  // returning null indicates the validation passed
  }




} // end class
