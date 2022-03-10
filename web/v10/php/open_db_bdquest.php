<?php
/*
BDQuest v10 (GPLv3)
@ Joan Quintana - 2021-2022
https://wiki.joanillo.org/index.php/BDQuest
*/

$pwd = file_get_contents('./.pwd');
$conn_bdquest = mysqli_connect("localhost", "bdquest", $pwd);
if (!$conn_bdquest) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn_bdquest,"bdquest") or die('Could not select bdquest database.');
mysqli_set_charset($conn_bdquest, 'utf8');
?>
