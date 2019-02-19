<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $bike_id       = $ws->p('bike_id');
     
    // formulate the sql
    $sql = "DELETE FROM bike 
            WHERE bike_id = $bike_id";
           
    // delete and disconnect 
    $ws->delete($sql);
    $ws->disconnect();


?>
