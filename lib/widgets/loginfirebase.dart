
import 'package:flutter/material.dart'; 
import 'package:bike_demo/toolbox/credentials.dart';
import 'package:bike_demo/toolbox/validator.dart';
import 'package:bike_demo/toolbox/currentuser.dart';

class _LoginData {
  String email = '';
  String password = '';
  Validator validate = new Validator();
  String toString() {
    return ("email=$email password=$password");
  }
}
 

class LoginFirebaseWidget extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return new _LoginFirebaseWidgetState();
    }
}

class _LoginFirebaseWidgetState extends State<LoginFirebaseWidget> {

  // Attributes: 
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _isLoading=false;

  _LoginData _loginData = new _LoginData();
  Credentials _credentials = new Credentials();

  @override
    void initState() {
      super.initState();

print("inside loginfirebasewidget  initstate");

    }

//                ********** Build Methods ************

  // build the main widget

   @override
     Widget build(BuildContext context) {

      return new Scaffold(
         body: new Container(
            decoration: new BoxDecoration(
               image: new DecorationImage(
                      fit: BoxFit.cover,
                    image: AssetImage('assets/lake.jpg'),
               )
            ),
             child: new Opacity(
                        child: new Container(
                          margin: EdgeInsets.only( top: 200.0, bottom: 50.0,  left: 50.0, right: 50.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                          ) ,
                          child: buildLoginForm(),
                          
                        ),
                        opacity: .8,
             )
           )
         );
      
     } // build method


  // Build the LoginForm
  Widget buildLoginForm() {
   return new Form(
          key: _formKey,
          child: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  buildEmailField(),
                  new SizedBox( height: 10.0,),
                  buildPasswordField(),
                  new SizedBox( height: 20.0,),
                  buildActionButton(),
                  new Text("Forgot Password ? "),
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
                onSaved: (String value) { _loginData.email = value; },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                validator: _loginData.validate.validateEmail,
                
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
                  onSaved: (String value) { _loginData.password=value; },
                  style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                  validator: _loginData.validate.validatePassword,
                ),

     );

  }


  // Either returns the progress indicator (if loading) or the login button
  Widget buildActionButton() {
  
    return (_isLoading ? new CircularProgressIndicator():buildLoginButton());

  }
 



  // Build login button
  Widget buildLoginButton() {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.blue,
            child: new Text("Sign In", style: new TextStyle( fontSize: 20.0),),
            onPressed: _onLoginPressed,
        ),
         
      );
  }
      



  //                    ********  Action Methods *********



  // Login button
  void _onLoginPressed() {

    // First validate form, then save if OK
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // This executes the onSave: methods on each field

     // Setloading to true, and refresh the screen so the progress indicator shows up
      setState(() {
        _isLoading=true;
       });

      print('Printing the login data.');
      print('Email: ${_loginData.email}');
      print('Password: ${_loginData.password}');

      // Let's try to login
      _credentials.signInWithEmailAndPassword( 
        email: _loginData.email, 
        password: _loginData.password).then((bool isSuccessful) {

        // We've returned so set loading to false and refresh the screen
        setState(() {
          _isLoading=false;              
        });

        // TODO: Login successful... This is where we would transition to another page
        if(isSuccessful) {
          print("login successful");
          print("user= ${CurrentUser.getInstance().user}");
          print("tokenid = ${CurrentUser.getInstance().tokenID}");
         
        } else { // was unsuccessful, need to inform user
          print("login unsuccessful");
            print("e = ${CurrentUser.getInstance().e}");
        }

        
      });

    }
  }
  

} // end class
