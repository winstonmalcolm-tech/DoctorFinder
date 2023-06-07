<?php 
    class Doctors extends DBHandler {

        public function newDoctor($doctor) {
            $sql = "INSERT INTO scheduled_doctors (firstName, lastName, telephone, institution_id) VALUES (?,?,?,?);";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param("sssi", $doctor->firstName, $doctor->lastName, $doctor->telephone, $doctor->institution_id);
            
            if (!$stmt->execute()) {
                return $stmt->error;
            }
            $stmt->close();
            $this->dbconnect()->close();
            return true;
        }

        public function getAll($id) {
            $sql = "SELECT * FROM scheduled_doctors WHERE institution_id=?";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('i', $id);
            $data = array();

            if ($stmt->execute()) {
                $result = $stmt->get_result();

                while ($row = $result->fetch_assoc()) {
                    array_push($data, $row);
                }
                
                $stmt->close();
                $this->dbconnect()->close();
                header("HTTP/1.1 200 0K");
                return $data;
            } else {

                $stmt->close();
                $this->dbconnect()->close();
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }  
        }

        public function edit($id, $updatedData) {
            $sql = "UPDATE scheduled_doctors SET firstName=?, lastName=?, telephone=? WHERE doctor_id=? LIMIT 1";

            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param("sssi", $updatedData['firstName'], $updatedData['lastName'], $updatedData['telephone'], $id);
            
            if(!$stmt->execute()) {
                return $stmt->error;
            } else {
                $stmt->close();
                $this->dbconnect()->close();
                return true;
            }
        }

        public function delete($id) {
            $sql = "DELETE sd, da FROM scheduled_doctors sd LEFT JOIN doctors_assign_tbl da ON sd.doctor_id = da.doctor_id WHERE sd.doctor_id=?";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('i', $id);

            if ($stmt->execute()) {
                return true;
            } else {
                return $stmt->error;
            }
        }


    }