
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';   // for ios icons etc

import './messagewidget.dart';
import '../toolbox/platformconstants.dart';
import './message.dart';
import './channel.dart';
import '../toolbox/notify.dart';


/// Chat Screen CLASS
class ChatScreen extends StatefulWidget {

  final String channelID;
  final String senderName;  
  final String senderEmail;

  // Constructor - set the fields with the unquie channel id, sender name
  // and email, since this will be the same for all communication
  ChatScreen({this.channelID,this.senderName,this.senderEmail});

  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
} // Class 



/// Chat Screen State CLASS
class ChatScreenState extends State<ChatScreen>  with TickerProviderStateMixin implements Notify {

// ATTRIBUTES
final TextEditingController _textController = new TextEditingController();
final List<MessageWidget> _messagewidgets = <MessageWidget>[];   // this creates a list of chat messages
bool _isComposing=false; // used to disable the send button if not typing anything
Channel channel;


//  METHODS 

@override
  void initState() {
    super.initState();
    
    // Create the channel and send this class to be notified of updates
    channel = new Channel( channelID: widget.channelID,notify: this);

    // We need to pull any previous messages that exist in the channel and re-display (ie
    // a person picking up a conversation after shutting down the app
    channel.getFirebaseMessages().then( (fbmsgs) {
      fbmsgs.forEach((fbmsg) {
        buildMessageWidget( message: fbmsg); // We need to build each message widget
      });

    }).catchError((e) {
      print("Exception in chatScreen initState: $e");
    });
     
  }


// Build method
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar( 
        title: new Text("DemoMe!!"),
        elevation:  isIOS ? 0.0 : 4.0,
      ),
      body: buildChatScreen(context)
      
    );
 }


// this builds the screen with the message list and the textfield for entering messages
Widget buildChatScreen(BuildContext context) {

return new Column(                            
      children: <Widget>[                  
        new Flexible(                         
          child: new ListView.builder(        
            padding: new EdgeInsets.all(8.0),     
            reverse: true,            
            itemBuilder: (_, int index) => _messagewidgets[index],   
            itemCount: _messagewidgets.length,     
          ),   
        ),    
        new Divider(height: 1.0), 
        new Container(     
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor), 
          child: _buildTextField(),  // build the textfield for entering messages
        ),  
      ], 
    );  
}


// Build method which creates the textfield for typing messages
  Widget _buildTextField() {

    return new IconTheme( data:new IconThemeData(color: Theme.of(context).accentColor),
    child: new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(                                            
        children: <Widget>[                                      
          new Flexible(                                          
            child: new TextField(
              controller: _textController,
              onChanged: (String text) {          
                setState(() {                    
                  _isComposing = (text.length > 0);
                });                               
              },  
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message"),
            ),
          ),  

          new Container(                                                 
            margin: new EdgeInsets.symmetric(horizontal: 4.0),      

            child: isIOS ?  new CupertinoButton(  // create an ios button
                   child: new Text("Send"),
               onPressed: _isComposing ? () =>  _handleSubmitted(_textController.text) : null,) :    
            // else create a regular button if not ios
            new IconButton(                                       
              icon: new Icon(Icons.send),                                
             onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)    // send the text to method
                  : null,
          ),  
          ),
        ], 
      ), 
      )
    );
    
  } // build method


//var json = {"name":"jackie","content":"like my yeti","email":"mine@yahoo.com","datetime":"2018-08-09 00:40:34.207896"}


// Notify method, called when a message is updated
void callback(Object obj) {
  if (obj is Message) {
    buildMessageWidget( message: obj);
  }
} // END of callback method


// Builds the message widget and prepares it for animation
void buildMessageWidget({Message message}) {
// Create the chat message and pass the text and the animation controller 
  MessageWidget messagewidget = new MessageWidget(
    message: message,
    animationController: new AnimationController(      
      duration: new Duration(milliseconds: 500),   // this floats the message up from the bottom
      vsync: this,   
    ),   
  ); 

    setState(() {                
      _messagewidgets.insert(0, messagewidget);   
    });  

    messagewidget.animationController.forward(); // animate the message
}



  // handles submitting the message
  void _handleSubmitted(String text) {
  
    _textController.clear();  // clear the contents of textfield
      setState(() {                    
     _isComposing = false;   // set composing to false and redraw the screen
     });

    // Create the message and push it to db
    Message message = new Message( name: widget.senderName, content: text,  email: widget.senderEmail);
    channel.push(message); // send it to the db

    buildMessageWidget( message: message); // build message

  } // END of submit method
  


  // We overide the dispose method of the class and dispose of the 
  // animation controller since we create it in the handleSubmitted method
  @override
  void dispose() {                         
    for (MessageWidget messagewidget in _messagewidgets)   
      messagewidget.animationController.dispose();      
    super.dispose();     
  } 

} // end of class