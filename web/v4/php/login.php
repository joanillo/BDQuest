<?php
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
$client->addScope("email");
$client->addScope("profile");
  
// authenticate code from Google OAuth Flow
if (isset($_GET['code'])) {
  $token = $client->fetchAccessTokenWithAuthCode($_GET['code']);
  $client->setAccessToken($token['access_token']);
   
  // get profile info
  $google_oauth = new Google_Service_Oauth2($client);
  $google_account_info = $google_oauth->userinfo->get();
  $email =  $google_account_info->email;
  $name =  $google_account_info->name;
  
  session_start(); 
  $_SESSION["email"] = $email;

  // recuperem de la base de dades les dades d'aquest usuari:
  $conn = mysqli_connect("localhost", "bdquest", "keiL2lai");
  if (!$conn) {
      $log->error('Could not connect: ' . mysqli_error());
      die('Could not connect: ' . mysqli_error());
  }
  mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');
  mysqli_set_charset($conn, 'utf8');
  $sql = "select * from usuari where email='$email'";
  $resultset = mysqli_query($conn, $sql);
  $row = mysqli_fetch_assoc($resultset);
  $_SESSION["id_usuari"] = $row['id_usuari'];
  $_SESSION["nom"] = $row['nom'];
  $_SESSION["cognoms"] = $row['cognoms'];
  $_SESSION["curs"] = $row['curs'];
  mysqli_free_result($resultset);
  mysqli_close($conn);

  header("Location: ../index.php");
} else {
  header("Location: ".$client->createAuthUrl());
}
?>