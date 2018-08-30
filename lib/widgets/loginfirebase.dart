
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
  
       return new Container(

              margin: EdgeInsets.all(50.0),
              decoration: BoxDecoration( 
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                  width: 2.0, 
                  color: Colors.black), 
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/lake.jpg'),
                       colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    ),
              ),

              child: new Form(
                child: new SingleChildScrollView(
                    child: new Column(
                      children: <Widget>[

                          new FlutterLogo( size: 60.0,),

                          new SizedBox( height: 20.0,),
                          buildEmailField(),
                          new SizedBox( height: 20.0,),
                          buildPasswordField() ,
                          new SizedBox( height: 30.0,),
                          buildLoginButton(),

                       ],
                    ),        
                ),
              ),
          );     
  
       
     // );
    
  } // build function


  // Email Address Field
  Widget buildEmailField() {


  return new TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.email),
         // hintText: 'Your email address',
          labelText: 'E-mail',
        ),
        keyboardType: TextInputType.emailAddress,
        onSaved: (String value) { print(value); },
        style: new TextStyle( fontSize: 30.0, color: Colors.black),
      );



  }

  // Password Field
  Widget buildPasswordField() {

  return new TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          icon: Icon(Icons.lock ),
          //hintText: 'Password should be at least 8 chars',
          labelText: 'Password',
        ),
        keyboardType: TextInputType.text,
        obscureText: true,
        onSaved: (String value) { print(value); },
        style: new TextStyle( fontSize: 30.0, color: Colors.black),
      );

  }

  // Login Button

  Widget buildLoginButton() {

    return new IconButton( 
      icon: new Icon(Icons.input),
      onPressed: ()=>{}, 
      color: Colors.blue,
      iconSize: 80.0,
    );

  }
            

} // class
