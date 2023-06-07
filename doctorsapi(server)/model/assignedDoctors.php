<?php 
    class AssignedDoctors extends DBHandler {

        public function newAssignee($data) {
            $sql = "INSERT INTO doctors_assign_tbl (ward_id, doctor_id, institution_id) VALUES (?,?,?);";

            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('iii',$data->ward_id, $data->doctor_id, $data->institution_id);

            if ($stmt->execute()) {
                header('HTTP/1.1 200 OK');
                return true;
            } else {
                header('HTTP/1.1 500 Internal Server Error');
                return false;
            }

        }

        public function removeAssignee($data) {
            $sql = "DELETE FROM doctors_assign_tbl WHERE ward_id=? AND doctor_id=? AND institution_id=?";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('iii', $data->ward_id, $data->doctor_id, $data->institution_id);

            if ($stmt->execute()) {
                header("HTTP/1.1 200 OK");
                return true;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }
        }

        public function getWardAssignees($id) {
            $sql = "SELECT scheduled_doctors.doctor_id, scheduled_doctors.firstName, scheduled_doctors.lastName, scheduled_doctors.telephone FROM scheduled_doctors INNER JOIN doctors_assign_tbl ON scheduled_doctors.doctor_id = doctors_assign_tbl.doctor_id WHERE doctors_assign_tbl.ward_id = ?";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('i', $id);

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

        public function isAssigned($data) {
            $sql = "SELECT * FROM doctors_assign_tbl WHERE institution_id=? AND doctor_id=? AND ward_id=? LIMIT 1";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('iii', $data->institution_id, $data->doctor_id, $data->ward_id);

            if ($stmt->execute()) {
                $result = $stmt->get_result();

                header("HTTP/1.1 200 OK");
                if ($result->num_rows > 0) {
                    return true;
                } else {
                    return false;
                }
            } 

            header("HTTP/1.1 500 Internal Server Error");
            return false;
        }

        
    }