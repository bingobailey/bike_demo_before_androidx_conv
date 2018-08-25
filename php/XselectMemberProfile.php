<?php

    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());

    $requestor = $ws->p('requestor');
    $username =  $ws->p('username');
  
    // Construct SQL
    $sql = "SELECT  name, 
                    bike,
                    favorite_trail,
                    riding_category,
                    username, 
                    status,
                    photo_key_store,
                    photo_profile_name,
                    website,
                    country,
                    state,
                    receive_messages,
                    joindate,
                    MemberBlock.blockee_username
            FROM    Member 
       LEFT JOIN    MemberBlock ON (Member.username = MemberBlock.blocker_username AND MemberBlock.blockee_username = '$requestor')
            WHERE   Member.username = '$username' LIMIT 1";

    $ws->select($sql);
    $ws->disconnect();
  
    
?>


