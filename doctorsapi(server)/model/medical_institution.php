<?php
    class MedicalInstitution extends DBHandler{

        public function registerInstitution($data) {
            $sql = "INSERT INTO medical_institution_tbl (username, med_password, name_of_institution) VALUES (?,?,?);";

            $stmt = $this->dbconnect()->prepare($sql);
            $newPassword = password_hash($data->password,PASSWORD_BCRYPT);
            $stmt->bind_param('sss', $data->username, $newPassword, $data->name_of_institution);
           
            if($stmt->execute()) {
                $id =$stmt->insert_id;
                $data->med_id = $id;
                return $data;
            } else {
                return false;
            }
        }

        public function isUsernameAvailable($username) {
            $sql = "SELECT * FROM medical_institution_tbl WHERE username=?";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param("s", $username);

            if ($stmt->execute()) {
                $result = $stmt->get_result();
                header("HTTP/1.1 200 OK");
                return $result->num_rows;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return "error";
            }
        }

        public function  loginInstitution($data) {
            $sql = "SELECT * FROM medical_institution_tbl WHERE username=? LIMIT 1";

            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('s', $data->username);

            if ($stmt->execute()) {
                $result = $stmt->get_result();

                if ($result->num_rows > 0) {
                    $row = $result->fetch_assoc();
                    if (password_verify($data->password, $row['med_password'])) {
                        return $row;
                    } else {
                        return false;
                    }
                } else {
                    return false;
                }
            } else {
                return $stmt->error;
            }
        }

        public function getInstitutions() {
            $sql = "SELECT name_of_institution, med_id FROM medical_institution_tbl";
            $stmt = $this->dbconnect()->prepare($sql);

            if ($stmt->execute()) {
                $result = $stmt->get_result();

                $rows = array();

                while ($row = $result->fetch_assoc()) {
                    array_push($rows, $row);
                }

                
                header("HTTP/1.1 200 OK");
                return $rows;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }
        }
    }