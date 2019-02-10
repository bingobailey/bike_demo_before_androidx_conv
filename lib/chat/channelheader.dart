
// This class is used to create the header and is passed to the Channel class via the bikelist widget or the
// chatlist widget.  This keeps the info consistent, regardless of where Channel is called. 
class ChannelHeader {

  final String channelID;
  final String title;
  final String displayName;
 
  ChannelHeader({this.channelID, this.title, this.displayName});

  String toString() {
    return ('channelID=$channelID  title=$title displayName=$displayName');
  }

}