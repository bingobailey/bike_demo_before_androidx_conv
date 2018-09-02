
import 'package:flutter/material.dart'; 
import '../toolbox/credentials.dart';
import '../toolbox/validator.dart';

class _AccountData {
  String email = '';
  String password = '';
  String username = '';
  Validator validate = new Validator();

  String toString() {
    return ("email=$email password=$password username=$username");
  }

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
                  buildUsernameField(),
                  new SizedBox( height: 10.0,),
                  buildEmailField(),
                  new SizedBox( height: 10.0,),
                  buildPasswordField(),
                  new SizedBox( height: 20.0,),
                  buildSignUpButton(),
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
                validator: _accountData.validate.validateEmail,
                
              ),
    );
    
  } 



  // Build Username Field
  Widget buildUsernameField() {
    return new Container(
          margin: EdgeInsets.only( left: 25.0, right: 25.0),
           
            child: TextFormField(
              textAlign: TextAlign.center,
                decoration: const InputDecoration(
                hintText: 'Your display name',
                border: UnderlineInputBorder(),
                  labelText: 'Display Name',
                ),
                keyboardType: TextInputType.text,
                onSaved: (String value) { _accountData.username = value; },
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
                  hintText: 'Must be at least 3 characters',
                  border: UnderlineInputBorder(),
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (String value) { _accountData.password=value; },
                  style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                  validator: _accountData.validate.validatePassword,
                ),

     );

  }


/*
  TODO: 
  - Show progress indicator upon pressing button AND disable button by setting onPressed: null
   
*/

            
 // Build login button
  Widget buildSignUpButton() {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.green,
            child: new Text("Sign Up", style: new TextStyle( fontSize: 20.0),),
            onPressed: null /*_onSignUpPressed*/,
             
        ),
         
      );
  }




  //                    ********  Action Methods *********


  // Sign Up button
  void _onSignUpPressed() {

    // First validate form, then save if OK
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // This executes the onSave: methods on each field

      print('Printing account data.');
      print('Email: ${_accountData.email}');
      print('Password: ${_accountData.password}');

      // Create Account

      _credentials.createAccount( 
        email: _accountData.email, 
        password: _accountData.password, 
        username: _accountData.username).then( (value) {
            print("returned from create account: ${value.toString()}");

        });

      // _credentials.signInWithEmailAndPassword( email: _accountData.email, password: _accountData.password).then((loginResult) {
      //   print("user= ${loginResult.user}");
      //   print("tokenid = ${loginResult.tokenID}");
      //   print("e = ${loginResult.e}");
      // });

    }
  }
  


} // end class
