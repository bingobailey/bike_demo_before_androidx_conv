
// This class is used to create the header and is passed to the Channel class via the bikelist widget or the
// chatlist widget.  This keeps the info consistent, regardless of where Channel is called. 
class ChannelHeader {

  String channelID;
  String title;
  String displayName;
  String toUID;
  String fromUID;
 
  ChannelHeader({this.channelID, this.title, this.displayName}) {

    List items =channelID.split('_'); // The channel id is created using the from and to UID seperated with '_'
    this.fromUID = items[0];  // The first item is the from UID
    this.toUID = items[1];  // The second item is the to UID
  }

  String toString() {
    return ('channelID=$channelID  title=$title displayName=$displayName');
  }

}