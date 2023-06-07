<?php 

    require '../model/dbconfig.php';
    require '../model/dbMethods.php';

    header("Content-Type: application/json");

    
    $data = json_decode(file_get_contents('php://input'), true);

    $docObj = new Doctors();
    $result = $docObj->edit($data['doctorId'], $data);

    if ($result == true) {
        header("HTTP/1.1 200 OK");
        echo json_encode(array("message"=> true));
    } else {
        header("HTTP/1.1 500 Internal Server Error");
        echo json_encode(array("message"=>false));
    }

    

