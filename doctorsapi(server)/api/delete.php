<?php 
    require '../model/dbconfig.php';
    require '../model/dbMethods.php';

    header('Content-Type: application/json');

    if (isset($_GET['id'])) {
        $id = $_GET['id'];

        $docObj = new Doctors();

        $result = $docObj->delete($id);

        if ($result == true) {
            header("HTTP/1.1 200 OK");
            echo json_encode(array('message'=>true));
        } else {
            header("HTTP/1.1 404 NOT FOUND");
            echo json_encode(array('message'=>false));
        }
    }