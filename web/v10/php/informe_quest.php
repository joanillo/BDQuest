<?php
/*
BDQuest v10 (GPLv3)
@ Joan Quintana - 2021-2022
https://wiki.joanillo.org/index.php/BDQuest
*/

$id_quest = $_POST['id_quest'];
$id_alumne = $_POST['id_alumne'];

$pwd = file_get_contents('./.pwd');
$conn = mysqli_connect("localhost", "bdquest", $pwd);
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');
mysqli_set_charset($conn, 'utf8');

$sql = "select * from informe_quest where id_quest=$id_quest and id_alumne=$id_alumne and id_alumne_quest=(select max(id_alumne_quest) from informe_quest where id_quest=$id_quest and  id_alumne=$id_alumne)";


$resultset = mysqli_query($conn,$sql);

if (!$resultset) {
	$data = "Error: ".mysqli_error($conn);
} else {

	$data = array();

	while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {
	    $data[] = $row;
	}
	mysqli_free_result($resultset);
}

$res = json_encode($data);

echo $res;

mysqli_close($conn);

?>
