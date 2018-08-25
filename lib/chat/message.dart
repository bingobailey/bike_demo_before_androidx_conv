
import 'package:firebase_database/firebase_database.dart';


// The data model class which holds the message contents etc. 
class Message {

  String key;  // this is auto generated from firebase after entry is made
  String name; 
  String content;
  String email;
  DateTime datetime;

  // Constructor
  Message({this.name,this.content, this.email}) {
    datetime = new DateTime.now();
  }

  //Message( {this.key, this.name,this.content,this.email,this.datetime});


  // Constructor creates the Message object from a snapshot
  Message.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    name = snapshot.value['name'];
    content = snapshot.value['content'];
    email = snapshot.value['email'];
    datetime = DateTime.parse(snapshot.value['datetime']) ; // convert from string
  }


  // Converts the object to Json for sending to FB
  toJson() {
    return {
           "name" : name,
        "content" : content,
        "email" : email,
        "datetime" : datetime.toString(),
    };

  }

} // end of Message class