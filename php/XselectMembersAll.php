<?php


    require 'XloginCredentials.php';
    require 'XWebService.php';

    // Get the data from the JSON
    $dataString = file_get_contents('php://input');

    $ws = new WebService($dataString); 
    $ws->connect(getHost(), getUser(), getPwrd(), getDB());
    
    $requestor = $ws->p('requestor');

    
    // For Pagination
    $rowsPaged = $ws->p('rowsPaged');
    $rowCount =  $ws->p('rowCount');
    if($rowCount==NULL) $rowCount=0;
    if($rowsPaged==NULL) $rowsPaged=10000;
     
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
        LEFT JOIN   MemberBlock ON (Member.username = MemberBlock.blocker_username AND MemberBlock.blockee_username = '$requestor')
                    WHERE 1
            AND     Member.inactivate_datetime IS NULL
           ORDER BY username ASC
            LIMIT   $rowCount, $rowsPaged";
  
   
    
    $ws->select($sql);
    $ws->disconnect();


?>
