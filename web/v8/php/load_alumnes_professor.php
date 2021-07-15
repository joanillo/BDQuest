<?php
$email = $_POST['email'];

include("open_db_bdquest.php");

//per al professor, es carreguen els alumnes de l'assignatura, i el número de quests que han contestat (amb outer join, de manera que també surten els alumnes que no n'han contestat cap)
$sql = "select a.id_alumne, a.nom, a.cognoms, count(q.id_quest) as num from ((((alumne a inner join professor p1 ON a.curs=p1.curs) left outer join alumne_quest aq ON a.id_alumne=aq.id_alumne) left outer join quest q ON aq.id_quest=q.id_quest) left outer join professor p ON q.id_professor=p.id_professor) where p1.email='$email' group by a.id_alumne, a.nom, a.cognoms;
";
$resultset = mysqli_query($conn_bdquest,$sql);

if (!$resultset) {
	//printf("Error: %s\n", mysqli_error($conn));
	$res = "{\"resultat\":\"ERROR\",\"data\": \"Error: ".mysqli_error($conn_bdquest)."\"}";
	echo $res;
} else {

	$data = array();

	while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
	    $data[] = $row;
	}

	echo json_encode($data);
	mysqli_free_result($resultset);
}

include("close_db_bdquest.php");
?>

