<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $uidFrom       = $ws->p('uid_from');
    $uidTo         = $ws->p('uid_to');
    $bikeID        = $ws->p('bike_id'); 
    $channelID     = $ws->p('channel_id'); 
     
    // formulate the sql
    $sql = "INSERT INTO channel (uid_from, uid_to, bike_id, channel_id, datetime) 
    VALUES ( '$uidFrom', '$uidTo', '$bikeID', '$channelID', UTC_TIMESTAMP)"; 
    
    // insert and disconnect 
    $ws->insert($sql);
    $ws->disconnect();


?>
