<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $bikeID       = $ws->p('bikeID');
     
    // formulate the sql
    $sql = "DELETE FROM bike 
            WHERE bikeID = $bikeID";
           
    // delete and disconnect 
    $ws->delete($sql);
    $ws->disconnect();


?>
