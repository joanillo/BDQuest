<?php

$bd = $_POST['bd'];
$sql_solucio = $_POST['solucio'];
$sql_alumne = $_POST['sql_alumne'];
$id_quest = $_POST['id_quest'];
$num_pregunta = $_POST['num_pregunta'];
$estat_quest = $_POST['estat_quest'];
$current_id_alumne_quest = $_POST['current_id_alumne_quest'];
$id_alumne = $_POST['id_alumne'];

//s'ha de mirar els casos particulars. Comencem amb els create tables
if (strrpos(strtolower($sql_solucio), "create table")==0) {
	$arr = explode(" ", $sql_solucio);
	$object_old = $arr[2];
	$object_new = $arr[2]."_".$id_alumne;
} else if (strrpos(strtolower($sql_solucio), "drop table")==0) {
	$arr = explode(" ", $sql_solucio);
	$object_old = $arr[2];
	$object_new = $arr[2]."_".$id_alumne;
} else if (strrpos(strtolower($sql_solucio), "alter table")==0) {
	$arr = explode(" ", $sql_solucio);
	$object_old = $arr[2];
	$object_new = $arr[2]."_".$id_alumne;
}

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

mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');

//poso en un array les comprovacions PRE d'aquesta pregunta
$arr_pres = array();
$resultset_pres = mysqli_query($conn,"select sentencia_prepost from quest_detall qd, bd_questio bdq, bd_questio_prepost bdqp where qd.id_bd_questio=bdq.id_bd_questio and bdq.id_bd_questio=bdqp.id_bd_questio and qd.id_quest=$id_quest and num_pregunta=$num_pregunta and tipus='PRE' order by ordre");
while($row = mysqli_fetch_array($resultset_pres, MYSQLI_ASSOC)) {
    $arr_pres[] = $row;
}
mysqli_free_result($resultset_pres);

//poso en un array les comprovacions POST d'aquesta pregunta
$arr_posts = array();
$resultset_posts = mysqli_query($conn,"select sentencia_prepost from quest_detall qd, bd_questio bdq, bd_questio_prepost bdqp where qd.id_bd_questio=bdq.id_bd_questio and bdq.id_bd_questio=bdqp.id_bd_questio and qd.id_quest=$id_quest and num_pregunta=$num_pregunta and tipus='POST' order by ordre");
while($row = mysqli_fetch_array($resultset_posts, MYSQLI_ASSOC)) {
    $arr_posts[] = $row;
}
mysqli_free_result($resultset_posts);
//echo var_dump($arr_posts);

mysqli_select_db($conn,$bd) or die('Could not select '.$bd.' database.');

//solució
$data_solucio = "";

foreach ($arr_pres as $sql_pre) {
	$sql = str_replace($object_old, $object_new, $sql_pre["sentencia_prepost"]);
	$resultset = mysqli_query($conn, $sql);
	if ($resultset) $data_solucio.="OK;";
	$data_solucio.=mysqli_affected_rows($conn).";";
}


$sql = str_replace($object_old, $object_new, $sql_solucio);
$resultset = mysqli_query($conn, $sql);
if ($resultset) $data_solucio.="OK;";
$data_solucio.=mysqli_affected_rows($conn).";";

foreach ($arr_posts as $sql_post) {
	$sql = str_replace($object_old, $object_new, $sql_post["sentencia_prepost"]);
	$resultset = mysqli_query($conn, $sql);
	if ($resultset) $data_solucio.="OK;";
	$data_solucio.=mysqli_affected_rows($conn).";";
}


//alumne
$data_alumne = "";

foreach ($arr_pres as $sql_pre) {
	$sql = str_replace($object_old, $object_new, $sql_pre["sentencia_prepost"]);
	$resultset = mysqli_query($conn, $sql);
	if ($resultset) $data_alumne.="OK;";
	$data_alumne.=mysqli_affected_rows($conn).";";
}

$sql = str_replace($object_old, $object_new, $sql_alumne);
$resultset = mysqli_query($conn, $sql);
if ($resultset) $data_alumne.="OK;";
$data_alumne.=mysqli_affected_rows($conn).";";

foreach ($arr_posts as $sql_post) {
	$sql = str_replace($object_old, $object_new, $sql_post["sentencia_prepost"]);
	$resultset = mysqli_query($conn, $sql);
	if ($resultset) $data_alumne.="OK;";
	$data_alumne.=mysqli_affected_rows($conn).";";
}

if (strcmp(json_encode($data_alumne), json_encode($data_solucio)) == 0) {
	$resultat = 1;
	$data_mostrar = "OK";
} else {
	$resultat = 0;
	$data_mostrar = "INCORRECTE";
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

$res = "{\"nota\":".$str_nota.",\"resultat\":".$resultat.",\"last_id\":".$last_id.",\"data\":\"".$data_mostrar."\"}";

echo $res;

mysqli_close($conn);

function fixQuotes($cadena){
	return str_replace("'","''",$cadena);
}

?>