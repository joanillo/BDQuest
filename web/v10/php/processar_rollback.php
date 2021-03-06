<?php
/*
BDQuest v10 (GPLv3)
@ Joan Quintana - 2021-2022
https://wiki.joanillo.org/index.php/BDQuest
*/

$bd = $_POST['bd'];
$sql_solucio = $_POST['solucio'];
$sql_alumne = $_POST['sql_alumne'];
$id_quest = $_POST['id_quest'];
$num_pregunta = $_POST['num_pregunta'];
$estat_quest = $_POST['estat_quest'];
$current_id_alumne_quest = $_POST['current_id_alumne_quest'];
$id_alumne = $_POST['id_alumne'];

//eliminem el ; final
if (strrpos($sql_solucio, ";") == strlen($sql_solucio)-1) {
	$sql_solucio = substr($sql_solucio, 0, -1);
}

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

//poso en un array les comprovacions d'aquesta pregunta
mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');
$arr_comprovacions = array();
$resultset_comprovacions = mysqli_query($conn,"SELECT comprovacio FROM ((quest_detall qd INNER JOIN bd_questio bdq ON qd.id_bd_questio=bdq.id_bd_questio) INNER JOIN bd_questio_comprovacio bdqc ON bdq.id_bd_questio=bdqc.id_bd_questio) WHERE qd.id_quest=$id_quest and num_pregunta=$num_pregunta ORDER BY ordre");
while($row = mysqli_fetch_array($resultset_comprovacions, MYSQLI_ASSOC)) {
    $arr_comprovacions[] = $row;
}
mysqli_free_result($resultset_comprovacions);
//echo var_dump($arr_comprovacions);

mysqli_select_db($conn,$bd) or die('Could not select '.$bd.' database.');

//alumne
$num_files_afectades = "";
$resultset = mysqli_query($conn,"start transaction");

$sql_pieces = explode(";", $sql_alumne);

$no_hi_ha_error = true;

foreach ($sql_pieces as &$sql_piece) {
	$resultset_alumne = mysqli_query($conn,$sql_piece);
	if ($resultset_alumne===false) $no_hi_ha_error = $no_hi_ha_error && false;
	$affected_rows = mysqli_affected_rows($conn);
	$num_files_afectades .= "Affected rows: ".$affected_rows."; ";
}

//echo var_dump($no_hi_ha_error);

$resultat = 0;

//if (!$resultset_alumne) {
if (!$no_hi_ha_error) {
	$resultat = 0;
	//printf("Error: %s\n", mysqli_error($conn));
	$data_alumne = "Error: ".mysqli_error($conn);
} else {
	//si no d??na error, he de fer les comprovacions i guardar el $data_alumne[] de les comprovacions.
	//echo json_encode($arr_comprovacions);
	foreach ($arr_comprovacions as $sql_comprovacio) {
	    $data_alumne = array();
		$resultset_alumne = mysqli_query($conn,$sql_comprovacio["comprovacio"]);
		while($row = mysqli_fetch_array($resultset_alumne, MYSQLI_ASSOC)) {
		    $data_alumne[] = $row;
		}
		mysqli_free_result($resultset_alumne);
	}

}
$resultset = mysqli_query($conn,"rollback");


//soluci??
$resultset = mysqli_query($conn,"start transaction");
//$resultset_solucio = mysqli_query($conn,$sql_solucio);
$sql_pieces = explode(";", $sql_solucio);

foreach ($sql_pieces as &$sql_piece) {
	$resultset_solucio = mysqli_query($conn,$sql_piece);
}

foreach ($arr_comprovacions as $sql_comprovacio) {
    $data_solucio = array();
	$resultset_solucio = mysqli_query($conn,$sql_comprovacio["comprovacio"]);
	while($row = mysqli_fetch_array($resultset_solucio, MYSQLI_ASSOC)) {
	    $data_solucio[] = $row;
	}
	mysqli_free_result($resultset_solucio);
}

$resultset = mysqli_query($conn,"rollback");

if (strcmp(json_encode($data_alumne), json_encode($data_solucio)) == 0) {
	$resultat = 1;
} else {
	$resultat = 0;
}

// ==============
mysqli_select_db($conn,"bdquest") or die('Could not select '.$bd.' database.');

if ($estat_quest == "inici" || $estat_quest == "finici") {
	#alumne_quest (id_alumne_quest, id_alumne, id_quest, dia, nota)
	$sql = "insert into alumne_quest(id_alumne, id_quest, dia) values($id_alumne,$id_quest,now())";
	$resultset = mysqli_query($conn,$sql);
	$last_id = mysqli_insert_id($conn);
	if ($estat_quest == "finici") $estat_quest = "fi";
} else {
	$last_id = $current_id_alumne_quest;
}

$sql = "select id_quest_detall from quest_detall where id_quest=".$id_quest." and num_pregunta=".$num_pregunta;
$resultset = mysqli_query($conn,$sql);
$row = mysqli_fetch_assoc($resultset);
$id_quest_detall = $row['id_quest_detall'];
//$sql = "insert into alumne_quest_detall(id_alumne_quest, id_quest_detall, valor) values ($last_id,$id_quest_detall,$resultat)";
$sql = "insert into alumne_quest_detall(id_alumne_quest, id_quest_detall, valor, resposta) values ($last_id,$id_quest_detall,$resultat,'".fixQuotes($sql_alumne)."')";

$resultset = mysqli_query($conn,$sql);
//si ??s la ??ltima pregunta he de fer un update a alumne_quest
$str_nota = "-1";
if ($estat_quest == "fi") {
	$sql = "select sum(valor) sum,count(*) num from alumne_quest_detall where id_alumne_quest=$last_id";
	$resultset = mysqli_query($conn,$sql);
	$row = mysqli_fetch_assoc($resultset);
	$num = (float)$row['num'];
	$sum = (float)$row['sum'];
	$nota = ($sum/$num)*10;
	$str_nota = number_format($nota, 2, '.', ''); 
	$sql = "update alumne_quest set nota=$str_nota where id_alumne_quest=$last_id";
	$resultset = mysqli_query($conn,$sql);
}

//$res = "{\"nota\":".$str_nota.",\"resultat\":".$resultat.",\"last_id\":".$last_id.",\"data\":".json_encode($num_files_afectades)."}";
$res = "{\"nota\":".$str_nota.",\"resultat\":".$resultat.",\"last_id\":".$last_id.",\"data\":\"".$num_files_afectades."\"}";

echo $res;


mysqli_close($conn);

function fixQuotes($cadena){
	return str_replace("'","''",$cadena);
}

?>
