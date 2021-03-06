<?php
/*
BDQuest v10 (GPLv3)
@ Joan Quintana - 2021-2022
https://wiki.joanillo.org/index.php/BDQuest
*/

$email = $_POST['email'];

include("open_db_bdquest.php");

//per al professor, es carreguen els quests de l'assignatura, i el número d'alumnes que els han contestat (amb outer join, de manera que també surten els quests que no ha contestat cap alumne)
//$sql = "select q.id_quest, quest, count(id_alumne) as num from (alumne_quest aq right outer join quest q on q.id_quest=aq.id_quest), professor p where q.id_professor=p.id_professor and email='$email' group by q.id_quest";

//tenint en compte només els alumnes actius:
$sql = "select q.id_quest, quest, count(aq.id_alumne) as num from ((alumne_quest aq right outer join quest q on q.id_quest=aq.id_quest) right outer join alumne a ON aq.id_alumne=a.id_alumne and a.actiu=1) , professor p where q.id_professor=p.id_professor and p.email='$email' group by q.id_quest order by q.id_quest";

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

