<?php 
    require '../model/dbconfig.php';
    require '../model/assignedDoctors.php';

    header('Content-type: application/json');

    $data = json_decode(file_get_contents("php://input"));

    $assObj = new AssignedDoctors();

    $result = $assObj->newAssignee($data);

    if ($result == true) {
        echo json_encode(array("message"=> true));
    } else {
        echo json_encode(array("message"=> false));
    }