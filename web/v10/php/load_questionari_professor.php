<?php
/*
BDQuest v10 (GPLv3)
@ Joan Quintana - 2021-2022
https://wiki.joanillo.org/index.php/BDQuest
*/

include("open_db_bdquest.php");

$id_quest = $_POST['id_quest'];

$sql = "SELECT id_alumne_quest, quest, nota, q.dia, nom, cognoms FROM ((alumne a INNER JOIN alumne_quest aq ON a.id_alumne=aq.id_alumne) INNER JOIN quest q ON aq.id_quest=q.id_quest) WHERE q.id_quest=$id_quest and a.actiu=1 ORDER BY id_alumne_quest";
$resultset = mysqli_query($conn_bdquest,$sql);

$data = array();

while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
    $data[] = $row;
}

echo json_encode($data);
mysqli_free_result($resultset);

include("close_db_bdquest.php");
?>
