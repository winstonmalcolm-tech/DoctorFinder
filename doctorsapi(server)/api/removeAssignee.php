<?php 
    require '../model/dbconfig.php';
    require '../model/assignedDoctors.php';

    $data = json_decode(file_get_contents("php://input"));

    $assObj = new AssignedDoctors();

    $result = $assObj->removeAssignee($data);

    if ($result == true) {
        echo json_encode(array("message"=>true));
    } else {
        echo json_encode(array("message"=>false));
    }
    