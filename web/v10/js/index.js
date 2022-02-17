var mode_developer = 1; //developer=1 (es proporciona la solució, que apareix en el textarea); developer=0 (és el mode normal per als alumnes)
var mode_examen = 0; // s'ha de confirmar la pregunta abans d'enviar

var googleUser; // The current user.
var email;
var id_alumne;
var nom;
var cognoms;
var curs;

var id_quest;
var num_preguntes;
var arr_preguntes;
var num_pregunta;
var current_id_alumne_quest;

window.addEventListener('load', (event) => {
    init();
});

function init() {

    document.getElementById("pregunta_seguent").addEventListener("click", function(){pregunta_seguent()});
    document.getElementById("envia").addEventListener("click", function(){processar()});
    document.getElementById("test").addEventListener("click", function(){processar_test()});
    //document.getElementById("solucio").style.display = (mode_developer==0) ? "none" : "block";
    document.getElementById("solucio").style.display = "none";
    document.getElementById("informe").addEventListener("click", function(){informe_quest()});
    document.getElementById("dinforme").addEventListener("click", function(){descarregar_informe()});
}

function processar() {
    if (mode_examen && !window.confirm("Enviar?")) {
        return;
    }
    //cas general
    arr_sql_alumne = document.forms[0].sql_alumne.value;
    arr_solucio = document.forms[0].solucio.value;
    //la primera vegada que ens trobem un '(' afegim un espai abans. Serveix per als casos create table xxx( -> create table xxx (, doncs necessitaré trobar xxx
    if (arr_sql_alumne.indexOf("(")>=0)
        arr_sql_alumne = arr_sql_alumne.slice(0,arr_sql_alumne.indexOf("(")) + " " + arr_sql_alumne.slice(arr_sql_alumne.indexOf("("), arr_sql_alumne.length);
    if (arr_solucio.indexOf("(")>=0)
        arr_solucio = arr_solucio.slice(0,arr_solucio.indexOf("(")) + " " + arr_solucio.slice(arr_solucio.indexOf("("), arr_solucio.length);

    arr_sql_alumne = arr_sql_alumne.split(' ');
    arr_solucio = arr_solucio.split(' ');

    if (arr_sql_alumne[0].toLowerCase() != arr_solucio[0].toLowerCase()) {
        alert('La solució ha de ser un ' + arr_solucio[0].toUpperCase());
        return;
    } else if (arr_solucio[0].toLowerCase()=="create" && arr_solucio[1].toLowerCase()=="table" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
    //cas específic CREATE TABLE xxx, ALTER
        alert('PISTA: CREATE TABLE ' + arr_solucio[2]);
        return;
    }  else if (arr_solucio[0].toLowerCase()=="alter" && arr_solucio[1].toLowerCase()=="table" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: ALTER TABLE ' + arr_solucio[2]);
        return;
    }  else if (arr_solucio[0].toLowerCase()=="drop" && arr_solucio[1].toLowerCase()=="drop" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: DROP TABLE ' + arr_solucio[2]);
        return;
    }  else if (arr_solucio[0].toLowerCase()=="create" && arr_solucio[1].toLowerCase()=="user" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: CREATE USER ' + arr_solucio[2]);
        return;
    }  else if (arr_solucio[0].toLowerCase()=="drop" && arr_solucio[1].toLowerCase()=="user" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: DROP USER ' + arr_solucio[2]);
        return;
    }      

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //alert(json_obj)
            //console.log(json_obj);
            
            var obj = JSON.parse(json_obj);
            //console.log(obj)
            var nota = obj.nota;
            var resultat = obj.resultat;
            document.getElementById('rubrica').innerHTML = (resultat==1)?"Correcte":"Incorrecte";
            document.getElementById('rubrica').style.color = (resultat==1)?"blue":"red";
            current_id_alumne_quest = obj.last_id;

            if (obj.data.indexOf("Error")==0 || obj.data.indexOf("Warning")==0 || obj.data.indexOf("Notice")==0 || obj.data.indexOf("Affected")==0 || obj.data.indexOf("OK")==0 || obj.data.indexOf("INCORRECTE")==0) {
                document.getElementById('sqloutput').innerHTML = obj.data;
            } else {
                var arr_head = obj.head;
                var arr = obj.data;
                //alert(arr)
                if (arr.length == 0) {
                    var cad = "No s'han retornat dades";
                    document.getElementById('sqloutput').innerHTML = cad;
                } else {
                    var taula   = document.createElement("table");

                    var tblHead = document.createElement("thead");
                    for (let x in arr_head) {
                        var cella = document.createElement("th");
                        var textCella = document.createTextNode(arr_head[x]);
                        cella.appendChild(textCella);
                        tblHead.appendChild(cella);
                    }
                    taula.appendChild(tblHead);

                    var tblBody = document.createElement("tbody");

                    for (var i = 0; i < arr.length; i++) {
                        var filera = document.createElement("tr");
                        for (let x in arr[0]) {
                            var cella = document.createElement("td");
                            var textCella = document.createTextNode(arr[i][x]);
                            cella.appendChild(textCella);
                            filera.appendChild(cella);
                        }

                        tblBody.appendChild(filera);
                    }

                    taula.appendChild(tblBody);
                    taula.setAttribute("border", "1");

                    document.getElementById('sqloutput').innerHTML = "";
                    document.getElementById('sqloutput').appendChild(taula);
                }
            }
            if (num_pregunta<num_preguntes) {
                document.getElementById('pregunta_seguent').disabled = false;
                document.getElementById('envia').disabled = true;
                //document.getElementById('test').disabled = false;
                if (arr){ //quan fem inserts (affected rows), no tenim l'objecte arr que representa la taula de dades
                (arr[0].rollback == 2) ? document.getElementById('test').disabled = true: document.getElementById('test').disabled = false; 
                }
            } else {
                document.getElementById('envia').disabled = true;
                document.getElementById('nota').innerHTML = "Nota: " + nota;
                document.getElementById('informe').disabled = false;
                document.getElementById('dinforme').disabled = false;  
            }
        
        } else {
            document.getElementById('sqloutput').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }

    //let script = (document.forms[0].rollback.value==0) ? "processar.php" : "processar_rollback.php";
    let script = "";
    switch (document.forms[0].rollback.value) {
        case "0":
            script = "processar.php";
            break;
        case "1":
            script = "processar_rollback.php";
            break;
        case "2":
            script = "processar_create.php";
            break;
    }

    xmlhttp.open("POST","./php/" + script, true)
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    var estat_quest = "";

    if (num_pregunta==1) {
        estat_quest = "inici";
        if (num_pregunta==num_preguntes) estat_quest = "finici"; //el test només té una sola pregunta
        //current_id_alumne_quest = 0;
    } else if (num_pregunta==num_preguntes) {
        estat_quest = "fi";
    }

    //alert(id_quest)
    //alert(arr_preguntes[num_pregunta-1])
    //necessari posar encodeURIComponent() degut al caràcter especial quan tinc sentències SQL com ara like '%ca%'
    xmlhttp.send("bd=" + document.forms[0].bd.value + "&solucio=" + encodeURIComponent(document.forms[0].solucio.value) + "&sql_alumne=" + encodeURIComponent(document.forms[0].sql_alumne.value) + "&id_quest=" + id_quest + "&num_pregunta=" + arr_preguntes[num_pregunta-1] + "&estat_quest=" + estat_quest + "&current_id_alumne_quest=" + current_id_alumne_quest + "&id_alumne=" + id_alumne);
}


