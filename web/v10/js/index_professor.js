var googleUser; // The current user.
var email;
var id_professor;
var nom;
var cognoms;
var curs;
var quest;

window.addEventListener('load', (event) => {
    init();
});

function init() {
    //console.log('');
}

function load_alumnes_professor() {
    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            var arr = JSON.parse(json_obj);
            var selectList = document.createElement("select");
            selectList.id = "sel_alumnes2";
            myParent = document.getElementById('sel_alumnes');
            myParent.appendChild(selectList);

            var option = document.createElement("option");
            option.value = 0;
            option.text = "";
            selectList.appendChild(option);

            for (var i = 0; i < arr.length; i++) {
                var option = document.createElement("option");
                option.value = arr[i].id_alumne;
                if (arr[i].num=='0') option.disabled=true;
                option.text = arr[i].nom + ' ' + arr[i].cognoms + ' (' + arr[i].num + ')';
                selectList.appendChild(option);
            }
            selectList.addEventListener("click", function(){canviar_alumne_professor(this.value)});
        } else {
        	//document.getElementById('llista').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }
    xmlhttp.open("POST","./php/load_alumnes_professor.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("email=" + email);
}

function load_quests_professor() {
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
                if (arr[i].num=='0') option.disabled=true;
                option.text = arr[i].quest + ' (' + arr[i].num + ')';
                selectList.appendChild(option);
            }
            selectList.addEventListener("click", function(){canviar_questionari_professor(this.value)});
        } else {
        	//document.getElementById('llista').innerHTML = "<img src=\"img/ajax_wait.gif\" />";
        }
    }
    xmlhttp.open("POST","./php/load_quests_professor.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("email=" + email);
}

function canviar_alumne_professor(vid_alumne) {
    id_alumne = vid_alumne;
    var nom = "";
    document.getElementById("sel_questionaris2").selectedIndex = 0;

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            var arr = JSON.parse(json_obj);
            
            var list=document.createElement('ul');
            list.setAttribute("id", "myUL");

			nom = arr[0].nom;
			cognoms = arr[0].cognoms;
			curs = arr[0].curs;

			document.getElementById("titol").innerHTML = "<h1>" + nom + " " + cognoms + " (" + curs + ")</h1>";

            for (var i=0;i<arr.length;i++) {
			
				var dia_arr = arr[i].dia.split('-');
				var dia_cat = dia_arr[2]+'-'+dia_arr[1]+'-'+dia_arr[0];

				var listItem=document.createElement('li');
				if (arr[i].nota===null) {
					listItem.appendChild(document.createTextNode(arr[i].quest + ": " + "- " + " (" + dia_cat + ")"));
				} else {
					var a = document.createElement('a');
					a.href = "#";
					a.title = arr[i].id_alumne_quest;
					a.appendChild(document.createTextNode(arr[i].quest));

					listItem.appendChild(a);
					listItem.innerHTML = listItem.innerHTML + ": " + arr[i].nota + " (" + dia_cat + ")";
				}

				list.appendChild(listItem);

            }
            document.getElementById("llista").innerHTML = "";
            document.getElementById("llista").appendChild(list);

			var anchors = document.getElementsByTagName("a");

			for (var i = 0; i < anchors.length ; i++) {
				anchors[i].addEventListener("click",
					function (event) {
						event.preventDefault();
						 informe_questionari_professor(this.title);
					},
				false);
			}

        }
    }
    xmlhttp.open("POST","./php/load_alumne_professor.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_alumne=" + id_alumne);
}

function canviar_questionari_professor(vid_quest) {
    id_quest = vid_quest;
    var quest = "";
    document.getElementById("sel_alumnes2").selectedIndex = 0;

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //alert(json_obj);
            //console.log(json_obj)
            var arr = JSON.parse(json_obj);
            
            var list=document.createElement('ul');
            list.setAttribute("id", "myUL");

			quest = arr[0].quest;
			document.getElementById("titol").innerHTML = "<h1>" + quest + "</h1>";

            for (var i=0;i<arr.length;i++) {

				var dia_arr = arr[i].dia.split('-');
				var dia_cat = dia_arr[2]+'-'+dia_arr[1]+'-'+dia_arr[0];

				var listItem=document.createElement('li');
				if (arr[i].nota===null) {
					listItem.appendChild(document.createTextNode(arr[i].nom + " " + arr[i].cognoms + ": " + "- " + " (" + dia_cat + ")"));
				} else {
					var a = document.createElement('a');
					a.href = "#";
					a.title = arr[i].id_alumne_quest;
					a.appendChild(document.createTextNode(arr[i].nom + " " + arr[i].cognoms));

					listItem.appendChild(a);
					listItem.innerHTML = listItem.innerHTML + ": " + arr[i].nota + " (" + dia_cat + ")";
				}

				list.appendChild(listItem);

            }

            document.getElementById("llista").innerHTML = "";
            document.getElementById("llista").appendChild(list);

			var anchors = document.getElementsByTagName("a");

			for (var i = 0; i < anchors.length ; i++) {
				anchors[i].addEventListener("click",
					function (event) {
						event.preventDefault();
						 informe_questionari_professor(this.title);
					},
				false);
			}

        }
    }
    xmlhttp.open("POST","./php/load_questionari_professor.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest=" + id_quest);
}

function informe_questionari_professor(vid_quest_detall) {
    id_quest_detall = vid_quest_detall;
    var quest = "";
    var informe = "";

    var xmlhttp;
    xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function()
    {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            json_obj=xmlhttp.responseText;
            //console.log(json_obj)
            var arr = JSON.parse(json_obj);

            var nom = arr[0].nom + ' ' + arr[0].cognoms;
            var nota = arr[0].nota;
            var dia_arr = arr[0].dia.split('-');
            var dia_cat = dia_arr[2]+'-'+dia_arr[1]+'-'+dia_arr[0];
            quest = arr[0].quest + ' (' + dia_cat + ')';
            //informe = '<h1>' + nom + '</h1>';
            informe = informe + '<h2>' + quest + '</h2>';
            informe = informe + '<h2>Nota: ' + nota + '</h2>';

			for (var i=0;i<arr.length;i++) {

                informe = informe + '<h3>' + (i+1) + '. ' + arr[i].questio + '</h3>';
                if (arr[i].valor==0) {
                    informe = informe + 'La teva resposta:';
                    informe = informe + '<pre>' + arr[i].resposta + '</pre>';
                    informe = informe + 'Solució:';
                    informe = informe + '<pre>' + arr[i].solucio + '</pre>';
                } else {
                    informe = informe + '<pre>' + arr[i].solucio + '</pre>';
                }
			}
			
			document.getElementById("llista").innerHTML = informe;
        }
    }
    xmlhttp.open("POST","./php/informe_questionari_professor.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("id_quest_detall=" + id_quest_detall);
}

// ==================================
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
            if (arr!="") {
                //console.log(arr[0])
                email = arr[0].email;
                id_professor = arr[0].id_professor;
                nom = arr[0].nom;
                cognoms = arr[0].cognoms;
                curs = arr[0].curs;
                //document.forms[0].id_professor.value = id_professor;
                document.getElementById("email").innerHTML = email;
                //load_alumnes(); //només es carreguen els alumnes i els qüestionaris si ens hem logat correctament com a professor.
                load_alumnes_professor();
                load_quests_professor();
            } else {
                document.getElementById("email").innerHTML = "No existeix " + email + " a la bd i amb rol de professor";
            }
        }
    }
    xmlhttp.open("POST","./php/cerca_professor.php",true);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send("email=" + email);

}