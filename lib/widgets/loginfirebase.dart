
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
    // TODO: implement build
    return new Container(
       margin: EdgeInsets.all(50.0),
       child: new SafeArea(
          child: new Form(
            
             child: new SingleChildScrollView(
               // reverse: true,
                child: new Column(
                  children: <Widget>[

                       new Padding( padding: EdgeInsets.only( top: 100.0)),


                        // email address
                        new TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle( fontSize: 20.0, color: Colors.blue),
                        ),

                        new Padding( padding: EdgeInsets.only( top: 175.0)),

                        // password
                        new TextFormField(
                            keyboardType: TextInputType.text,
                            style: new TextStyle( fontSize: 20.0, color: Colors.blue),
                            obscureText: true,
                        ),

                       new Padding( padding: EdgeInsets.only( top: 5.0)),

                        new IconButton( 
                          icon: new Icon(Icons.input),
                          onPressed: ()=>{}, 
                          color: Colors.green,
                          iconSize: 40.0,
                        )



                   ],
                ),
               
              
             ),
          ),
       ),
    );
  


  } // build function



} // class
