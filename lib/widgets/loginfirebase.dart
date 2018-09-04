
import 'package:flutter/material.dart'; 
import '../toolbox/credentials.dart';
import '../toolbox/validator.dart';


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
      // TODO: implement initState
      super.initState();

      _credentials.fetchProvidersForEmail( email: "psimoj@gmail.com").then((loginResult) {
          print("providers = ${loginResult.providers.toString()}");
          print("exceptin = ${loginResult.e}");

      });


      // See if user is already logged in 
      _credentials.getCurrentUser().then((loginResult) {
        if (loginResult.user!=null) {
          print("User already logged in user: ${loginResult.user}");
          print("token: ${loginResult.tokenID}");
        } else {
          print("user not logged in");
          print("initiating login");
        }
      });

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
                  new Text("------ OR -------"),
                  buildTestButton( context: context),
                //  buildCreateButton(),
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
            
 // Build login button
  Widget buildCreateButton() {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.green,
            child: new Text("Create New Account", style: new TextStyle( fontSize: 20.0),),
            onPressed: _onCreateAccountPressed,
        ),
         
      );
  }

// Build test button button
  Widget buildTestButton({BuildContext context}) {
    return new Container(
          width: 250.0,
         child:  new RaisedButton(
          color: Colors.amber,
            child: new Text("Show Access Dialog", style: new TextStyle( fontSize: 15.0),),
            onPressed: () {
              _showAccessDialog(  context: context, message: "howdee" );
            },
        ),
         
      );
  }





  //                    ********  Action Methods *********


  // TODO:  Fort testing showAccessDialog, need to pass the BuildContext 

  void _showAccessDialog({BuildContext context, String message}) {

     _credentials.showAccessDialog(  context: context );
  }



  // Create Account button
  void _onCreateAccountPressed() {
    print("hit");
   
  }


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

      // ==> This is where we would call the actual login

  
      //credentials.createAccount();

      _credentials.signInWithEmailAndPassword( 
        email: _loginData.email, 
        password: _loginData.password).then((loginResult) {

        // We've returned so set loading to false and refresh the screen
        setState(() {
          _isLoading=false;              
        });

        // TODO: This is where we would transition to another page

        print("user= ${loginResult.user}");
        print("tokenid = ${loginResult.tokenID}");
        print("e = ${loginResult.e}");
      });

    }
  }
  

} // end class
