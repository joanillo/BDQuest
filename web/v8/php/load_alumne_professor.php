<?php
include("open_db_bdquest.php");

$id_alumne = $_POST['id_alumne'];

$sql = "select id_alumne_quest, nom, cognoms, curs, quest, nota, q.dia from alumne a, alumne_quest aq, quest q where a.id_alumne=aq.id_alumne and aq.id_quest=q.id_quest and a.id_alumne=$id_alumne order by id_alumne_quest";
$resultset = mysqli_query($conn_bdquest,$sql);

$data = array();

while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
    $data[] = $row;
}

echo json_encode($data);
mysqli_free_result($resultset);

include("close_db_bdquest.php");
?>
