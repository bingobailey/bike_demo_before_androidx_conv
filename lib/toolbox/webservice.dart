
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';


// NOTES:
/*
  var payLoad = {"requestor":"JoeBiker","username":"joebiker"};  // Create a JSON object
  var packet = "loginname='bingobailey'&loginpass='bailey.bingo...'&key=" + JSON.stringify(payLoad); // Now we combine the login parms and the payload as one string
    
    var req = {method:'POST',
        url:'http://www.mtbphotoz.com/prod/PHP/selectrowsByName.php',
        data:packet,
        headers:{'Content-Type': 'application/x-www-form-urlencoded'}
    }
*/

  // var url = 'http://www.mtbphotoz.com/prod/PHP/selectMembersByName.php';
  // var payload = {"requestor":"JoeBiker","username":"joebiker"};

  // var url = 'http://www.mtbphotoz.com/prod/PHP/selectMembersAll.php';
  // var payload = {"requestor":"JoeBiker"};


// We create this class to hold all the SQL return data and
// pass it to the class that needs to be notified
 class SQLData  {
  int httpResponseCode;
  String httpResponseReason;
  int sqlCode;
  String sqlMessage; 
  int sqlRowsReturned;   // number of rows returned
  int sqlRowsAffected;
  String serviceCalled;
  List rows;   // The rows returned from the query


  SQLData({this.serviceCalled});

  String toString() {
    return "service: $serviceCalled,  httpResponseCode: ${httpResponseCode.toString()}, httpResponseReason: $httpResponseReason, SQLCode: ${sqlCode.toString()}, SQLMessage: $sqlMessage, Rows Returned: ${sqlRowsReturned.toString()}, Rows Affected: ${sqlRowsAffected.toString()} ";
  }

} // end of sqldata class


class WebService {

  String wsLocation; // Location of the webservice (ie url)
  SQLData sqlData;   // the object that will contain all the sql results

  WebService({this.wsLocation,});



  // This is the async call to call the Webservice
  Future<SQLData> run({String service, Map<String,dynamic>jsonPayload}) async {

    sqlData = new SQLData(serviceCalled: service);
   
    String url = wsLocation + service;
    // Associate the payload with the key, so we can pull it in the php files
    Map<String,dynamic> payLoadWithKey= {'key':jsonPayload};

    // Lets set the headers
    var headers = {
       HttpHeaders.CONTENT_TYPE: 'application/json',
       HttpHeaders.ACCEPT : 'application/json',
      };  

    // Since we are inside a func marked with async we can use await here...
    http.Response response =  await http.post(url,headers: headers, body:jsonEncode(payLoadWithKey));

    if (response.statusCode==200) { // Server returned OK

        // We should get back a list. Decode it 
        List returnedRows = jsonDecode(response.body);

        // The last entry contains the sql code
        var sqlStatusCodes = returnedRows[returnedRows.length-1]; 
      
        // Lets pull the remaining rows leaving off the sqlcode row
        List rows = returnedRows.sublist(0,returnedRows.length-1); 
  
        // Populate the sqldata object with the results then notify the callback
        sqlData.httpResponseCode = response.statusCode;
        sqlData.httpResponseReason = response.reasonPhrase;
        sqlData.sqlCode = sqlStatusCodes['SQLCode'];
        sqlData.sqlMessage = sqlStatusCodes['SQLMessage'];
        sqlData.sqlRowsAffected = sqlStatusCodes['sqlRows'];
        sqlData.sqlRowsReturned = rows.length;
        sqlData.rows = rows;

        //print("SQLdata ${sqlData.toString()}");
  
      } else {  // Server Did NOT return OK, We may have a problem... 
        sqlData.httpResponseCode = response.statusCode;
        sqlData.httpResponseReason = response.reasonPhrase; 
      } 

    return sqlData; // Return the results
    
    } // End of run call 

    
  } // end of webservice class







/*

This is older code that used the Notify Interface

  Future<http.Response> run({String service, Map<String,dynamic>jsonPayload}) async {

    sqlData = new SQLData(serviceCalled: service);
   
    String url = wsLocation + service;
    // Associate the payload with the key, so we can pull it in the php files
    Map<String,dynamic> payLoadWithKey= {'key':jsonPayload};

    // Lets set the headers
    var headers = {
       HttpHeaders.CONTENT_TYPE: 'application/json',
       HttpHeaders.ACCEPT : 'application/json',
      };  


    // The logic hapens inside this post call, but we issue the return on http.post since it returns 
    //  a response object, which matches the future in the definition.  I suppose we could also declare
    // this function to return void and omit this return. 
    return  http.post(url,
              headers: headers ,
              body:jsonEncode(payLoadWithKey)
     ).then((http.Response response) {

          if (response.statusCode==200) { // Server returned OK

            // We should get back a list. Decode it 
            List returnedRows = jsonDecode(response.body);

            // The last entry contains the sql code
            var sqlStatusCodes = returnedRows[returnedRows.length-1]; 
          
            // Lets pull the remaining rows leaving off the sqlcode row
            List rows = returnedRows.sublist(0,returnedRows.length-1); 
      
            // Populate the sqldata object with the results then notify the callback
            sqlData.httpResponseCode = response.statusCode;
            sqlData.httpResponseReason = response.reasonPhrase;
            sqlData.sqlCode = sqlStatusCodes['SQLCode'];
            sqlData.sqlMessage = sqlStatusCodes['SQLMessage'];
            sqlData.sqlRowsAffected = sqlStatusCodes['sqlRows'];
            sqlData.sqlRowsReturned = rows.length;
            sqlData.rows = rows;

            //print("SQLdata ${sqlData.toString()}");

            // Notify the callback with the results
            notify.callback( object: sqlData );

          } else {  // Server Did NOT return OK, We may have a problem... 
            sqlData.httpResponseCode = response.statusCode;
            sqlData.httpResponseReason = response.reasonPhrase; 
            notify.callback( object: sqlData);
          } 
          
     });  // End of http.post call 
    
    }

  */