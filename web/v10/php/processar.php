<?php

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


$resultset_alumne = mysqli_query($conn,$sql_alumne);

if (!$resultset_alumne) {
	$resultat = 0;
	//printf("Error: %s\n", mysqli_error($conn));
	$data_alumne = "Error: ".mysqli_error($conn);
	$capcalera = "Problema...";
} else if (gettype($resultset_alumne)=="boolean") { //si en comptes d'una select poso un insert, delete, etc, el resultset retorna boolean en comptes de object, que vol dir que la consulta no retorna el que s'espera
	$resultat = 0;
	$data_alumne = "Warning: la consulta no ha retornat el que s'espera";
	$capcalera = "Problema...";
} else {

	$resultset_solucio = mysqli_query($conn,$sql_solucio);

	$data_alumne = array();
	$data_solucio = array();
	$capcalera = array();

	while ($fieldinfo = mysqli_fetch_field($resultset_alumne)) {
		$capcalera[] = $fieldinfo -> name;
	}

	while($row = mysqli_fetch_row($resultset_alumne)) {
	    $data_alumne[] = $row;
	}

	while($row = mysqli_fetch_row($resultset_solucio)) {
	    $data_solucio[] = $row;
	}

	if (strcmp(json_encode($data_alumne), json_encode($data_solucio)) == 0) {
		$resultat = 1;
	} else {
		$resultat = 0;
	}

	mysqli_free_result($resultset_alumne);
	mysqli_free_result($resultset_solucio);
}

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
# alumne_quest_detall (id_alumne_quest_detall, id_alumne_quest, id_quest_detall, valor)
//$sql = "insert into alumne_quest_detall(id_alumne_quest, id_quest_detall, valor) values ($last_id,$id_quest_detall,$resultat)";
$sql = "insert into alumne_quest_detall(id_alumne_quest, id_quest_detall, valor, resposta) values ($last_id,$id_quest_detall,$resultat,'".fixQuotes($sql_alumne)."')";
$resultset = mysqli_query($conn,$sql);
//si és la última pregunta he de fer un update a alumne_quest
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
//echo json_encode($data);
$res = "{\"nota\":".$str_nota.",\"resultat\":".$resultat.",\"last_id\":".$last_id.",\"head\":".json_encode($capcalera).",\"data\":".json_encode($data_alumne)."}";

echo $res;


mysqli_close($conn);

function fixQuotes($cadena){
	return str_replace("'","''",$cadena);
}

?>
