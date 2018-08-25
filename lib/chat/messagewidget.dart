import 'package:flutter/material.dart';
import './message.dart';


// MessageWidget CLASS
///  Note: this class holds the chat message (avatar and text message)
class MessageWidget extends StatelessWidget {
  // Attributes
  final Message message;
  final AnimationController animationController;
  
  // Methods

  // Constructor
  MessageWidget({this.message, this.animationController});

  // Build method
  @override
  Widget build(BuildContext context) {

  return new SizeTransition(                                    
      sizeFactor: new CurvedAnimation(                              
          parent: animationController, curve: Curves.easeOut), 
      axisAlignment: 0.0,   
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(message.name[0])),  // The avatar
            ),

          // Expanded widget allows the column to wrap the text if too long
           new Expanded( 
             child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(message.name, style: Theme.of(context).textTheme.subhead),  //the message
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(message.content),
                ),
              ],
            ),
           )
          ],
        ),
      ) ,
  );

  } // build method

} // MessageWidget class