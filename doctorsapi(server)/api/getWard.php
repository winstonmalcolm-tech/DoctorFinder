<?php 
    require '../model/dbconfig.php';
    require '../model/ward.php';

    if (isset($_GET['wardId'])) {
        $wardObj = new Ward();
        $id = $_GET['wardId'];

        $result = $wardObj->getWards($id);

        if ($result != false) {
            echo json_encode($result);
        } else {
            echo json_encode(array());
        }
    }

    