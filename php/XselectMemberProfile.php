<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());

    $requestor = $ws->p('requestor');
    $displayName =  $ws->p('displayName');
  
    // Construct SQL
    $sql = "SELECT  name, 
                    bike,
                    favorite_trail,
                    riding_category,
                    displayName, 
                    status,
                    photo_key_store,
                    photo_profile_name,
                    website,
                    country,
                    state,
                    receive_messages,
                    joindate,
                    MemberBlock.blockee_displayName
            FROM    Member 
       LEFT JOIN    MemberBlock ON (Member.displayName = MemberBlock.blocker_displayName AND MemberBlock.blockee_displayName = '$requestor')
            WHERE   Member.displayName = '$displayName' LIMIT 1";

    $ws->select($sql);
    $ws->disconnect();
  
    
?>


