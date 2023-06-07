<?php 

    require '../model/dbconfig.php';
    require '../model/assignedDoctors.php';

    if (isset($_GET['id'])) {   

        $id = $_GET['id'];

        $assObj = new AssignedDoctors();

        $result = $assObj->getWardAssignees($id);

        if ($result != false) {
            echo json_encode($result);
        } else {
            echo json_encode(array("message" => "Server Error"));
        }


    } else {
        header("HTTP/1.1 404 Not Found");
        echo json_encode(array("message"=>"No url arguments found"));
     }