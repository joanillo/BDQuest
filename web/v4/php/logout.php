<?php
session_start(); 
require_once 'vendor/autoload.php';
  
// init configuration
$clientID = '311185250362-5f4p7ng6pksejqv79302ofk89q4vg4p7.apps.googleusercontent.com';
$clientSecret = 'uMMTXWR7WqaC297CsG1DMaHB';
$redirectUri = 'http://localhost/bdquest/v4/php/login.php';
   
// create Client Request to access Google API
$client = new Google_Client();
$client->setClientId($clientID);
$client->setClientSecret($clientSecret);
$client->setRedirectUri($redirectUri);
$client->revokeToken();
unset($_SESSION["email"]);
unset($_SESSION["id_usuari"]);
unset($_SESSION["nom"]);
unset($_SESSION["cognoms"]);
unset($_SESSION["curs"]);
header("Location: ../index.php");
?>