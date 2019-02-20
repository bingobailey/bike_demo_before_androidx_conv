<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // This is the user's location making the request, which is compared to lat and lng in the database
    $uid   = $ws->p('uid');
  
    $sql = "SELECT  uid, 
                    displayName,
                    imageName,
                    email
             FROM   user
            WHERE   uid = '$uid' ";
          
    $ws->select($sql);
    $ws->disconnect();



?>
