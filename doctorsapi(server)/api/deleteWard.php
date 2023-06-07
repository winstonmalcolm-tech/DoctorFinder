<?php
    require '../model/dbconfig.php';
    require '../model/ward.php';

    if (isset($_GET['ward_id'])) {
        $ward_id = $_GET['ward_id'];

        $wardObj = new Ward();

        $result = $wardObj->deleteWard($ward_id);

        if ($result == true) {
            echo json_encode(array("message"=>true));
        } else {
            echo json_encode(array("message"=>false));
        }
    } else {
        header("HTTP/1.1 404 Not Found");
        echo json_encode(array("message"=>"parameter not found"));
    }