function processar_test() {

    arr_sql_alumne = document.forms[0].sql_alumne.value;
    arr_solucio = document.forms[0].solucio.value;
    //la primera vegada que ens trobem un '(' afegim un espai abans. Serveix per als casos create table xxx( -> create table xxx (, doncs necessitaré trobar xxx
    if (arr_sql_alumne.indexOf("(")>=0)
        arr_sql_alumne = arr_sql_alumne.slice(0,arr_sql_alumne.indexOf("(")) + " " + arr_sql_alumne.slice(arr_sql_alumne.indexOf("("), arr_sql_alumne.length);
    if (arr_solucio.indexOf("(")>=0)
        arr_solucio = arr_solucio.slice(0,arr_solucio.indexOf("(")) + " " + arr_solucio.slice(arr_solucio.indexOf("("), arr_solucio.length);

    arr_sql_alumne = arr_sql_alumne.split(' ');
    arr_solucio = arr_solucio.split(' ');
    //console.log(arr_sql_alumne[0].toLowerCase());
    //console.log(arr_solucio[0].toLowerCase());
    if (arr_sql_alumne[0].toLowerCase() != arr_solucio[0].toLowerCase()) {
        alert('La solució ha de ser un ' + arr_solucio[0].toUpperCase());
        return;
    } else if (arr_solucio[0].toLowerCase()=="create" && arr_solucio[1].toLowerCase()=="table" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
    //cas específic CREATE TABLE xxx, ALTER
        alert('PISTA: CREATE TABLE ' + arr_solucio[2]);
        return;
    } else if (arr_solucio[0].toLowerCase()=="alter" && arr_solucio[1].toLowerCase()=="table" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: ALTER TABLE ' + arr_solucio[2]);
        return;
    } else if (arr_solucio[0].toLowerCase()=="drop" && arr_solucio[1].toLowerCase()=="table" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: DROP TABLE ' + arr_solucio[2]);
        return;
    }  else if (arr_solucio[0].toLowerCase()=="create" && arr_solucio[1].toLowerCase()=="user" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: CREATE USER ' + arr_solucio[2]);
        return;
    }  else if (arr_solucio[0].toLowerCase()=="drop" && arr_solucio[1].toLowerCase()=="user" && ((arr_sql_alumne[0]+arr_sql_alumne[1]+arr_sql_alumne[2]).toLowerCase() != (arr_solucio[0]+arr_solucio[1]+arr_solucio[2]).toLowerCase())) {
        alert('PISTA: DROP USER ' + arr_solucio[2]);
        return;
    }

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //alert(json_obj)
            //console.log(json_obj)
            var obj = JSON.parse(json_obj);
            var resultat = obj.resultat;
            document.getElementById('rubrica').innerHTML = "";
            if (obj.data.indexOf("Error")==0 || obj.data.indexOf("Warning")==0 || obj.data.indexOf("Notice")==0 || obj.data.indexOf("Affected")==0 || obj.data.indexOf("OK")==0 || obj.data.indexOf("INCORRECTE")==0) {
                document.getElementById('sqloutput').innerHTML = obj.data;
            } else {
                var arr_head = obj.head;
                var arr = obj.data;
                if (arr.length == 0) {
                    var cad = "No s'han retornat dades";
                    document.getElementById('sqloutput').innerHTML = cad;
                } else {
                    var taula   = document.createElement("table");

                    var tblHead = document.createElement("thead");
                    for (let x in arr_head) {
                        var cella = document.createElement("th");
                        var textCella = document.createTextNode(arr_head[x]);
                        cella.appendChild(textCella);
                        tblHead.appendChild(cella);
                    }
                    taula.appendChild(tblHead);

                    var tblBody = document.createElement("tbody");

                    for (var i = 0; i < arr.length; i++) {
                        var filera = document.createElement("tr");
                        for (let x in arr[0]) {
                            var cella = document.createElement("td");
                            var textCella = document.createTextNode(arr[i][x]);
                            cella.appendChild(textCella);
                            filera.appendChild(cella);
                        }

                        tblBody.appendChild(filera);
                    }

                    taula.appendChild(tblBody);
                    taula.setAttribute("border", "1");

                    document.getElementById('sqloutput').innerHTML = "";
                    document.getElementById('sqloutput').appendChild(taula);
                }
            }
        } else {
            document.getElementById('sqloutput').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }

    let script = "";
    switch (document.forms[0].rollback.value) {
        case "0":
            script = "processar_test.php";
            break;
        case "1": //el cas "2" no existeix perquè el test està deshabilitat
            script = "processar_test_rollback.php";
            break;
    }

    xmlhttp.open("POST","./php/" + script,true)
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xmlhttp.send("bd=" + document.forms[0].bd.value + "&sql_alumne=" + encodeURIComponent(document.forms[0].sql_alumne.value));
}

