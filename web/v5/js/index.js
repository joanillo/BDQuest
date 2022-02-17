var googleUser; // The current user.
var email;
var id_usuari;
var nom;
var cognoms;
var curs;

var id_quest;
var num_preguntes;
var arr_preguntes;
var num_pregunta;
var current_id_usuari_quest;


function init() {
    load_quests();
    document.getElementById("pregunta_seguent").addEventListener("click", function(){pregunta_seguent()});
}

function processar(bd, solucio, sql_alumne) {
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //alert(json_obj)
            console.log(json_obj);
            var obj = JSON.parse(json_obj);
            var nota = obj.nota;
            var resultat = obj.resultat;
            document.getElementById('rubrica').innerHTML = resultat;
            current_id_usuari_quest = obj.last_id;

            if (obj.data.indexOf("Error")==0) {
                document.getElementById('sqloutput').innerHTML = obj.data;
            } else {
                var arr = obj.data;
                if (arr.length == 0) {
                    var cad = "No s'han retornat dades";
                    document.getElementById('sqloutput').innerHTML = cad;
                } else {
                    var tabla   = document.createElement("table");

                    var tblHead = document.createElement("thead");
                    for (let x in arr[0]) {
                        var celda = document.createElement("td");
                        var textoCelda = document.createTextNode(x);
                        celda.appendChild(textoCelda);
                        tblHead.appendChild(celda);
                    }
                    tabla.appendChild(tblHead);

                    var tblBody = document.createElement("tbody");

                    for (var i = 0; i < arr.length; i++) {
                        var hilera = document.createElement("tr");
                        for (let x in arr[0]) {
                            var celda = document.createElement("td");
                            var textoCelda = document.createTextNode(arr[i][x]);
                            celda.appendChild(textoCelda);
                            hilera.appendChild(celda);
                        }

                        tblBody.appendChild(hilera);
                    }

                    tabla.appendChild(tblBody);
                    tabla.setAttribute("border", "1");

                    document.getElementById('sqloutput').innerHTML = "";
                    document.getElementById('sqloutput').appendChild(tabla);
                }
            }
            if (num_pregunta<num_preguntes) {
                document.getElementById('pregunta_seguent').disabled = false;
                document.getElementById('envia').disabled = true;
                document.getElementById('test').disabled = false;
            } else {
                document.getElementById('envia').disabled = true;
                document.getElementById('nota').innerHTML = "Nota: " + nota;    
            }

        } else {
            document.getElementById('sqloutput').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }
    xmlhttp.open("POST","./php/processar.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    var estat_quest = "";
    if (num_pregunta==1) {
        estat_quest = "inici";
        //current_id_usuari_quest = 0;
    } else if (num_pregunta==num_preguntes) {
        estat_quest = "fi";
    }
    xmlhttp.send("bd=" + bd + "&solucio=" + solucio + "&sql_alumne=" + sql_alumne + "&id_quest=" + id_quest + "&num_pregunta=" + arr_preguntes[num_pregunta-1] + "&estat_quest=" + estat_quest + "&current_id_usuari_quest=" + current_id_usuari_quest + "&id_usuari=" + id_usuari);
}

function processar_test(bd, sql_alumne) {
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            var obj = JSON.parse(json_obj);
            var resultat = obj.resultat;
            if (resultat=="ERROR") {
                document.getElementById('sqloutput').innerHTML = obj.data;
            } else {
                var arr = obj.data;
                if (arr.length == 0) {
                    var cad = "No s'han retornat dades";
                    document.getElementById('sqloutput').innerHTML = cad;
                } else {
                    var tabla   = document.createElement("table");

                    var tblHead = document.createElement("thead");
                    for (let x in arr[0]) {
                        var celda = document.createElement("td");
                        var textoCelda = document.createTextNode(x);
                        celda.appendChild(textoCelda);
                        tblHead.appendChild(celda);
                    }
                    tabla.appendChild(tblHead);

                    var tblBody = document.createElement("tbody");

                    for (var i = 0; i < arr.length; i++) {
                        var hilera = document.createElement("tr");
                        for (let x in arr[0]) {
                            var celda = document.createElement("td");
                            var textoCelda = document.createTextNode(arr[i][x]);
                            celda.appendChild(textoCelda);
                            hilera.appendChild(celda);
                        }

                        tblBody.appendChild(hilera);
                    }

                    tabla.appendChild(tblBody);
                    tabla.setAttribute("border", "1");

                    document.getElementById('sqloutput').innerHTML = "";
                    document.getElementById('sqloutput').appendChild(tabla);
                }
            }

        } else {
            document.getElementById('sqloutput').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }
    xmlhttp.open("POST","./php/processar_test.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xmlhttp.send("bd=" + bd + "&sql_alumne=" + sql_alumne);
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
    xmlhttp.send();

}

function canviar_questionari(vid_quest) {
    id_quest = vid_quest;
    var e = document.getElementById("sel_questionaris2")
    document.getElementById("questionari").innerHTML = "Qüestionari: " + e.options[e.selectedIndex].text;
    //document.getElementById("questionari").innerHTML = e.options[id_quest].text;
    document.getElementById("rubrica").innerHTML = "";
    document.getElementById("sqloutput").innerHTML = "";
    document.getElementById("nota").innerHTML = "Nota: ";

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
            var arr = JSON.parse(json_obj);
            //var arr = obj.data;
            document.getElementById("questio").innerHTML = "#" + num_pregunta + "/" + num_preguntes + ". (" + arr[0].bd + ") " + arr[0].questio;
            document.getElementById("solucio").innerHTML = arr[0].solucio;
            document.forms[0].bd.value = arr[0].bd;
            document.forms[0].solucio.value = arr[0].solucio;
            document.forms[0].sql_alumne.value = arr[0].solucio; //comentar
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
            //console.log(arr[0])
            email = arr[0].email;
            id_usuari = arr[0].id_usuari;
            nom = arr[0].nom;
            cognoms = arr[0].cognoms;
            curs = arr[0].curs;
            document.forms[0].id_usuari.value = id_usuari;
            document.getElementById("email").innerHTML = email;
        }
    }
    xmlhttp.open("POST","./php/cerca_alumne.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("email=" + email);

}
