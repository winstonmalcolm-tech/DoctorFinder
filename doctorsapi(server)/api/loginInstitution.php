<?php 
    require '../model/dbconfig.php';
    require '../model/medical_institution.php';

    header("Content-Type: application/json");

    $data = json_decode(file_get_contents("php://input"));

    $medObj = new MedicalInstitution();

    $result = $medObj->loginInstitution($data);

    if ($result != false) {
        header("HTTP/1.1 200 OK");
        $newData = array(
            "med_id" => $result['med_id'],
            "username" => $result['username'],
            "name_of_institution" => $result['name_of_institution']
        );
        echo json_encode($newData);
    } else {
        header("HTTP/1.1 404 NOT FOUND");
        echo json_encode(array("message"=> $result));
    }