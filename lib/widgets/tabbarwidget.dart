import 'package:flutter/material.dart';

import '../widgets/demolistwidget.dart';
import '../chat/chatwidget.dart';

import '../widgets/loginwidget.dart';
import '../widgets/textformfielddemo.dart';
import '../widgets/loginfirebase.dart';



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

        appBar: new AppBar( 
          title: new Text("Bike Demo"),
          backgroundColor: Colors.lime,

          ) ,

          body: new TabBarView( // Create a TabView and place the pages inside.In order of tabs above
            controller: _controller,
            children: <Widget>[
              new DemoListWidget(),
              new ChatWidget( channelID: "newchanel", senderEmail: "bingo@yahoo.com", senderName: "Erin",),
             
              new LoginFirebaseWidget(),
              //new TextFormFieldDemo(),
              //new LoginWidget(),
            ]
          ),  

          bottomNavigationBar: new Material( 
            color: Colors.indigo,
             child: new TabBar(  // This is the same code used above
             controller: _controller,
             tabs: <Tab>[
              new Tab( icon: new Icon(Icons.people)),
              new Tab( icon: new Icon(Icons.pause_circle_filled)),
              new Tab( icon: new Icon(Icons.perm_device_information)),
           ]))

          );
     
    }



}