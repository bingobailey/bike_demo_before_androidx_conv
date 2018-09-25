import 'package:flutter/material.dart';

import 'package:bike_demo/widgets/demolistwidget.dart';
import 'package:bike_demo/chat/chatlistwidget.dart';
import 'package:bike_demo/widgets/accountprofilewidget.dart';
import 'package:bike_demo/widgets/notificationListWidget.dart'; 
import 'package:bike_demo/widgets/loginfirebase.dart'; // for testing

import 'package:bike_demo/toolbox/currentuser.dart';
import 'package:bike_demo/toolbox/notification.dart';


class TabBarWidget extends StatefulWidget {
  @override
  _TabBarWidgetState createState() => new _TabBarWidgetState();
}

// SingleTickerProviderStateMixin provides animation
class _TabBarWidgetState extends State<TabBarWidget>  with SingleTickerProviderStateMixin {

  // Need this to handle the tabs
  TabController _controller;

  @override
  void initState() {
      super.initState();
      
     _controller = new TabController( vsync: this, length: 4 );
      CurrentUser.getInstance().init();  // Call the init method so we can load the user's data
      new Notificaton().listen();  // We call the notification class to initiate listening for msg etc 

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

              new NotificationListWidget(),
              //new NotificatonTest(),
              
               new ChatListWidget(),

               new LoginFirebaseWidget(),
              //new AccountProfileWidget(),
            
             // new TestWidget(),  // for testing login
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