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
    $status     = $ws->p('status'); // Passed in for WTD (want to demo), ATD (available to demo)

    $milesConstant = 3959;
    $kilometersConstant = 6371;
    $radius     = 50; // lets set this to 50 miles.  TODO: This could be a setting and passed in
    
    // For Pagination
    $rowsPaged = $ws->p('rowsPaged');
    $rowCount =  $ws->p('rowCount');
    if($rowCount==NULL) $rowCount=0;
    if($rowsPaged==NULL) $rowsPaged=10000;
     
    $sql = "SELECT  User.uid, 
                    User.username,
                    description,
                    frame_size,
                    status,
                    terms,
                    photo,
                    category,
                    ( $milesConstant * acos( cos( radians($latitude) ) * cos( radians( User.latitude ) ) * cos( radians( User.longitude ) - radians($longitude) ) + sin( radians($latitude)) * sin( radians( User.latitude ) ) ) ) AS distance 
             FROM   User
        INNER JOIN  Bike on User.uid = Bike.uid    
            WHERE   status = '$status'
            HAVING  distance <= $radius
          ORDER BY  distance ASC
            LIMIT   $rowCount, $rowsPaged";

    
    $ws->select($sql);
    $ws->disconnect();


?>
