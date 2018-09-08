import 'package:flutter/material.dart';

import '../widgets/demolistwidget.dart';
import '../chat/chatwidget.dart';
import '../widgets/notificationswidget.dart';
import '../chat/listchatwidget.dart';

import '../widgets/textformfielddemo.dart';
import '../widgets/loginfirebase.dart';
import '../widgets/createaccountwidget.dart';
import '../widgets/testwidget.dart';



class TabBarWidget extends StatefulWidget {
  @override
  _TabBarWidgetState createState() => new _TabBarWidgetState();
}

// SingleTickerProviderStateMixin provides animation
class _TabBarWidgetState extends State<TabBarWidget>  with SingleTickerProviderStateMixin {

  // Need this to handle the tabs
  TabController _controller;


      /*  FOR TESTING CHannel
      UIDS: 
      chuppy  wV9aWBbmHgUySap10e1qgJrLMbv2
      Stevie  ZgrSJsAjeVeA8i11QPmGcse0k0h2 
      simonthetiger   Vx2GCPPs7AbnXb8hk8UTzo22UOw1
      */

      // For TESTING
      String _channelID = "channelfour";
      String _chatEmail = "bingobailey@gmail.com";
      String _chatName = "bingobailey";


  @override
  void initState() {
      super.initState();
      _controller = new TabController( vsync: this, length: 3 );
    }

  @override
  void dispose() {
      _controller.dispose();  // dispose of the controller 
      super.dispose();
    }




  @override
  Widget build(BuildContext context) {

      return new Scaffold( 
 
          resizeToAvoidBottomPadding: false,
          body: new TabBarView( // Create a TabView and place the pages inside.In order of tabs above
            controller: _controller,
            children: <Widget>[
              new DemoListWidget(),
              new NotificationsWidget(),
              new ListChatWidget(),

              //new ChatWidget( channelID: _channelID, chatEmail: _chatEmail, chatName: _chatName,),
             
              new TestWidget(),  // for testing login
             // new CreateAccountWidget(),
            //  new LoginFirebaseWidget(),
             // new TextFormFieldDemo(),
              //new LoginWidget(),
            ]
          ),  


          bottomNavigationBar: new Material( 
            color: Colors.indigo,
             child: new TabBar(  // This is the same code used above
             controller: _controller,
             tabs: <Tab>[
              new Tab( icon: new Icon(Icons.home)),
              new Tab( icon: new Icon(Icons.notifications)),
              new Tab( icon: new Icon(Icons.chat)),

              new Tab( icon: new Icon(Icons.person)),
           ]))

          );
     
    }


} // end of class