<?php

$bd = $_POST['bd'];
$sql_solucio = $_POST['solucio'];
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

	$resultset_solucio = mysqli_query($conn,$sql_solucio);

	$data_alumne = array();
	$data_solucio = array();

	while($row = mysqli_fetch_array($resultset_alumne, MYSQLI_ASSOC)) {
	    $data_alumne[] = $row;
	}

	while($row = mysqli_fetch_array($resultset_solucio, MYSQLI_ASSOC)) {
	    $data_solucio[] = $row;
	}

	if (strcmp(json_encode($data_alumne), json_encode($data_solucio)) == 0) {
		$resultat = 10;
	} else {
		$resultat = 0;
	}

	//echo json_encode($data);
	$res = "{\"resultat\":".$resultat.",\"data\":".json_encode($data_alumne)."}";

	echo $res;

	mysqli_free_result($resultset_alumne);
	mysqli_free_result($resultset_solucio);

}

mysqli_close($conn);
?>
