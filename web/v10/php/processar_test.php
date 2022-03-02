<?php

$bd = $_POST['bd'];
$sql_alumne = $_POST['sql_alumne'];

//eliminem el ; final
if (strrpos($sql_alumne, ";") == strlen($sql_alumne)-1) {
	$sql_alumne = substr($sql_alumne, 0, -1);
}

$pwd = file_get_contents('./.pwd');
$conn = mysqli_connect("localhost", "bdquest", $pwd);
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
} else if (gettype($resultset_alumne)=="boolean") { //si en comptes d'una select poso un insert, delete, etd, el resultset retorna boolean en comptes de object, que vol dir que la consulta no retorna el que s'espera
	$resultat = 0;
	$data_alumne = "Warning: la consulta no ha retornat el que s'espera";
	$capcalera = "Problema";
	$res = "{\"resultat\":\"Warning\",\"data\": \"Warning: la consulta no ha retornat el que s'espera\"}";
	echo $res;
} else {

	$data_alumne = array();
	$capcalera = array();

	while ($fieldinfo = mysqli_fetch_field($resultset_alumne)) {
		$capcalera[] = $fieldinfo -> name;
	}

	while($row = mysqli_fetch_row($resultset_alumne)) {
	    $data_alumne[] = $row;
	}

	$resultat = "-1";

	//echo json_encode($data);
	$res = "{\"resultat\":".$resultat.",\"head\":".json_encode($capcalera).",\"data\":".json_encode($data_alumne)."}";

	echo $res;

	mysqli_free_result($resultset_alumne);

}

mysqli_close($conn);

?>
