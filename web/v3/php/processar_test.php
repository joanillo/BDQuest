<?php

$bd = $_POST['bd'];
$sql_alumne = $_POST['sql_alumne'];

$conn = mysqli_connect("localhost", "bdquest", "keiL2lai");
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,$bd) or die('Could not select '.$bd.' database.');
mysqli_set_charset($conn, 'utf8');


$resultset_alumne = mysqli_query($conn,$sql_alumne);

if (!$resultset_alumne) {
	//printf("Error: %s\n", mysqli_error($conn));
	$res = "{\"resultat\":\"ERROR\",\"data\": \"Error: ".mysqli_error($conn)."\"}";
	echo $res;
} else {

	$data_alumne = array();

	while($row = mysqli_fetch_array($resultset_alumne, MYSQLI_ASSOC)) {
	    $data_alumne[] = $row;
	}

	$resultat = "-1";

	//echo json_encode($data);
	$res = "{\"resultat\":".$resultat.",\"data\":".json_encode($data_alumne)."}";

	echo $res;

	mysqli_free_result($resultset_alumne);

}

mysqli_close($conn);
?>
