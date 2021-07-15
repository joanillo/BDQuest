<?php

$id_quest = $_GET['id_quest'];
$id_usuari = $_GET['id_usuari'];
//$id_quest = 1;
//$id_usuari = 3;

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

$conn = mysqli_connect("localhost", "bdquest", "keiL2lai");
if (!$conn) {
    $log->error('Could not connect: ' . mysql_error());
    die('Could not connect: ' . mysql_error());
}
mysqli_select_db($conn,"bdquest") or die('Could not select bdquest database.');
mysqli_set_charset($conn, 'utf8');

$sql = "select * from informe_quest where id_quest=$id_quest and  id_usuari=$id_usuari and id_usuari_quest=(select max(id_usuari_quest) from informe_quest where id_quest=$id_quest and  id_usuari=$id_usuari)";

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
	    	$trossos = explode("-", $row['dia']);
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
		
		if ($row['valor']=='0') {
			$pdf->SetFont('Arial','I',10);
			$pdf->Write(5,"La teva resposta:"."\n");
			$pdf->SetFont('Arial','',12);
			$pdf->Write(5,$row['resposta']."\n\n");
			$pdf->SetFont('Arial','I',10);
			$pdf->Write(5,"Solució:"."\n");
		}

		$pdf->SetFont('Arial','',12);
		$pdf->Write(5,$row['solucio']."\n\n");
		
		$num++;
	}
	mysqli_free_result($resultset);
}


mysqli_close($conn);

//$pdf->Output();
$pdf->Output('I','informe-'.$id_quest.'-'.str_replace(' ','_',$nom).'-'.$dia_cat.'.pdf');
echo "hola";
?>