<?php

$email = $_POST['email'];

$conn = mysqli_connect("localhost", "bdquest", "keiL2lai");
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,'bdquest') or die('Could not select bdquest database.');
mysqli_set_charset($conn, 'utf8');

$sql = "select * from alumne where email='$email' and actiu=1";
$resultset = mysqli_query($conn, $sql);

if (!$resultset) {
	//printf("Error: %s\n", mysqli_error($conn));
	$res = "{\"resultat\":\"ERROR\",\"data\": \"Error: ".mysqli_error($conn)."\"}";
	echo $res;
} else {
	$row = mysqli_fetch_assoc($resultset);

	$data = array();
	$data[] = $row;

	$res = json_encode($data);

	echo $res;

	mysqli_free_result($resultset);

}

mysqli_close($conn);
?>




