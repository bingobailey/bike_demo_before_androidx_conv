<?php

/*
 * 
 * NOTE: on SQL Return Codes
 * sqlCode 0 is success for UPATE, INSERT and SELECT 
 * sqlCode 1062 is attempt to insert DUPLICATE record
 * We are forcing 1032 as the sqlCode for NOT FOUND, since an empty resultset is considered successful
 * max_affected_rows() when using UPDATE and INSERT etc
 * max_num_rows(resultSet) when using SELECT
 * sqlCode -1 indicates that the key was not sent along with the payload. 
 * 
 * This uses the OO approach, with new mysqli
 */


class WebService {
    
    var $mysqli;
    var $user;
    var $pwrd;
    var $host;
    var $db;
    var $data;
    
    // Constructor- We pass it the json file sent in the POST using
    //  file_get_contents('php://input');
        public function __construct($dataString) {

       // Decode into PHP object. true is passed so we can use ['property'] to get the value.
       // If true was not passed you would use the standard,  ->property. 
       // We check to see if 'key' was passed as part of the payload.  This prevents unathorized
       // people from trying to run the php programs on the server via a browser. 
       $obj = json_decode($dataString,true); // decode the json object into a php object, true
       if (!isset($obj['key'])) {
            $this->echoSQLResponse(array(), -1, "Invalid Key sent. Unable to run service",0);
            exit();
       }
       $this->data = $obj['key']; // Pull the json contents
    }


  
   // Returns an element from the property list (passed in via Json) and places escape chars
   // where necessary so it will work within a query. 
   public function p($p) {

    return $this->data[$p];
    //return $this->mysqli->real_escape_string($this->data[$p]);
   }


    // Connect to the database
    public function connect($dbHost, $dbUser, $dbPwrd, $dbName) {
        
        $this->mysqli = new mysqli($dbHost, $dbUser, $dbPwrd, $dbName);
        
         if( $this->mysqli->connect_errno ) {
             $this->echoSQLResponse(array(), $this->mysqli->connect_errno, $this->mysqli->connect_error,0);
             exit();
          }
    }
    
    
    
    // Pushes the SQL codes as the last row in the array, then echos all the rows in JSON format for
    // the calling program to interpret
    public function echoSQLResponse($rows, $sqlCode, $sqlMessage, $sqlRows) {
  
        // $Result below is an associated array which is basically a dictionary
        $result = array('SQLCode'=>$sqlCode, 'SQLMessage'=>$sqlMessage, 'SQLRows'=>$sqlRows);
    
        // Next we push the result on as the last object of the array. The last row contains the sqlcodes
        array_push($rows, $result);
       
        echo json_encode($rows);
    }
    
    
    // $sql passed should be an INSERT action SQL
    public function insert($sql) {
          
        // If this fails it will return the duplicate error 1062, otherwise success
       $result = $this->mysqli->query($sql);
       $sqlCode = $this->mysqli->errno; 
       $sqlMessage = $this->mysqli->error;
       $this->echoSQLResponse(array(), $sqlCode, $sqlMessage, $this->mysqli->affected_rows);
    }    
    
   
    // Executes a SQL without echoing the return values.  Use this for simple executions like updates etc.
    public function executeSQLWithNoEcho($sql) {
         $this->mysqli->query($sql);
    }

    
    // Executes SQL and returns a Result.  Use this to perform a select within other PHP programs (need the result, but not in json format
   public function executeSQLWithResult($sql) {
       $result = $this->mysqli->query($sql);
       return $result;
   }
    
    
    // Delete function
    public function delete($sql) {
      
        $result = $this->mysqli->query($sql);
        $sqlCode = $this->mysqli->errno; 
        $sqlMessage = $this->mysqli->error;
        
        if( !$result ) { // if not true, we had a database failure
            $this->echoSQLResponse(array(), $sqlCode, $sqlMessage,0);
        } else if ($this->mysqli->affected_rows == 0) {
            $this->echoSQLResponse(array(), 1032, "No Record(s) Found", 0);  //  Couldn't Find record to delete
        } else {
            $this->echoSQLResponse(array(), $sqlCode, $sqlMessage, $this->mysqli->affected_rows);
        }
    }
    
    
    // NOTE: Upon executing update SQL, if the values you are setting in the colums already exist, the SQL
    // will not update the columns, but instead return successful but with affected rows at 0.  For example,
    // if the update statement said to "SET firstname = 'John'"  and the firstname was already 'John' in the 
    // table, the SQL will not update the column and return affected rows at 0.  Based on our logic below,
    // this will be intepreted as a 1032 or NO RECORD FOUND condition.  In most real world cases, this 
    // scenario shouldn't happen often.  
    
    // $sql passed should be an UPDATE action SQL
    public function update($sql) {
        
        $result = $this->mysqli->query($sql);
        $sqlCode = $this->mysqli->errno; 
        $sqlMessage = $this->mysqli->error;
        
        if( !$result ) { // If not true, we had a database failure 
            $this->echoSQLResponse(array(), $sqlCode, $sqlMessage, 0);
        } else if ($this->mysqli->affected_rows == 0) {
            $this->echoSQLResponse(array(), 1032, "No Record(s) Found", 0);  //  Couldn't Find record to update
        } else {
            $this->echoSQLResponse(array(), $sqlCode, $sqlMessage, $this->mysqli->affected_rows);
        }
    }


    // $sql passed should be a SELECT action SQL
    public function select($sql) {
 
        $result = $this->mysqli->query($sql);
        $sqlCode = $this->mysqli->errno; 
        $sqlMessage = $this->mysqli->error;
        
        if ( !$result ) { // If result is false, we have a DB error, otherwise it was succcessful
            $this->echoSQLResponse(array(), $sqlCode, $sqlMessage, 0);
        } else if ($result->num_rows == 0 ) {
            $this->echoSQLResponse(array(), 1032, "No Record(s) Found", 0);  // force NOT FOUND code
        } else { 
            $rows=NULL;
            while( $row = $result->fetch_assoc() ){  // Load all the results into an assoc array
              //  $rowData = array_merge($row,array("row_type"=>"dataRow"));
             //   $rows[] = $rowData;
                  $rows[] = $row;
            }
            
            $this->echoSQLResponse($rows, $sqlCode, $sqlMessage, $result->num_rows);  
        }
        $result->close(); // Since we have a group of records, we must free the result
        
    }
   
       
    // Disconnect, close the connection
    public function disconnect() {
        $this->mysqli->close;
    }
       
} // end of class definition



?>

