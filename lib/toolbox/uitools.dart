
import 'package:flutter/material.dart';

class UITools {

  BuildContext context;


  // Methods:

    Widget showProgressIndicator({String title}) {
      
      if (title==null) {
          return new CircularProgressIndicator();
      } else 
      return new Column( mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new CircularProgressIndicator(), 
          new Padding(  padding: const EdgeInsets.all(5.0)),
          new Text(title)],);
    }

}