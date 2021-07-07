var id_quest;
var num_preguntes;
var arr_preguntes;
var num_pregunta;

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
            var obj = JSON.parse(json_obj);
            var resultat = obj.resultat;
            document.getElementById('rubrica').innerHTML = resultat;
            //TODO: ja podem puntuar la pregunta

            if (resultat=="ERROR") {
                document.getElementById('sqloutput').innerHTML = obj.data;
            } else {
                var arr = obj.data;

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
                if (num_pregunta<num_preguntes) document.getElementById('pregunta_seguent').disabled = false;
            }

        } else {
            document.getElementById('sqloutput').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }
    xmlhttp.open("POST","./php/processar.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("bd=" + bd + "&solucio=" + solucio + "&sql_alumne=" + sql_alumne);
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

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            alert(json_obj)
            var obj = JSON.parse(json_obj);
            num_preguntes = obj.num_preguntes;
            arr_preguntes = obj.arr_preguntes;
            num_pregunta = 1;
            document.forms[0].num_preguntes.value = num_preguntes;
            document.getElementById('pregunta_seguent').disabled = false;
            carrega_pregunta();
        }
    }
    xmlhttp.open("POST","./php/load_questionari.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest=" + id_quest);

}

function carrega_pregunta() {
    document.getElementById('pregunta_seguent').disabled = true;
    document.forms[0].num_pregunta.value = arr_preguntes[num_pregunta-1];

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //alert(json_obj)
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