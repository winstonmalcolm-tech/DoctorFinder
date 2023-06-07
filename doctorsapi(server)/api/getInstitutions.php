<?php 
    require '../model/dbconfig.php';
    require '../model/medical_institution.php';

    header("Content-Type: application/json");

    $medObj = new MedicalInstitution();

    $result = $medObj->getInstitutions();

    if ($result != false) {
        echo json_encode($result);
    } else {
        echo json_encode(array("Message"=>"Server Error"));
    }