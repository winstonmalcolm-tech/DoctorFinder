<?php
    require '../model/dbconfig.php';
    require '../model/nurses.php';

    header('Content-Type: application/json');

    if (isset($_GET['username'])) {
        $username = $_GET['username'];

        $medObj = new Nurses();

        $result = $medObj->isNurseUsernameAvailable($username);

        if ($result != 'error') {
            echo json_encode(array("count" => $result));
        } else {
            echo json_encode(array("message" => "Internal Server Error"));
        }


    } else {
        header("HTTP/1.1 404 Not Found");
        echo json_encode(array("message" => "Not Found"));
    }