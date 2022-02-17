<?php
include("open_db.php");

$sql_alumne = $_POST['sql_alumne'];
$sql_solucio = "select * from provincies";


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

include("close_db.php");
?>
