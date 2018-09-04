import 'package:flutter/material.dart';
import '../toolbox/credentials.dart';


class TestWidget extends StatelessWidget {

@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
       child: new RaisedButton(
          child: new Text("Test it"),
          onPressed: () {
              new Credentials().showAccessDialog( context: context);
          }
       ),
    );


  }

}
