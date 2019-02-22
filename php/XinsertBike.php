<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $model         = $ws->p('model');
    $year          = $ws->p('year');
    $frameSize    = $ws->p('frameSize');
    $uid           = $ws->p('uid'); 
    $action        = $ws->p('action'); 
    $type          = $ws->p('type'); 
    $comments      = $ws->p('comments'); 
    $imageName     = $ws->p('imageName');

     
    // formulate the sql
    $sql = "INSERT INTO bike (uid, model, year, frameSize, action, type, comments, imageName) 
    VALUES ( '$uid', '$model', '$year', '$frameSize', '$action', '$type','$comments','$imageName')"; 
    
    // insert and disconnect 
    $ws->insert($sql);
    $ws->disconnect();


?>
