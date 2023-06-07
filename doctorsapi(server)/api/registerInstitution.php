<?php 
    require '../model/dbconfig.php';
    require '../model/medical_institution.php';

    header("Content-Type: application/json");

    //echo $_SERVER['REQUEST_METHOD'];

    $data = json_decode(file_get_contents("php://input"));

    $medObj = new MedicalInstitution();

    $result = $medObj->registerInstitution($data);

    if($result != false) {
        header("HTTP/1.1 200 OK");
        echo json_encode($result);
    } else {
        header("HTTP/1.1 500 INTERNAL SERVER ERROR");
        echo json_encode(array("message" => "Error registering"));
    }