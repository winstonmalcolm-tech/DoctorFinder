<?php 
    require '../model/dbconfig.php';
    require '../model/dbMethods.php';

    header('Conent-Type: application/json');

    if (isset($_GET['id'])) {
        $docObj = new Doctors();
        $institution_id = $_GET['id'];
        $result = $docObj->getAll($institution_id);

        if ($result != false) {
            echo json_encode($result);
        } else {
            echo json_encode(array());
        }
        
    } else {
        header("HTTP/1.1 404 NOT FOUND");
        echo json_encode(array("message"=>"No ID parameter"));
    }
    