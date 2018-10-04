import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';


class BikesWidget extends StatefulWidget {

  @override
    State<StatefulWidget> createState() {
      return new _BikesWidgetState();
    }

}


class _BikesWidgetState extends State<BikesWidget>  with SingleTickerProviderStateMixin {

SearchBar searchBar;

  @override
    void initState() {
      super.initState();

    }

  // Constructor 
  _BikesWidgetState() {
    searchBar = new SearchBar(
          inBar: false,
          setState: setState,
          onSubmitted: _onSubmittedSearch,
          buildDefaultAppBar: buildAppBar,
          onClosed: () {
            print("closed");
          }
        );

  }


  @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: searchBar.build(context) ,
        body: new Center( child: new Text("searrch"),),
         floatingActionButton: new FloatingActionButton(
        tooltip: 'Add a bike', // used by assistive technologies
        child: Icon(Icons.add),
        onPressed: _onClickedAdd,
      ),


      );

    } // build method

AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Center( child: new Text('Bikes Wanted !',)),
      actions: [searchBar.getSearchAction(context)]
    );
  }  

void _onSubmittedSearch(String value) {

  print("searchvalue =$value");
}

void _onClickedAdd() {
  print("add clicked");

}


} // end of class