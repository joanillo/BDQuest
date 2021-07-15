<?php
include("open_db_bdquest.php");

$id_quest = $_POST['id_quest'];

$sql = "select count(*) as num_preguntes from quest_detall where id_quest=".$id_quest;
$resultset = mysqli_query($conn_bdquest,$sql);
$row = mysqli_fetch_assoc($resultset);
$num_preguntes = $row['num_preguntes'];

$sql = "select random from quest where id_quest=".$id_quest;
$resultset = mysqli_query($conn_bdquest,$sql);
$row = mysqli_fetch_assoc($resultset);
$random = $row['random'];

$llista_preguntes = range(1, $num_preguntes);
if ($random == 1) shuffle($llista_preguntes);
$arr_llista_preguntes = "[".implode(",", $llista_preguntes)."]";

$res = "{\"num_preguntes\":".$num_preguntes.",\"arr_preguntes\":".$arr_llista_preguntes."}";
echo $res;
mysqli_free_result($resultset);

include("close_db_bdquest.php");
?>
