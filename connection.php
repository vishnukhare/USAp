<?php
$servername = getenv('DB_HOST') ?: 'db'; 
$username = getenv('DB_USER') ?: 'user';
$password = getenv('DB_PASSWORD') ?: 'password'; 
$dbname = getenv('DB_NAME') ?: 'edoc'; 

$database = new mysqli($servername, $username, $password, $dbname);

if ($database->connect_error) {
    die("Échec de la connexion : " . $database->connect_error);
}


