<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $latitude   = $ws->p('latitude');
    $longitude  = $ws->p('longitude');
    $uid        = $ws->p('uid'); 
    $username   = $ws->p('username'); 
    $email      = $ws->p('email');
     
    // formulate the sql
    $sql = "INSERT INTO User (uid, username, email, latitude, longitude, joindate) 
    VALUES ( '$uid', '$username', '$email', '$latitude', '$longitude', CURDATE() )"; 
    
    // insert and disconnect 
    $ws->insert($sql);
    $ws->disconnect();


?>
