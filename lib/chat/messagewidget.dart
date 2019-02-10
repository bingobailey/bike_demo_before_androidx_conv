import 'package:flutter/material.dart';

import 'package:bike_demo/chat/message.dart';
import 'package:bike_demo/constants/globals.dart';


///  Note: this class holds the chat message (avatar and text message)
class MessageWidget extends StatelessWidget {
  // Attributes
  final Message message;
  final AnimationController animationController;
  final String currentUsername;


  // Constructor
  MessageWidget({this.message, this.animationController, this.currentUsername});
  

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

                  child: getMessageContainer(msg: message),

                  //child: new Text(message.content, style: new TextStyle(color: Colors.blue, fontSize:baseFont,),),

                ),
              ],
            ),
           )
          ],
        ),
      ) ,
  );

  } // build method





  Widget getMessageContainer({Message msg}) {
    TextStyle textStyle;
    BoxDecoration boxDecoration;

    // If the current username is equal to the msg.name, then we found the owner, change the color 
    if( currentUsername == msg.name) {
      textStyle= new TextStyle(color: Colors.white, fontSize:baseFont);
      boxDecoration = new BoxDecoration(color: Colors.blue);
     } else {
      textStyle= new TextStyle(color: Colors.black, fontSize:baseFont);
      boxDecoration = new BoxDecoration(color: Colors.grey);
     }
    
    return Container( 
              child: new Text(message.content, style: textStyle),
         decoration: boxDecoration,
                    
                
     );

 }



} // End of MessageWidget class