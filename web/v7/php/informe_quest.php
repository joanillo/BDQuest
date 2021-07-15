<?php

$id_quest = $_POST['id_quest'];
$id_usuari = $_POST['id_usuari'];

$conn = mysqli_connect("localhost", "bdquest", "keiL2lai");
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');
mysqli_set_charset($conn, 'utf8');

$sql = "select * from informe_quest where id_quest=$id_quest and  id_usuari=$id_usuari and id_usuari_quest=(select max(id_usuari_quest) from informe_quest where id_quest=$id_quest and  id_usuari=$id_usuari)";


$resultset = mysqli_query($conn,$sql);

if (!$resultset) {
	$data = "Error: ".mysqli_error($conn);
} else {

	$data = array();

	while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
	    $data[] = $row;
	}
	mysqli_free_result($resultset);
}

$res = json_encode($data);

echo $res;

mysqli_close($conn);

?>
