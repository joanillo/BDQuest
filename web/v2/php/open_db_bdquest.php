<?php
$conn_bdquest = mysqli_connect("localhost", "bdquest", "keiL2lai");
if (!$conn_bdquest) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn_bdquest,"bdquest") or die('Could not select bdquest database.');
mysqli_set_charset($conn_bdquest, 'utf8');
?>
