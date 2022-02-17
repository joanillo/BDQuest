<?php
	session_start();

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es">
<head>
<meta charset="utf-8"></meta>
<title>BDQuest</title>
<script src="./js/index.js"></script>

</head>
<body onload="init()">
<div>
	<?php
	if(isset($_SESSION["email"])) {
		echo $_SESSION["nom"]." ".$_SESSION["cognoms"]." (".$_SESSION["email"].")&nbsp;";
		echo "<a href=\"./php/logout.php\">Logout</a></div>";
	} else {
		echo "<a href=\"./php/login.php\">Login</a>&nbsp;";
	}
	?>
<h1>Qüestionari BD</h1>

<div id="sel_questionaris" disabled>
	<label>Qüestionaris:</label><br />
</div>
<h2 id="questionari"></h2>
<button id="pregunta_seguent" disabled="">Següent</button>
<h3 id="questio"></h3>
<div id="solucio"></div>

<form method="post">
	<input type="hidden" name="id_usuari" value="<?php echo(isset($_SESSION["id_usuari"])) ? $_SESSION["id_usuari"] : ""; ?>"></input>
	<input type="hidden" name="num_preguntes"></input>
	<input type="hidden" name="num_pregunta"></input>
	<input type="hidden" name="bd"></input>
	<input type="hidden" name="solucio"></input> 
	<textarea id="sql_alumne" name="sql_alumne" rows="6" cols="60"></textarea><br /><br />
</form>
<button id="envia" onclick="processar(document.forms[0].bd.value, document.forms[0].solucio.value, document.getElementById('sql_alumne').value)"  disabled="">Envia</button>
<button id="test" onclick="processar_test(document.forms[0].bd.value, document.getElementById('sql_alumne').value)" disabled="">Test</button>
<div id="rubrica"></div>
<div id="sqloutput"></div>
</body>
</html>
