<?php 

    require '../model/dbconfig.php';
    require '../model/nurses.php';

    header('Content-Type: application/json');

    $data = json_decode(file_get_contents("php://input"));
    $nurseObj = new Nurses();

    $result = $nurseObj->loginNurse($data);

    if ($result != false) {
        $newData = array(
            "user_id" => $result['user_id'],
            "username" => $result['username'],
            "institution" => $result['institution'],
            "institution_id" => $result['institution_id']
        );
        echo json_encode($newData);
    } else {
        echo json_encode(array("message"=>false));
    }