function load_quests() {
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            var arr = JSON.parse(json_obj);
            var selectList = document.createElement("select");
            selectList.id = "sel_questionaris2";
            myParent = document.getElementById('sel_questionaris');
            myParent.appendChild(selectList);

            var option = document.createElement("option");
            option.value = 0;
            option.text = "";
            selectList.appendChild(option);

            for (var i = 0; i < arr.length; i++) {
                var option = document.createElement("option");
                option.value = arr[i].id_quest;
                option.text = arr[i].quest;
                selectList.appendChild(option);
            }
            selectList.addEventListener("change", function(){canviar_questionari(this.value)});

        }
    }
    xmlhttp.open("POST","./php/load_quests.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("email=" + email);
}

function canviar_questionari(vid_quest) {
    id_quest = vid_quest;
    var e = document.getElementById("sel_questionaris2")
    document.getElementById("questionari").innerHTML = "Qüestionari: " + e.options[e.selectedIndex].text;
    //document.getElementById("questionari").innerHTML = e.options[id_quest].text;
    document.getElementById("rubrica").innerHTML = "";
    document.getElementById("sqloutput").innerHTML = "";
    document.getElementById("nota").innerHTML = "Nota: ";

    if (id_quest==0) { //he seleccionat l'element buit de la casella desplegable
        document.forms[0].num_preguntes.value = num_preguntes;
        document.getElementById('pregunta_seguent').disabled = true;
        document.getElementById('envia').disabled = true;
        document.getElementById('test').disabled = true;
        document.getElementById('informe').disabled = true;
        document.getElementById('dinforme').disabled = true;
        document.forms[0].num_pregunta.value = "";
        document.getElementById("rubrica").innerHTML = "";
        document.getElementById("sqloutput").innerHTML = "";
        document.getElementById("questio").innerHTML = "";
        document.getElementById("solucio").innerHTML = "";
        document.forms[0].bd.value = "";
        document.getElementById("diagrama").innerHTML = "";
        document.forms[0].rollback.value = "";
        document.forms[0].solucio.value = "";
        document.forms[0].sql_alumne.value = "";
        return;
    }
    
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            var obj = JSON.parse(json_obj);
            num_preguntes = obj.num_preguntes;
            arr_preguntes = obj.arr_preguntes;
            num_pregunta = 1;
            document.forms[0].num_preguntes.value = num_preguntes;
            document.getElementById('pregunta_seguent').disabled = false;
            document.getElementById('envia').disabled = true;
            document.getElementById('test').disabled = true;
            document.getElementById('informe').disabled = true;
            document.getElementById('dinforme').disabled = true;
            carrega_pregunta();
        }
    }
    xmlhttp.open("POST","./php/load_questionari.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest=" + id_quest);

}

