
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
   // return new Scaffold(


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
                       colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
                    ),
              ),

              child: new Form(
                child: new SingleChildScrollView(
                  // reverse: true,
                    child: new Column(
                      children: <Widget>[

                          new SizedBox( height: 50.0,),

                            // email address
                            new TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style: new TextStyle( fontSize: 20.0, color: Colors.blue),
                                   
                            ),

                            new SizedBox( height: 50.0,),

                            // password
                            new TextFormField(
                                keyboardType: TextInputType.text,
                                style: new TextStyle( fontSize: 20.0, color: Colors.blue),
                                obscureText: true,
                            ),

                            new SizedBox( height: 50.0,),

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
          );     
  
       
     // );
    
  } // build function





} // class
