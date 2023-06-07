<?php 

    class DBHandler {
        private $host = 'localhost';
        private $username = 'root';
        private $password = '';
        private $dbName = 'doctors_db';
        protected static $mysqli;


        protected function dbconnect() {
            self::$mysqli = new mysqli($this->host, $this->username, $this->password, $this->dbName);

            if (self::$mysqli->connect_error) {
                die("Connection faild: ".self::$mysqli->connect_error);
            }
            return self::$mysqli;
        }
    }