function carrega_pregunta() {
    document.getElementById('pregunta_seguent').disabled = true;
    document.getElementById('envia').disabled = false;
    document.getElementById('test').disabled = false;
    document.forms[0].num_pregunta.value = arr_preguntes[num_pregunta-1];
    document.getElementById("rubrica").innerHTML = "";
    document.getElementById("sqloutput").innerHTML = "";

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            //alert(json_obj)
            var arr = JSON.parse(json_obj);
            //var arr = obj.data;
            document.getElementById("questio").innerHTML = "#" + num_pregunta + "/" + num_preguntes + ". (" + arr[0].bd + ") " + arr[0].questio.replaceAll('\n', '<br />');
            document.getElementById("solucio").innerHTML = arr[0].solucio.replaceAll('\n','<br />').replaceAll('\t','&nbsp;&nbsp;&nbsp;');
            document.forms[0].bd.value = arr[0].bd;
            document.getElementById("diagrama").innerHTML = "<img src='./img/diagrama_" + arr[0].bd  + "'>";
            document.forms[0].rollback.value = arr[0].rollback;
            document.forms[0].solucio.value = arr[0].solucio;
            document.forms[0].sql_alumne.value = (mode_developer==0) ? "" : arr[0].solucio; //mostrem la solució si estem en mode desenvolupament 
            (arr[0].rollback == 2) ? document.getElementById('test').disabled = true: document.getElementById('test').disabled = false; 
        }
    }
    xmlhttp.open("POST","./php/load_questio.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest=" + id_quest + "&num_pregunta=" + arr_preguntes[num_pregunta-1]);
}

