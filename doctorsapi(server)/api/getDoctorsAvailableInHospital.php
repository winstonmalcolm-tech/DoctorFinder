<?php 
    require '../model/dbconfig.php';
    require '../model/ward.php';

    if (isset($_GET['med_id'])) {
        $institution_id = $_GET['med_id'];

        $wardObj = new Ward();

        $result = $wardObj->getDoctorsAvailableInHospital($institution_id);

        if ($result != false) {
            echo json_encode($result);
        } else {
            echo json_encode(array());
        }
    } else {
        header("HTTP/1.1 404 Not Found");
        echo json_encode(array("message" => "Missing url parameter"));
    }