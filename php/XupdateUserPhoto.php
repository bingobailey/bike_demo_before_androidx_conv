<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // pull the data
    $uid        = $ws->p('uid'); 
    $imageName  = $ws-p>('imageName');
     
    // formulate the sql
    $sql = "
    UPDATE user
    set imageName   = '$imageName'
    WHERE uid = '$uid'
    ";

    // insert and disconnect 
    $ws->update($sql);
    $ws->disconnect();


?>
