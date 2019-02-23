<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // This is the user's location making the request, which is compared to lat and lng in the database
    $uid   = $ws->p('uid');

    $sql = "SELECT * 
              FROM (
                SELECT  channel.uidFrom,
                        channel.uidTo,
                        channel.bikeID,
                        channel.datetime,
                        channel.channelID,
                        user.displayName,
                        user.imageName,
                        user.uid,
                        bike.frameSize,
                        bike.year,
                        bike.model
                  FROM   channel
                  JOIN   bike ON channel.bikeID = bike.bikeID
                  JOIN   user ON channel.uidTo = user.uid
                 WHERE   channel.uidFrom ='$uid'
      
                 UNION ALL
      
                SELECT  channel.uidFrom,
                        channel.uidTo,
                        channel.bikeID,
                        channel.datetime,
                        channel.channelID,
                        user.displayName,
                        user.imageName,
                        user.uid,
                        bike.frameSize,
                        bike.year,
                        bike.model
                  FROM   channel
                  JOIN   bike ON channel.bikeID = bike.bikeID
                  JOIN   user ON channel.uidFrom = user.uid
                 WHERE   channel.uidTo = '$uid'
                ) channeltable
      
              ORDER BY  datetime DESC
              LIMIT    100 ";


    $ws->select($sql);
    $ws->disconnect();

?>