function pregunta_seguent() {
    num_pregunta = num_pregunta + 1;
    carrega_pregunta();
}

function informe_quest() {

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            if (json_obj.indexOf("Error")==0) {
                document.getElementById("sqloutput").innerHTML = json_obj;
            } else {
                var arr = JSON.parse(json_obj);
                //console.log(arr);
                //alert(arr[0]);
                //ara hem de construir la taula
                var nom = arr[0].nom + ' ' + arr[0].cognoms;
                var nota = arr[0].nota;
                var dia_arr = arr[0].dia.split('-');
                var dia_cat = dia_arr[2]+'-'+dia_arr[1]+'-'+dia_arr[0];
                var quest = arr[0].quest + ' (' + dia_cat + ')';
                var informe = '<h1>' + nom + '</h1>';
                informe = informe + '<h2>' + quest + '</h2>';
                informe = informe + '<h2>Nota: ' + nota + '</h2>';
                for (var i=0; i<arr.length; i++) {
                    informe = informe + '<h3>' + (i+1) + '. ' + arr[i].questio.replaceAll('\n','<br />').replaceAll('\t','&nbsp;&nbsp;&nbsp;') + '</h3>';
                    //comparem sempre la solució de l'alumne amb la solució proposada, encara que estigui bé
                    //if (arr[i].valor==0) {
                        informe = informe + 'La teva resposta ' + ((arr[i].valor==0)?' (incorrecta)':' (correcta)') + ':';
                        informe = informe + '<pre>' + arr[i].resposta + '</pre>';
                        informe = informe + 'Solució proposada:';
                        informe = informe + '<pre>' + arr[i].solucio + '</pre>';
                    //} else {
                    //    informe = informe + '<pre>' + arr[i].solucio + '</pre>';
                    //}
                }
                document.getElementById("sqloutput").innerHTML = informe;
            }
        }
    }
    xmlhttp.open("POST","./php/informe_quest.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest=" + id_quest + "&id_alumne=" + id_alumne);
}

function descarregar_informe() {
    window.open("./php/informe_quest_fpdf.php?id_quest="+id_quest+"&id_alumne="+id_alumne);
}

// ===============================

function onSignIn(googleUser) {
    var profile = googleUser.getBasicProfile();
    console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    console.log('Name: ' + profile.getName());
    console.log('Image URL: ' + profile.getImageUrl());
    console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
    email = profile.getEmail();

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_arr=xmlhttp.responseText;
            var arr = JSON.parse(json_arr)
            console.log(arr);
            if (arr!="") {
                //console.log(arr[0])
                email = arr[0].email;
                id_alumne = arr[0].id_alumne;
                nom = arr[0].nom;
                cognoms = arr[0].cognoms;
                curs = arr[0].curs;
                document.forms[0].id_alumne.value = id_alumne;
                document.getElementById("email").innerHTML = email;
                load_quests(); //només es carreguen els qüestionaris si ens hem logat correctament com a alumne.
            } else {
                document.getElementById("email").innerHTML = "No existeix " + email + " a la bd i amb rol d'alumne";
                xmlhttp.onreadystatechange=function()
                {
                    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
                        json_arr=xmlhttp.responseText;
                        var arr = JSON.parse(json_arr)
                        if (arr!="") {
                            //console.log(arr[0])
                            email = arr[0].email;
                            id_alumne = arr[0].id_alumne;
                            nom = arr[0].nom;
                            cognoms = arr[0].cognoms;
                            curs = arr[0].curs;
                            document.forms[0].id_alumne.value = id_alumne;
                            document.getElementById("email").innerHTML = email + " (professor)";
                            window.open("professor.html","_self");
                        } else {
                            document.getElementById("email").innerHTML = "No existeix " + email + " a la bd ni com alumne ni com a professor";
                        }
                    }
                }
                xmlhttp.open("POST","./php/cerca_professor.php",true);
                xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xmlhttp.send("email=" + email);

            }
        }
    }
    xmlhttp.open("POST","./php/cerca_alumne.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("email=" + email);

}
