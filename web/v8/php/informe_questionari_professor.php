<?php
include("open_db_bdquest.php");

$id_quest_detall = $_POST['id_quest_detall'];

$sql = "select nom, cognoms, quest, nota, q.dia, questio, valor, resposta, solucio from alumne a, alumne_quest aq, quest q, quest_detall qd, bd_questio bdq, alumne_quest_detall aqd where a.id_alumne=aq.id_alumne and aq.id_quest=q.id_quest and q.id_quest=qd.id_quest and bdq.id_bd_questio=qd.id_bd_questio and aqd.id_quest_detall=qd.id_quest_detall and aq.id_alumne_quest=aqd.id_alumne_quest and aq.id_alumne_quest=$id_quest_detall";

$resultset = mysqli_query($conn_bdquest,$sql);

$data = array();

while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
    $data[] = $row;
}

echo json_encode($data);
mysqli_free_result($resultset);

include("close_db_bdquest.php");
?>
