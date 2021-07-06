function init() {
    //document.getElementById('sqloutput').innerHTML = "222";
}

function processar(sql_alumne) {
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
    xmlhttp.send("sql_alumne=" + sql_alumne);
}
