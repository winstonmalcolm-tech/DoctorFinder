<?php
    class Ward extends DBHandler {

        public function newWard($data) {
            $sql = "INSERT INTO ward_tbl (ward_name, institution_id) VALUES (?,?);";

            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('ss', $data->ward_name, $data->institution_id);

            if ($stmt->execute()) {
                header("HTTP/1.1 200 OK");
                return true;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }
        }

        public function getDoctorsAvailableInHospital($institution_id) {
            $sql = "SELECT sd.doctor_id, sd.firstName, sd.lastName, sd.telephone, wt.ward_name FROM scheduled_doctors AS sd INNER JOIN ward_tbl AS wt ON sd.institution_id = wt.institution_id INNER JOIN doctors_assign_tbl AS dat ON wt.ward_id = dat.ward_id WHERE dat.institution_id = ? AND dat.doctor_id = sd.doctor_id;";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('i', $institution_id);

            if ($stmt->execute()) {
                $rows = array();
                $result = $stmt->get_result();

                while ($row = $result->fetch_assoc()) {
                    array_push($rows, $row);
                }
                header("HTTP/1.1 200 OK");
                return $rows;
            }
            header("HTTP/1.1 500 Internal Server Error");
            return false;
        }

        public function getWards($institutionId) {
            $sql = "SELECT * FROM ward_tbl WHERE institution_id=?;";
            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param("i", $institutionId);

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

        public function deleteWard($id) {
            $sql = "DELETE wt, da FROM ward_tbl wt LEFT JOIN doctors_assign_tbl da ON wt.ward_id = da.ward_id WHERE wt.ward_id=?";

            $stmt = $this->dbconnect()->prepare($sql);
            $stmt->bind_param('i', $id);

            if ($stmt->execute()) {
                header("HTTP/1.1 200 OK");
                return true;
            } else {
                header("HTTP/1.1 500 Internal Server Error");
                return false;
            }
        }
    }
?>