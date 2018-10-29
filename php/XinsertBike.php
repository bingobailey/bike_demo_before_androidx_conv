<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $description   = $ws->p('description');
    $frame_size    = $ws->p('frame_size');
    $uid           = $ws->p('uid'); 
    $status        = $ws->p('status'); 
    $category      = $ws->p('category'); 
    $terms         = $ws->p('terms'); 
    $photo         = $ws->p('photo'); //url

     
    // formulate the sql
    $sql = "INSERT INTO Bike (uid, description, frame_size, status, category, terms, photo) 
    VALUES ( '$uid', '$description', '$frame_size', '$status', '$category','$terms','$photo')"; 
    
    // insert and disconnect 
    $ws->insert($sql);
    $ws->disconnect();


?>
