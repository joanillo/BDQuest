<?php
$array1 = array(0, 1, 2, 3);
$array2 = $array1;
var_dump($array1);
echo "<br />";
unset($array1[0]);
var_dump($array1);
echo "<br />";
var_dump($array2);
echo "<br />";
?>