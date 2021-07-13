<?php

$data_alumne = array();
$data_alumne[] = "un";
$data_alumne[] = "dos";
$data_alumne[] = "tres";
	foreach ($data_alumne as &$valor) {
		echo $valor." ";
	}

?>