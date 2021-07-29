<?php
$email = $_POST['email'];

include("open_db_bdquest.php");

//només es carreguen els qüestionaris del grup a què pertany l'alumne
$sql = "select id_quest, quest from alumne a, professor p, quest q where a.curs=p.curs and q.id_professor=p.id_professor and a.email='$email' and q.actiu=1 order by id_quest";
$resultset = mysqli_query($conn_bdquest,$sql);

if (!$resultset) {
	//printf("Error: %s\n", mysqli_error($conn));
	$res = "{\"resultat\":\"ERROR\",\"data\": \"Error: ".mysqli_error($conn_bdquest)."\"}";
	echo $res;
} else {

	$data = array();

	while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
	    $data[] = $row;
	}

	echo json_encode($data);
	mysqli_free_result($resultset);
}

include("close_db_bdquest.php");
?>

