<?php
include("open_db_bdquest.php");

$id_quest = $_POST['id_quest'];
$num_pregunta = $_POST['num_pregunta'];

//echo $id_quest;
//echo $num_pregunta;

$sql = "select id_quest_detall, bd, questio, rollback, solucio from quest_detall qd, bd_questio bdq, bd where qd.id_bd_questio=bdq.id_bd_questio and bd.id_bd=bdq.id_bd and id_quest=".$id_quest." and num_pregunta=".$num_pregunta;

//echo $sql;

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
