<?php

$bd = $_POST['bd'];
$sql_solucio = $_POST['solucio'];
$sql_alumne = $_POST['sql_alumne'];
$id_quest = $_POST['id_quest'];
$num_pregunta = $_POST['num_pregunta'];
$estat_quest = $_POST['estat_quest'];
$current_id_usuari_quest = $_POST['current_id_usuari_quest'];

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
		$resultat = 1;
	} else {
		$resultat = 0;
	}

	mysqli_select_db($conn,"bdquest") or die('Could not select '.$bd.' database.');
	if ($estat_quest == "inici") {
		#usuari_quest (id_usuari_quest, id_usuari, id_quest, dia, nota)
		$sql = "insert into usuari_quest(id_usuari, id_quest, dia) values(3,$id_quest,now())";
		$resultset = mysqli_query($conn,$sql);
		$last_id = mysqli_insert_id($conn);
	} else {
		$last_id = $current_id_usuari_quest;
	}
	$sql = "select id_quest_detall from quest_detall where id_quest=".$id_quest." and num=".$num_pregunta;
	$resultset = mysqli_query($conn,$sql);
	$row = mysqli_fetch_assoc($resultset);
	$id_quest_detall = $row['id_quest_detall'];
	# usuari_quest_detall (id_usuari_quest_detall, id_usuari_quest, id_quest_detall, valor)
	$sql = "insert into usuari_quest_detall(id_usuari_quest, id_quest_detall, valor) values ($last_id,$id_quest_detall,$resultat)";
	$resultset = mysqli_query($conn,$sql);
	//si és la última pregunta he de fer un update a usuari_quest
	if ($estat_quest == "fi") {
		$sql = "select sum(valor) sum,count(*) num from usuari_quest_detall where id_usuari_quest=$last_id";
		$resultset = mysqli_query($conn,$sql);
		$row = mysqli_fetch_assoc($resultset);
		$num = (float)$row['num'];
		$sum = (float)$row['sum'];
		$nota = ($sum/$num)*10;
		$str_nota = number_format($nota, 2, '.', ''); 
		$sql = "update usuari_quest set nota=$str_nota where id_usuari_quest=$last_id";
		$resultset = mysqli_query($conn,$sql);
	}
	//echo json_encode($data);
	$res = "{\"resultat\":".$resultat.",\"last_id\":".$last_id.",\"data\":".json_encode($data_alumne)."}";

	echo $res;

	mysqli_free_result($resultset_alumne);
	mysqli_free_result($resultset_solucio);

}

mysqli_close($conn);
?>
