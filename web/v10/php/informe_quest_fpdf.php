<?php
/*
BDQuest v10 (GPLv3)
@ Joan Quintana - 2021-2022
https://wiki.joanillo.org/index.php/BDQuest
*/

$id_quest = $_GET['id_quest'];
$id_alumne = $_GET['id_alumne'];
//$id_quest = 1;
//$id_alumne = 3;

//la llibreria TCPDF és millor que FPDF
require('./fpdf183/fpdf.php');

class PDF extends FPDF
{
	function Header()
	{

	}

	function Footer()
	{
		// Position at 1.5 cm from bottom
		$this->SetY(-15);
		// Arial italic 8
		$this->SetFont('Arial','I',8);
		// Text color in gray
		$this->SetTextColor(128);
		// Page number
		$this->Cell(0,10,'Page '.$this->PageNo(),0,0,'C');
	}


}

$pwd = file_get_contents('./.pwd');
$conn = mysqli_connect("localhost", "bdquest", $pwd);
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');
mysqli_set_charset($conn, 'utf8');

$sql = "select * from informe_quest where id_quest=$id_quest and id_alumne=$id_alumne and id_alumne_quest=(select max(id_alumne_quest) from informe_quest where id_quest=$id_quest and  id_alumne=$id_alumne)";

$pdf = new PDF();

$resultset = mysqli_query($conn,$sql);

if (!$resultset) {
	$data = "Error: ".mysqli_error($conn);
} else {

	$num = 1;
	while($row = mysqli_fetch_array($resultset, MYSQLI_ASSOC)) {

	    //$data[] = $row;
	    if (!isset($nom)) {
	    	$nom = $row['nom'].' '.$row['cognoms'];
	    	//$trossos = explode(" ", $row['dia'])[0];
	    	$trossos = explode("-", explode(" ", $row['dia'])[0]);
	    	$dia_cat = $trossos[2].'-'.$trossos[1].'-'.$trossos[0];
	    	$quest = $row['quest'].' ('.$dia_cat.')';
	    	$nota = "Nota: ".$row['nota'];
	    	$pdf->AddPage();
	    	$pdf->Image('./fpdf183/tutorial/logo.png',160,6,30);
			$pdf->SetFont('Arial','B',16);
			$pdf->Write(8,$nom."\n");
			$pdf->Write(8,$quest."\n");
			$pdf->Write(8,$nota."\n\n");
	    	$pdf->Line(0,35,220,35);
		}

		$pdf->SetFont('Arial','B',12);
		$pdf->Write(5,$num.'. '.$row['questio']."\n\n");

		$pdf->SetFont('Arial','',12);
		
		//if ($row['valor']=='0') {
		$resultat = ($row['valor']=='0') ? ' (incorrecta)' : ' (correcta)';
			$pdf->SetFont('Arial','I',10);
			$pdf->Write(5,"La teva resposta:".$resultat."\n");
			$pdf->SetFont('Arial','',12);
			$pdf->Write(5,$row['resposta']."\n\n");
			$pdf->SetFont('Arial','I',10);
			$pdf->Write(5,"Solució:"."\n");
		//}

		$pdf->SetFont('Arial','',12);
		$pdf->Write(5,$row['solucio']."\n\n");
		
		$num++;
	}
	mysqli_free_result($resultset);
}


mysqli_close($conn);

//$pdf->Output();
$pdf->Output('I','informe-'.$id_quest.'-'.str_replace(' ','_',iconv('utf-8', 'windows-1252', $nom)).'-'.$dia_cat.'.pdf');

?>
