function init() {
    load_quests();
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
            //alert(json_obj)
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

function canviar_questionari(id_quest) {
    var e = document.getElementById("sel_questionaris2")
    document.getElementById("questionari").innerHTML = "Qüestionari: " + e.options[e.selectedIndex].text;
    //document.getElementById("questionari").innerHTML = e.options[id_quest].text;

    //i ara ja puc mostrar la primera pregunta del qüestionari
    var num = 1;

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //alert(json_obj)
            var arr = JSON.parse(json_obj);
            document.getElementById("questio").innerHTML = "#" + num + ". (" + arr[0].bd + ") " + arr[0].questio;
            document.getElementById("solucio").innerHTML = arr[0].solucio;
            document.forms[0].bd.value = arr[0].bd;
            document.forms[0].solucio.value = arr[0].solucio;
        }
    }
    xmlhttp.open("POST","./php/load_questio.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest=" + id_quest + "&num=" + num);
}
