<?php
include("open_db_bdquest.php");

$id_quest_detall = $_POST['id_quest_detall'];

$sql = "select nom, cognoms, quest, nota, q.dia, questio, valor, resposta, solucio from (((((alumne a INNER JOIN alumne_quest aq ON a.id_alumne=aq.id_alumne) INNER JOIN quest q ON aq.id_quest=q.id_quest) INNER JOIN quest_detall qd ON q.id_quest=qd.id_quest) INNER JOIN bd_questio bdq ON bdq.id_bd_questio=qd.id_bd_questio) INNER JOIN alumne_quest_detall aqd ON aqd.id_quest_detall=qd.id_quest_detall and aq.id_alumne_quest=aqd.id_alumne_quest) WHERE aq.id_alumne_quest=$id_quest_detall and a.actiu=1";

$resultset = mysqli_query($conn_bdquest,$sql);

$data = array();

while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
    $data[] = $row;
}

echo json_encode($data);
mysqli_free_result($resultset);

include("close_db_bdquest.php");
?>
