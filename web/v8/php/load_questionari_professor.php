<?php
include("open_db_bdquest.php");

$id_quest = $_POST['id_quest'];

$sql = "select id_alumne_quest, quest, nota, q.dia, nom, cognoms from alumne a, alumne_quest aq, quest q where a.id_alumne=aq.id_alumne and aq.id_quest=q.id_quest and q.id_quest=$id_quest order by id_alumne_quest";
$resultset = mysqli_query($conn_bdquest,$sql);

$data = array();

while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
    $data[] = $row;
}

echo json_encode($data);
mysqli_free_result($resultset);

include("close_db_bdquest.php");
?>
