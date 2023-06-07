<?php
    require '../model/dbconfig.php';
    require '../model/dbMethods.php';

    header("Content-Type: application/json");

    $data = json_decode(file_get_contents('php://input'));

    if ( $data == null) {
        header("HTTP/1.1 400 Bad Request");
        echo json_encode(array("message" => "empty object"));
        exit;
    } 

    //var_dump($data->data[1]->firstName);
    $post = new Doctors();
    $result = $post->newDoctor($data);

    if ($result == true) {
        header("HTTP/1.1 200 OK");
        echo json_encode(array("message"=>true));
    } else {
        header("HTTP/1.1 500 Interal Server Error");
        echo json_encode(array("message"=> $result));
    }
?>  