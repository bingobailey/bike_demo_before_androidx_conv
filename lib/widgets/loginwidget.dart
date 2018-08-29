
import 'package:flutter/material.dart';


class LoginWidget extends StatefulWidget {

  @override
    State<StatefulWidget> createState() {
      
      return new _LoginWidgetState();
    }

}

class _LoginWidgetState extends State<LoginWidget> {


TextEditingController _emailController = new TextEditingController();
TextEditingController _passwordController = new TextEditingController();





@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container( 


        child: new ListView( 
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // add the Logo here..
              new FlutterLogo( size: 80.0,),

              new Padding( padding: EdgeInsets.only( top: 50.0),),

              
              // Enter email address
              new Container( 
                padding: EdgeInsets.only( left: 70.0, right: 70.0,),
                child:  new TextField( 
                              controller: _emailController ,
                              keyboardType: TextInputType.emailAddress ,
                              style: new TextStyle( fontSize: 20.0, color: Colors.blue, ),
                              decoration: new InputDecoration( 
                                hintText: "myuser@email.com", 
                                fillColor: Colors.black,
                              ), 
                          ),   
              ),
             
              new Padding( padding: EdgeInsets.only( top: 20.0),),

              // Enter password
              new Container( 
                padding: EdgeInsets.only( left: 70.0, right: 70.0),
                child:  new TextField( 
                              controller: _passwordController ,
                              keyboardType: TextInputType.text ,
                               obscureText: true,
                              style: new TextStyle( fontSize: 20.0, color: Colors.blue, ),
                              decoration: new InputDecoration( 
                                hintText: "enter your password", 
                                fillColor: Colors.black,
                              ), 
                          ),   
              ),

              new Padding( padding: EdgeInsets.only( top: 40.0),),

              new IconButton( 
                icon: new Icon(Icons.input),
                 onPressed: _loginPressed, 
                 color: Colors.green,
                 iconSize: 40.0,
              )


                          ],
          ),
     );
                        
          
  } // build


                        
  void _loginPressed() {

    print("Login it");
  }
    

} // end of class



/*

@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container( 
        child: new Column( 
           // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              // add the Logo here..
              new FlutterLogo( size: 80.0,),

              new Padding( padding: EdgeInsets.only( top: 50.0),),

              // Enter email address
              new Container( 
                padding: EdgeInsets.only( left: 70.0, right: 70.0,),
                child:  new TextField( 
                              controller: _emailController ,
                              keyboardType: TextInputType.emailAddress ,
                              style: new TextStyle( fontSize: 20.0, color: Colors.blue, ),
                              decoration: new InputDecoration( 
                                hintText: "myuser@email.com", 
                                fillColor: Colors.black,
                              ), 
                          ),   
              ),
             
              new Padding( padding: EdgeInsets.only( top: 20.0),),

              // Enter password
              new Container( 
                padding: EdgeInsets.only( left: 70.0, right: 70.0),
                child:  new TextField( 
                              controller: _passwordController ,
                              keyboardType: TextInputType.text ,
                               obscureText: true,
                              style: new TextStyle( fontSize: 20.0, color: Colors.blue, ),
                              decoration: new InputDecoration( 
                                hintText: "enter your password", 
                                fillColor: Colors.black,
                              ), 
                          ),   
              ),

              new Padding( padding: EdgeInsets.only( top: 40.0),),

              new IconButton( 
                icon: new Icon(Icons.input),
                 onPressed: _loginPressed, 
                 color: Colors.green,
                 iconSize: 40.0,
              )


                          ],
          ),
     );
                        
          
  } // build

*/