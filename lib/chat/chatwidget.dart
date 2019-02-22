
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';   // for ios icons etc
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bike_demo/chat/messagewidget.dart';
import 'package:bike_demo/constants/platformconstants.dart';
import 'package:bike_demo/chat/message.dart';
import 'package:bike_demo/chat/channel.dart';
import 'package:bike_demo/chat/channelheader.dart';
import 'package:bike_demo/utils/notify.dart';
import 'package:bike_demo/constants/globals.dart';
import 'package:bike_demo/utils/user.dart';
import 'package:bike_demo/services/webservice.dart';
import 'package:bike_demo/utils/tools.dart';


/// Chat Screen CLASS
class ChatWidget extends StatefulWidget {

// attributed passed in
 final ChannelHeader channelHeader;

  // channel property is coming from the Chat List
  ChatWidget({this.channelHeader});


  @override
  State<StatefulWidget> createState() {
    return new _ChatWidgetState();
  }
} // Class 



/// Chat Screen State CLASS
class _ChatWidgetState extends State<ChatWidget>  with TickerProviderStateMixin implements Notify {

// ATTRIBUTES
final TextEditingController _textController = new TextEditingController();
final List<MessageWidget> _messagewidgets = <MessageWidget>[];   // this creates a list of chat messages
bool _isComposing=false; // used to disable the send button if not typing anything
Channel channel;

String _currentDisplayName;
Widget _avatar;


//  METHODS 

@override
  void initState() {
    super.initState();

    _avatar = new Tools().showProgressIndicator();
    assignAvatar(uid: widget.channelHeader.toUID);


    // Create the channel and send this class to be notified of updates
    channel = new Channel( channelID: widget.channelHeader.channelID, notify: this);
    
    // We assign the current user to this chat widget so we can differeiante between messages and color appropriately
    FirebaseAuth.instance.currentUser().then((FirebaseUser fbuser){
      _currentDisplayName = fbuser.displayName;
    });



    // We need to pull any previous messages that exist in the channel and re-display (ie
    // a person picking up a conversation after shutting down the app
    channel.getFirebaseMessages().then( (fbmsgs) {
      fbmsgs.forEach((fbmsg) {
        buildMessageWidget( message: fbmsg); // We need to build each message widget
      });

    }).catchError((e) {
      print("Exception in ChatWidget initState: $e");
    });
     
  }


// Build method
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(  
        leading: _avatar,
        centerTitle: true,
        title: new Text(widget.channelHeader.title),
        elevation:  isIOS ? 0.0 : 4.0,
      ),
      body: buildChatWidget(context)
      
    );
 }



// this builds the screen with the message list and the textfield for entering messages
Widget buildChatWidget(BuildContext context) {

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
              style: new TextStyle(fontSize: baseFont, color: Colors.black),
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
    currentDisplayName: _currentDisplayName, // we send the person signed in
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
  
    // Even though we disable the send button, we put this code here
    // because the checkbutton on the keyboard executes if you press it.
    if (text.length==0) return;
   
    _textController.clear();  // clear the contents of textfield
      setState(() {                    
     _isComposing = false;   // set composing to false and redraw the screen
     });

    // Create the message and push it to db
   // Message message = new Message( name: widget.chatName, content: text,  email: widget.chatEmail);
   // Since this message is being pushed from the UI, it must be the owner or sender
    Message message = new Message( name: widget.channelHeader.displayName, content: text,);

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



  Future<void> assignAvatar({String uid}) async {

    var payload = {
      'uid':uid
      };
     new WebService().run(service: 'XselectUser.php', jsonPayload: payload).then((sqldata){
        if (sqldata.httpResponseCode == 200) {
          // Status code 200 indicates we had a succesful http call
            setState(() {
               // Only one row is returned for the user, so we get can use the index [0]
                _avatar = new User().getAvatar(
                          uid:sqldata.rows[0]['uid'],
                          imageName: sqldata.rows[0]['imageName'],
                          displayName: sqldata.rows[0]['displayName'],
                          imageSize: 30.0,
                          fontSize: baseFontSmaller,
                          fontColor: Colors.white,
                );
            });
        } else {
          // Something went wrong with the http call
          print("Http Error: ${sqldata.toString()}");
        }
     }).catchError((e) {
        print(" WebService error: $e");
     });



  }









} // end of class