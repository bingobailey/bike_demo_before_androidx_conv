<?php


 // All photos will be kept here in various subdirectories. 
$photoRootDirectory = "../photos";  

// We use this to set the return status codes ec
$returnStatus = null; 

if (empty($_POST['imageData'])) {
    $returnStatus = array('statusCode' => -1 , 
    'statusMessage'=>'Call Failed.  imageData is empty');
     echo(json_encode($returnStatus));
     exit();
}

if (empty($_POST['imageName'])) {
    $returnStatus = array('statusCode' => -1 , 
    'statusMessage'=>'Call Failed.  imageName is empty');
     echo(json_encode($returnStatus));
     exit();
}

if (empty($_POST['photoKeyStore'])) {
    $returnStatus = array('statusCode' => -1 , 
    'statusMessage'=>'Call Failed.  photoKeyStore is empty');
     echo(json_encode($returnStatus));
     exit();
}


// Pull the values from the Post
$imageData      = $_POST['imageData'];
$imageName      = $_POST['imageName'];
$photoKeyStore  = $_POST['photoKeyStore'];


// Create the upload directory
$uploadDir = $photoRootDirectory . "/" . $photoKeyStore . "/";

// Check to see if the upload dir exists, if not create it
if(!file_exists($uploadDir) ) {
    mkdir($uploadDir,0777,true);   // 0777 for widest possible permisions, true to allow creation of nexted subdir
    
} else {
    // Directory already exists.. nothing else to do
}

// Construct the path and filename
$pathAndFileName = $uploadDir . $imageName;

// This will overrite an existing file.  Returns the no of bytes copied.
$bytesWritten = file_put_contents($pathAndFileName,base64_decode($imageData));

// Check to see if the write was successful
if ($bytesWritten > 0) {
    $returnStatus = array('statusCode' => 0 , 
                    'statusMessage'=>'Success! imageFile uploaded');
} else {
    $returnStatus = array('statusCode' => -1 , 
                    'statusMessage'=>'Call Failed. Unable to write imageFile');
}

// We are done
echo json_encode($returnStatus);

