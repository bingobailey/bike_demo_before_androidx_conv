<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    // This is the user's location making the request, which is compared to lat and lng in the database
    $latitude   = $ws->p('latitude');
    $longitude  = $ws->p('longitude');
    $radius     = $ws->p('radius'); 
    $units       = $ws->p('units'); // km, mi
    $whereClause = $ws->p('whereClause'); // sent in dynamically

    $milesConstant = 3959;
    $kilometersConstant = 6371;
    $conversionConstant=0;
    
    if ($units == 'km') {
        $conversionConstant = $kilometersConstant;
    } else {
        $conversionConstant = $milesConstant;
    }


    //( $conversionConstant * acos( cos( radians($latitude) ) * cos( radians( User.latitude ) ) * cos( radians( User.longitude ) - radians($longitude) ) + sin( radians($latitude)) * sin( radians( User.latitude ) ) ) ) AS distance 

    // // For Pagination
    // $rowsPaged = $ws->p('rowsPaged');
    // $rowCount =  $ws->p('rowCount');
    // if($rowCount==NULL) $rowCount=0;
    // if($rowsPaged==NULL) $rowsPaged=10000;
     
    $sql = "SELECT  user.uid, 
                    user.username,
                    user.photoName,
                    year,
                    model,
                    bike_id,
                    frame_size,
                    action,
                    comments,
                   FORMAT(  ( $conversionConstant * acos( cos( radians($latitude) ) * cos( radians( user.latitude ) ) * cos( radians( user.longitude ) - radians($longitude) ) + sin( radians($latitude)) * sin( radians( user.latitude ) ) ) ),1) AS distance 
             FROM   user
              JOIN  bike on user.uid = bike.uid  
            WHERE   $whereClause
            HAVING  distance <= $radius
          ORDER BY  distance ASC 
           LIMIT    100";

    $ws->select($sql);
    $ws->disconnect();






?>
