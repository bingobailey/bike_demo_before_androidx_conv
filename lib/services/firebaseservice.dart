

/*


****    Map and List Examples ****


  *** Declare a map variable 
   Map property =Map<String,dynamic>(); 


  *** Create a map and add properties to it.  
    Map property =Map<String,dynamic>(); 
    property.putIfAbsent('bikeAdded', ()=>true);
    property.putIfAbsent('advertisement', ()=>false);
    property.putIfAbsent('hello', ()=>'dolly')

    OR 
  *** setting a map property equal to a JSON notation,
    property = {'bikeAdded':true, 'hello':'dolly'};
 


  ** Create a varible that is a list of Maps. 
    var valueList = <Map>[];


  ** Return a list of maps
    Future<List<Map>>


  ** Iterate through a List 
    List list = ['one','two','three']
    list.forEach((item){
         print("item = $item");
    });


  *** Iterate through a list of map

     NOTE: any map object that contains (which they all do)
     a 'key' : 'value'   you can use the .forEach( (k,v))

      var valueList = <Map>[];

      Map map1 = {'key1' : {'property1':'value1','property1x':'value1x'}};
      Map map2 = {'key2' : {'property2':'value2', 'propert2x':'value2x'}};
      Map map3 = {'key3' : {'property3':'value3', 'propert3x':'value3x'}};

      valueList.add(map1);
      valueList.add(map2);
      valueList.add(map3);

      valueList.forEach((item){
        item.forEach( (k,v) {
          print("k=$k"); 
          print("v=$v");

        });
      });



      *** Add a property to a map if not there, or update the value if present
          notice the ()=> 

      Map mapx = {'hello':'dolly'};
      mapx.putIfAbsent('entertainer', ()=>true);
      mapx.putIfAbsent('real name', ()=>'who knows');

      *** Determine if a map object contains a key

      if ( mapx.containsKey('hello')) {
        print(" contains hello");
      } else print('does not contain hello');


      *** Determine if a map object contains a value

      if ( mapx.containsValue(true)) {
        print(" entertainer set to true");
      } else print('entertainer not true');




*/



import 'package:firebase_database/firebase_database.dart';
import 'dart:async';


class FirebaseService {


  // Get a property  ex: "users/$uid" , 'displayName'
  Future<dynamic> getProperty({String rootDir, String propertyName}) async {

    DatabaseReference ref = new FirebaseDatabase().reference().child(rootDir);
    if (ref==null) return null; // Need to ensure we have a valid ref before making the call
    DataSnapshot snapshot = await ref.once();
    return snapshot.value['$propertyName'];
  }



  // SET a property

  // ex: "users/$uid" 'displayName' 'chuppy'   OR
  // ex: "users/$uid" 'topics"  {'bikeadded': true, 'advertisement': false}
  void setProperty({String rootDir, String propertyName, dynamic propertyValue}) { 

    DatabaseReference ref = new FirebaseDatabase().reference().child(rootDir);
    if (ref==null) return; // Need to ensure we have a valid ref before making the call
      ref.update( 
         {
          '$propertyName': propertyValue,
        }
      );
  }


  // This method generates a new child with associated properties. note fb creates a unique key
  // the childNode in this case can be any map object. 
  void addChild( {String rootDir, Map childNode}) {

    DatabaseReference ref = new FirebaseDatabase().reference().child(rootDir);
    if (ref==null) return; // Need to ensure we have a valid ref before making the call

    ref.push().set(childNode);
  }



  // Get a list of all the topics
  Future<List> getKeys({String rootDir}) async {
    List list=[];
    DatabaseReference ref = new FirebaseDatabase().reference().child(rootDir);
    if (ref==null) return null; // Need to ensure we have a valid ref before making the call
    DataSnapshot snapshot = await ref.once();
    snapshot.value.forEach((k,v) {
      list.add(k); // k is the top level items.  v would be the data/items associated with each k
    });

    return list;
  }



  // Get the list of values  associated with the root
  Future<List> getValues({String rootDir}) async {

  DatabaseReference ref = new FirebaseDatabase().reference().child(rootDir);
      if (ref==null) return null; // Need to ensure we have a valid ref before making the call

      List valueList =[];
      Query query = ref.orderByKey();
      DataSnapshot snapshot = await query.once(); // get the data
      if (snapshot.value==null) return []; // return an empty list.  Nothing found

      snapshot.value.forEach( (k,v) {
        valueList.add(v);
        //_list.add(v);
        // print("k = $k");
        // print("topic = $topicName");
        // print("content = ${v['content']}");
        // print("displayname = ${v['displayName']}");
      });

      return valueList;
    }



}