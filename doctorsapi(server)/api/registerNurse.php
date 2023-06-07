<?php 

    require '../model/dbconfig.php';
    require '../model/nurses.php';

    header('Content-Type: application/json');

    $data = json_decode(file_get_contents("php://input"));
    $nurseObj = new Nurses();

    $result = $nurseObj->registerNurse($data);

    if ($result != false) {
        echo json_encode($result);
    } else {
        echo json_encode(array("message"=>"Error Registering"));
    }