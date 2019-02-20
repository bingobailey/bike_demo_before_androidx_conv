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
                SELECT  channel.uid_from,
                        channel.uid_to,
                        channel.bike_id,
                        channel.datetime,
                        channel.channel_id,
                        user.displayName,
                        user.imageName,
                        user.uid,
                        bike.frame_size,
                        bike.year,
                        bike.model
                  FROM   channel
                  JOIN   bike ON channel.bike_id = bike.bike_id
                  JOIN   user ON channel.uid_to = user.uid
                 WHERE   channel.uid_from ='$uid'
      
                 UNION ALL
      
                SELECT  channel.uid_from,
                        channel.uid_to,
                        channel.bike_id,
                        channel.datetime,
                        channel.channel_id,
                        user.displayName,
                        user.imageName,
                        user.uid,
                        bike.frame_size,
                        bike.year,
                        bike.model
                  FROM   channel
                  JOIN   bike ON channel.bike_id = bike.bike_id
                  JOIN   user ON channel.uid_from = user.uid
                 WHERE   channel.uid_to = '$uid'
                ) channeltable
      
              ORDER BY  datetime DESC
              LIMIT    100 ";


    $ws->select($sql);
    $ws->disconnect();

?>
