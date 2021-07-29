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

//alumne
$num_files_afectades = "";
$resultset = mysqli_query($conn,"start transaction");

$sql_pieces = explode(";", $sql_alumne);

foreach ($sql_pieces as &$sql_piece) {
	$resultset_alumne = mysqli_query($conn,$sql_piece);
	$affected_rows = mysqli_affected_rows($conn);
	$num_files_afectades .= "Affected rows: ".$affected_rows."; ";
}


if (!$resultset_alumne) {
	//printf("Error: %s\n", mysqli_error($conn));
	$res = "{\"resultat\":\"ERROR\",\"data\": \"Error: ".mysqli_error($conn)."\"}";
	echo $res;
} else {
	$resultat = "-1";

	//echo json_encode($data);
	$res = "{\"resultat\":".$resultat.",\"data\":\"".$num_files_afectades."\"}";

	echo $res;
}
$resultset = mysqli_query($conn,"rollback");

mysqli_close($conn);

function fixQuotes($cadena){
	return str_replace("'","''",$cadena);
}

?>
