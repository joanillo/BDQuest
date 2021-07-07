<?php
$conn = mysqli_connect("localhost", "bdquest", "keiL2lai");
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,"municipis") or die('Could not select municipis database.');
mysqli_set_charset($conn, 'utf8');
?>
