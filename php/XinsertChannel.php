<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $uidFrom       = $ws->p('uidFrom');
    $uidTo         = $ws->p('uidTo');
    $bikeID        = $ws->p('bikeID'); 
    $channelID     = $ws->p('channelID'); 
     
    // formulate the sql
    $sql = "INSERT INTO channel (uidFrom, uidTo, bikeID, channelID, datetime) 
    VALUES ( '$uidFrom', '$uidTo', '$bikeID', '$channelID', UTC_TIMESTAMP)"; 
    
    // insert and disconnect 
    $ws->insert($sql);
    $ws->disconnect();


?>
