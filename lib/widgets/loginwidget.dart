
import 'package:flutter/material.dart';


class LoginWidget extends StatefulWidget {

  @override
    State<StatefulWidget> createState() {
      
      return new _LoginWidgetState();
    }

}

class _LoginWidgetState extends State<LoginWidget> {

@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center( child: 
      new IconButton( icon: 
          new Icon(Icons.face), onPressed: 
          _onPressed,),);
  }


void _onPressed() {

  print("hit it");
}


} // end of class