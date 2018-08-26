import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {


FirstPage() {
  print("first page instantiated");

}

@override
Widget build(BuildContext context) {
    
    return new Container(
      child: new Center(
        child: new Icon(Icons.people, size: 150.0, color: Colors.green,) ,
      ) , 
    );

  }

}