import 'package:flutter/material.dart';

import '../widgets/FirstPage.dart';
import '../widgets/SecondPage.dart';
import '../widgets/ThirdPage.dart';



class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

// SingleTickerProviderStateMixin provides animation
class HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin {

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
          title: new Text("Pages Tab Bar"),
          backgroundColor: Colors.lime,

           bottom: new TabBar(  // this creates a tab bar at the bottom of the AppBar
             controller: _controller,
             tabs: <Tab>[
              new Tab( icon: new Icon(Icons.people)),
              new Tab( icon: new Icon(Icons.pause_circle_filled)),
              new Tab( icon: new Icon(Icons.perm_device_information)),
           ])) ,

          body: new TabBarView( // Create a TabView and place the pages inside.In order of tabs above
            controller: _controller,
            children: <Widget>[
              new FirstPage(),
              new SecondPage(),
              new ThirdPage()
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