
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import './message.dart';
import '../toolbox/notify.dart';


final String _database = "chat";

// The channel Class which manages communication with Firebase sending
// and listening for messages
class Channel {

  // attributes
  Message _message;  // stores the most recent message
  String channelID;   // unique identifer that allows chatting between two people
  DatabaseReference _reference;  // the firebase ref
  List<Message> _messages = List();  // a list of the messages
  Notify notify;


  // Constructor-  Pass it the unique ID to group all the messages by and 
  //  pass it a class that implements notify, so we can call the method when the
  // db is updated
  Channel({this.channelID, this.notify}) {
      channelID = channelID.replaceAll('.', 'X'); // Firebase won't accept '.' in a link
      // Get a reference to the database and channel
      _reference = FirebaseDatabase.instance.reference().child(_database).child(channelID);
    

      // any time an entry is made in this channel execute this method
      _reference.onChildAdded.listen(_onEntryAdded); 
      
      // any time an entry is changed in this channel execute this method
      _reference.onChildChanged.listen(_onEntryChanged);

      _messages.clear();  // lets clear everything out first
                  
  } // end onstructor
                  


      // NOTE: you can also just push a JSON object
      // var jsonMessage = {
      //   "name":"donna",
      //   "content":"i have a santa cruz",
      //   "email":"donna@aol.com",
      // };
      // reference.push().set(jsonMessage); // Push the json object

    // Push the message to the db and add it to our list
    void push(Message message) {
      _reference.push().set(message.toJson());
      _messages.insert(0,message); // Insert the message at the beginning of list
    }
                  
    // Anytime an entry is made to the db, this method is called
    void _onEntryAdded(Event event) {
        _message = Message.fromSnapshot(event.snapshot);
        // we pull the first message from the list (since all messages are inserted
        // at the beginning of the list) and see if its the same
        // message propogated from the db.  If not, then add it.  reason for this is
        // when pushing an entry to the db from this program it will also call this 
        // method, so you could end up adding the entry twice to the list. 
        if ( _messages.first.datetime != _message.datetime ) {
          _messages.insert(0,_message);  
          notify.callback(_message); // call the class that implements notify
        } 

        // print ("length of list ${messages.length.toString()}");
        // for (var message in messages) {
        //   print("on Entry Added called ${message.name}  ${message.content}");
        // }

    }

    // This method is called if any changes occur to the db.  In a chat app,
    // this won't really occur.  it is shown here for illustrative purposes. 
    void _onEntryChanged(Event event) {
        _message = Message.fromSnapshot(event.snapshot);
        notify.callback(_message);
    }

  // GetFBMessages function returns a sorted list of the messages from
  // Firebase specific to the channel
   Future<List>  getFirebaseMessages() async {

      // this takes a snapshot of the data which comes in as key value pairs
      DataSnapshot snapshot = await _reference.once();
      
     // Because the data is setup in key value pairs, we run forEach. 
     // snapshot.value contains both the key and value
      snapshot.value.forEach( (k,v) {

          // Let's create a message with the snapshot
          Message msg = new Message( 
            content: v['content'],
             email: v['email'],
              name: v['name'],
            );
            msg.key = k; // we need to set the key & the datetime
            msg.datetime =  DateTime.parse(v['datetime']) ; // convert from string

          // Add it to the list
          //chatMessages.add(msg);
          _messages.add(msg);
         
      });
      

      // We sort the list according to datetime
      _messages.sort((a,b) => a.datetime.compareTo(b.datetime));
      

      return _messages;
    
   }
    

} // end of Channel class
