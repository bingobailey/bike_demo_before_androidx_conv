
import 'package:flutter/material.dart';


class LoginFirebaseWidget extends StatefulWidget {

  @override
    State<StatefulWidget> createState() {
      return new _LoginFirebaseWidgetState();
    }

}

class _LoginFirebaseWidgetState extends State<LoginFirebaseWidget> {


   @override
     Widget build(BuildContext context) {

      return new SafeArea(
         child: new Container(
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
                           child: new Form(
                              child: new SingleChildScrollView(
                                 child: new Column(
                                    children: <Widget>[
                                      buildEmailField(),
                                      new SizedBox( height: 10.0,),
                                      buildPasswordField(),
                                      new SizedBox( height: 20.0,),
                                      buildLoginButton(),

                                    ],
                                 ),
                              ),
                           ),
                        ),
                        opacity: .8,
             )

          
           )
            
         );
      
     } // build method


  // Email Address Field
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
                onSaved: (String value) { print(value); },
                style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
              ),
    );
    
  } // build email


  // Password Field
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
                  onSaved: (String value) { print(value); },
                  style: new TextStyle( fontSize: 20.0, color: Colors.black, ),
                ),

     );

  }

  // Login Button

  Widget buildLoginButton() {

    return new FlatButton(
       color: Colors.grey[400],
        child: new Text("Sign In"),
        onPressed: _onLoginPressed,
    );

  }
            
  void _onLoginPressed() {

    print("hit");
  }




} // class
