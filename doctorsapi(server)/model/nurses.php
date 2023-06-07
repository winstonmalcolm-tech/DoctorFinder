<?php 
    class Nurses extends DBHandler{

        function registerNurse($data) {
            $sql = "INSERT INTO nurses_tbl (username, user_password, institution, institution_id) VALUES (?,?,?,?);";

            $stmt = $this->dbconnect()->prepare($sql);
            $newPassword = password_hash($data->password, PASSWORD_BCRYPT);
            $stmt->bind_param('sssi',$data->username, $newPassword, $data->institution, $data->institution_id);

            if ($stmt->execute()) {
                header("HTTP/1.1 200 OK");
                return $data;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }
        }

        function isNurseUsernameAvailable($username) {
            $sql = "SELECT * FROM nurses_tbl WHERE username=? LIMIT 1";

            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('s', $username);

            if ($stmt->execute()) {
                $result = $stmt->get_result();
                header("HTTP/1.1 200 OK");
                return $result->num_rows;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return "error";
            }
            
        }

        function loginNurse($data) {
            $sql = "SELECT user_id, username, user_password, institution, institution_id FROM nurses_tbl WHERE username=? LIMIT 1";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('s', $data->username);

            if ($stmt->execute()) {
                $result = $stmt->get_result();
                if ($result->num_rows > 0) {
                    $row = $result->fetch_assoc();
                    if(password_verify($data->password, $row["user_password"])) {
                        header("HTTP/1.1 200 OK");
                        return $row;
                    } else {
                        header("HTTP/1.1 404 Not Found");
                        return false;
                    }
                } else {
                    header("HTTP/1.1 404 Not Found");
                    return false;
                }
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }
        }
    }