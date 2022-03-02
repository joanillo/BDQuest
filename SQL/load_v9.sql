/*
cd /home/joan/projectes/BDQuest/SQL
mysql -u root -p bdquest -f < ./load_v9.sql > ./control_errors.log 2>&1
cat control_errors.log

Per canviar l'usuari jquintana@jaumebalmes.net al rol d'alumne (1) o professor (0):
mysql -u bdquest -pkeiL2lai -e "update alumne set actiu=1 where email='jquintana@jaumebalmes.net'" bdquest

bases de dades de treball
bd (id_bd, bd, num_taules)
#proposta d'exercicis sobre la base de dades de treball
bd_questio (id_bd_questio, id_bd, questio, nivell, rollback, solucio)
bd_questio_comprovacio (id_bd_questio, ordre, comprovacio)
bd_questio_prepost (id_bd_questio, ordre, sentencia_prepost)

alumne (id_alumne, nom, cognoms, rol, curs, email)
professor (id_professor, nom, cognoms, rol, curs, email)
quest (id_quest, quest, dia, id_bd, random, actiu)
quest_detall (id_quest_detall, id_quest, id_bd_questio, num_pregunta)
alumne_quest (id_alumne_quest, id_usuari, id_quest, dia, nota)
alumne_quest_detall (id_alumne_quest_detall, id_alumne_quest, id_quest_detall, valor, resposta)
*/

# CREATE DATABASE bdquest CHARACTER SET utf8 COLLATE utf8_general_ci;
# use bdquest
# CREATE USER bdquest@localhost IDENTIFIED BY 'keiL2lai';
# GRANT ALL ON bdquest.* TO bdquest@localhost;
# GRANT ALL ON municipis.* TO bdquest@localhost;
# GRANT ALL ON sakila.* TO bdquest@localhost;
# GRANT ALL ON langtrainer.* TO bdquest@localhost;
# GRANT ALL ON northwind.* TO bdquest@localhost;
# GRANT ALL ON empresa.* TO bdquest@localhost;
# flush privileges

DROP VIEW IF EXISTS informe_quest;
DROP TABLE IF EXISTS alumne_quest_detall;
DROP TABLE IF EXISTS alumne_quest;
DROP TABLE IF EXISTS quest_detall;
DROP TABLE IF EXISTS quest;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS alumne;
DROP TABLE IF EXISTS bd_questio_prepost;
DROP TABLE IF EXISTS bd_questio_comprovacio;
DROP TABLE IF EXISTS bd_questio;
DROP TABLE IF EXISTS bd;

CREATE TABLE bd (
id_bd smallint AUTO_INCREMENT PRIMARY KEY,
bd VARCHAR(50) NOT NULL,
num_taules smallint
);

CREATE TABLE bd_questio (
id_bd_questio smallint AUTO_INCREMENT PRIMARY KEY,
id_bd smallint,
questio VARCHAR(1024) NOT NULL,
nivell smallint CHECK (nivell IN (1,2,3,4,5)),
rollback smallint CHECK (rollback IN (0,1,2)),
solucio text,
FOREIGN KEY (id_bd) REFERENCES bd(id_bd)
);

CREATE TABLE bd_questio_comprovacio (
id_bd_questio smallint,
ordre smallint CHECK (ordre IN (1,2,3)),
comprovacio VARCHAR(255) NOT NULL,
PRIMARY KEY(id_bd_questio, ordre),
FOREIGN KEY(id_bd_questio) REFERENCES bd_questio(id_bd_questio)
);

CREATE TABLE bd_questio_prepost (
id_bd_questio smallint,
ordre smallint,
sentencia_prepost VARCHAR(255) NOT NULL,
tipus varchar(5) CHECK (tipus IN ('PRE', 'POST')),
PRIMARY KEY(id_bd_questio, ordre, tipus),
FOREIGN KEY(id_bd_questio) REFERENCES bd_questio(id_bd_questio)
);

CREATE TABLE alumne (
id_alumne smallint AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(255) NOT NULL,
cognoms VARCHAR(255) NOT NULL,
curs VARCHAR(5) NULL,
email VARCHAR(255) NOT NULL,
actiu BOOLEAN
);

CREATE TABLE professor (
id_professor smallint AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(255) NOT NULL,
cognoms VARCHAR(255) NOT NULL,
curs VARCHAR(5) NULL,
email VARCHAR(255) NOT NULL
);

CREATE TABLE quest (
id_quest smallint AUTO_INCREMENT PRIMARY KEY,
quest VARCHAR(255) NOT NULL,
id_professor smallint,
dia DATE NOT NULL,
id_bd smallint,
random BOOLEAN,
actiu BOOLEAN,
FOREIGN KEY(id_bd) REFERENCES bd(id_bd),
FOREIGN KEY(id_professor) REFERENCES professor(id_professor)
);

CREATE TABLE quest_detall (
id_quest_detall smallint AUTO_INCREMENT PRIMARY KEY,
id_quest smallint NOT NULL,
id_bd_questio smallint,
num_pregunta smallint,
FOREIGN KEY(id_quest) REFERENCES quest(id_quest),
FOREIGN KEY(id_bd_questio) REFERENCES bd_questio(id_bd_questio)
);

CREATE TABLE alumne_quest (
id_alumne_quest smallint AUTO_INCREMENT PRIMARY KEY,
id_alumne smallint,
id_quest smallint,
dia DATE NOT NULL,
nota decimal(4,2) CHECK (nota >= 0 and nota <= 10),
FOREIGN KEY(id_alumne) REFERENCES alumne(id_alumne),
FOREIGN KEY(id_quest) REFERENCES quest(id_quest)
);

CREATE TABLE alumne_quest_detall (
id_alumne_quest_detall smallint AUTO_INCREMENT PRIMARY KEY,
id_alumne_quest smallint,
id_quest_detall smallint,
valor smallint CHECK (valor IN (0,1)),
resposta VARCHAR(2048),
FOREIGN KEY(id_alumne_quest) REFERENCES alumne_quest(id_alumne_quest),
FOREIGN KEY(id_quest_detall) REFERENCES quest_detall(id_quest_detall)
);

CREATE VIEW informe_quest AS (SELECT q.id_quest, a.id_alumne, aq.id_alumne_quest, aq.dia, quest, nom, cognoms, nota, questio, valor, resposta, solucio FROM (((((alumne a INNER JOIN alumne_quest aq ON a.id_alumne=aq.id_alumne) INNER JOIN quest q ON q.id_quest=aq.id_quest) INNER JOIN alumne_quest_detall aqd ON aq.id_alumne_quest=aqd.id_alumne_quest) INNER JOIN quest_detall qd ON aqd.id_quest_detall=qd.id_quest_detall) INNER JOIN bd_questio bdq ON bdq.id_bd_questio=qd.id_bd_questio));

INSERT INTO bd VALUES (1,'municipis',3);
INSERT INTO bd VALUES (2,'sakila',23);
INSERT INTO bd VALUES (3,'langtrainer',7);

INSERT INTO bd_questio VALUES (1, 1, 'Llista de províncies (id i provincia), ordentat per id', 1, 0,'select id_prov, provincia from provincies order by id_prov');
INSERT INTO bd_questio VALUES (2, 1, 'Els 5 primers municipis de Càceres (només el nom del municipi), per ordre alfabètic. NOTA: no has de saber quin és el id de Cáceres.', 1, 0, 'select municipi from municipis m INNER JOIN provincies p ON m.id_prov=p.id_prov where  provincia=''Cáceres'' order by municipi limit 5');
INSERT INTO bd_questio VALUES (3, 1, 'Les províncies de Catalunya (id i província, ordenat per provincia)', 1, 0,'select id_prov, provincia from provincies p, comunitats c where c.id_com=p.id_com and comunitat=''Catalunya'' order by id_prov;');
INSERT INTO bd_questio VALUES (4, 1, 'Muncipis de Catalunya que comencen per ''A'' (ordre alfabètic) NOTA: no pots fer servir id_com=1.', 1, 0,'select municipi from municipis m JOIN provincies p ON m.id_prov=p.id_prov JOIN comunitats c ON c.id_com=p.id_com WHERE comunitat=''Catalunya'' and municipi like ''A%'' order by municipi');
INSERT INTO bd_questio VALUES (5, 1, 'Comunitats i número de províncies que contenen (id_com, comunitat, num_provincies, ordenat per id_com).', 1, 0,'select c.id_com, comunitat, count(*) as num_provincies from provincies p JOIN comunitats c ON c.id_com=p.id_com GROUP BY c.id_com, comunitat order by c.id_com');

INSERT INTO bd_questio VALUES (6, 2, 'Llista de ciutats i països, ordenats per país i ciutat.', 2, 0,'select city, country from city INNER JOIN country ON city.country_id=country.country_id order by country, city');
INSERT INTO bd_questio VALUES (7, 2, 'En quines pel·lícules ha participat l''actor GREGORY GOODING. Ordena per títol.', 2, 0, 'select title from ((film f INNER JOIN film_actor fa ON f.film_id=fa.film_id) INNER JOIN actor a ON fa.actor_id=a.actor_id) WHERE first_name=''GREGORY'' and last_name=''GOODING'' order by title');
INSERT INTO bd_questio VALUES (8, 2, 'Títols de les pel·lícules en anglès (ordre alfabètic, les 10 primeres).', 2, 0, 'select title from film f INNER JOIN language l USING(language_id) WHERE name=''English'' order by title limit 10');
INSERT INTO bd_questio VALUES (9, 2, 'Llista de pel·lícules de la categoria Documentals (títol, ordenat alfabèticament).', 2, 0, 'select title from ((film f INNER JOIN film_category fc ON f.film_id=fc.film_id) INNER JOIN category c ON fc.category_id=c.category_id) WHERE c.name=''Documentary'' order by title;');

INSERT INTO bd_questio VALUES (10, 1, 'Inserció del municipi ''Brocà'' a la província de Barcelona.', 1, 1, 'insert into municipis(id_mun,municipi,id_prov) values (8109,''Brocà'',8);');
INSERT INTO bd_questio VALUES (11, 1, 'Canviar el municipi 186 a la província 25', 1, 1, 'update municipis set id_prov=25 where id_mun=186;');
INSERT INTO bd_questio VALUES (12, 1, 'Canviar el municipi ''Callosa de Segura'' a la província de València',1,1,'update municipis set id_prov=(select id_prov from provincies where provincia=''València'') where municipi=''Callosa de Segura'';');
INSERT INTO bd_questio VALUES (13, 1, 'Esborrar els municipis de Girona que comencen per A',1,1,'delete from municipis where id_prov=(select id_prov from provincies where provincia=''Girona'') and municipi like ''A%'';');
INSERT INTO bd_questio VALUES (14, 1, 'Assignar tots els municipis de Lleida a Girona, i de Girona a Lleida (pista: crear una provincia temporal)',5,1,'insert into provincies(id_prov, provincia, id_com) values (53, ''temp'', 1);update municipis set id_prov=53 where id_prov=17;update municipis set id_prov=17 where id_prov=25;update municipis set id_prov=25 where id_prov=53;delete from provincies where id_prov=53;');

INSERT INTO bd_questio VALUES (15, 1, 'crear la taula comarca amb els camps id_com (PK), comarca i id_prov', 1, 2, 'CREATE TABLE comarca (id smallint primary key, comarca varchar(255), id_prov smallint REFERENCES provincies)');
INSERT INTO bd_questio VALUES (16, 1, 'eliminar la taula comarca', 1, 2, 'DROP TABLE comarca');
INSERT INTO bd_questio VALUES (17, 1, 'modificar la taula comarca perquè hi càpiguen comarques de com a mínim 50 caràcters', 1, 2, 'ALTER TABLE comarca MODIFY COLUMN comarca VARCHAR(50)');

INSERT INTO bd_questio_comprovacio VALUES (10,1,'select municipi from municipis where id_mun>=8109');
INSERT INTO bd_questio_comprovacio VALUES (10,2,'select count(*) from municipis');
INSERT INTO bd_questio_comprovacio VALUES (11,1,'select count(*) from municipis where id_prov=3');
INSERT INTO bd_questio_comprovacio VALUES (11,2,'select count(*) from municipis where id_prov=25');
INSERT INTO bd_questio_comprovacio VALUES (12,1,'select count(*) from municipis where id_prov=3');
INSERT INTO bd_questio_comprovacio VALUES (12,2,'select count(*) from municipis where id_prov=46');
INSERT INTO bd_questio_comprovacio VALUES (13,1,'select count(*) from municipis where id_prov=17');
INSERT INTO bd_questio_comprovacio VALUES (13,2,'select * from municipis where municipi like ''A%'' and id_prov=17 order by id_mun');
INSERT INTO bd_questio_comprovacio VALUES (13,3,'select id_prov, count(*) from municipis group by id_prov order by id_prov');
INSERT INTO bd_questio_comprovacio VALUES (14,1,'select id_prov, count(*) as num from provincies group by id_prov');

INSERT INTO bd_questio_prepost VALUES (15,1,'insert into comarca values(1,''comarca1'',5)','POST');
INSERT INTO bd_questio_prepost VALUES (15,2,'insert into comarca values(2,''comarca2'',5)','POST');
INSERT INTO bd_questio_prepost VALUES (15,3,'insert into comarca values(3,''comarca3'',5)','POST');
INSERT INTO bd_questio_prepost VALUES (15,4,'select * from comarca','POST');
INSERT INTO bd_questio_prepost VALUES (15,5,'DROP TABLE comarca','POST');

INSERT INTO bd_questio_prepost VALUES (16,1,'CREATE TABLE comarca (id_com smallint primary key, comarca varchar(255), id_prov smallint REFERENCES provincies)','PRE');
INSERT INTO bd_questio_prepost VALUES (16,2,'DROP TABLE comarca','POST');

INSERT INTO bd_questio_prepost VALUES (17,1,'CREATE TABLE comarca (id_com smallint primary key, comarca varchar(10), id_prov smallint REFERENCES provincies)', 'PRE');
INSERT INTO bd_questio_prepost VALUES (17,2,'insert into comarca values(1,''comarca1'',5)', 'PRE');
INSERT INTO bd_questio_prepost VALUES (17,3,'insert into comarca values(2,''comarca2'',5)', 'PRE');
INSERT INTO bd_questio_prepost VALUES (17,4,'insert into comarca values(3,''comarca3'',5)', 'PRE');
INSERT INTO bd_questio_prepost VALUES (17,1,'insert into comarca values(4,''comarca amb més longitud'',5)', 'POST');
INSERT INTO bd_questio_prepost VALUES (17,2,'DROP TABLE comarca', 'POST');

INSERT INTO alumne VALUES (1, 'Arnau', 'Riera', '1DAM', 'empresa@jaumebalmes.net',1);
INSERT INTO alumne VALUES (2, 'Maria', 'Quintana', '1DAM', '20mquintan@jaumebalmes.net',1);
INSERT INTO alumne VALUES (3, 'Clara', 'Ventura', '1DAM', 'clara@jaumebalmes.net',1);
INSERT INTO alumne VALUES (4, 'Ramon', 'Rovira', '1DAM', 'rrovira@jaumebalmes.net',1);
INSERT INTO alumne VALUES (5, 'Joan', 'Quintana', '1DAM', 'jquintana@jaumebalmes.net',0);

INSERT INTO professor VALUES (1, 'Joan', 'Quintana', '1DAM', 'jquintana@jaumebalmes.net');
INSERT INTO professor VALUES (2, 'Joan', 'Quintana', '1DAW', 'admin@jaumebalmes.net');

INSERT INTO quest VALUES (1, 'bàsic municipis', 1, '2021-07-05', 1, 0, 1);
INSERT INTO quest VALUES (2, 'bàsic municipis 2', 1, '2021-07-05', 1, 1, 1);
INSERT INTO quest VALUES (3, 'bàsic sakila', 1, '2021-07-05', 2, 0, 1);
INSERT INTO quest VALUES (4, 'bàsic sakila 2', 1, '2021-07-05', 2, 1, 1);
INSERT INTO quest VALUES (5, 'bàsic DML municipis', 1, '2021-07-11', 1, 0, 1);
INSERT INTO quest VALUES (6, 'repàs municipis', 1, '2021-07-11', 1, 0, 1);
INSERT INTO quest VALUES (7, 'bàsic create-drop-alter table', 1, '2021-07-22', 1, 0, 1);

INSERT INTO quest_detall VALUES (1, 1, 1, 1);
INSERT INTO quest_detall VALUES (2, 1, 2, 2);
INSERT INTO quest_detall VALUES (3, 1, 3, 3);
INSERT INTO quest_detall VALUES (4, 1, 4, 4);
INSERT INTO quest_detall VALUES (5, 2, 3, 1);
INSERT INTO quest_detall VALUES (6, 2, 4, 2);
INSERT INTO quest_detall VALUES (7, 2, 5, 3);
INSERT INTO quest_detall VALUES (8, 3, 6, 1);
INSERT INTO quest_detall VALUES (9, 3, 7, 2);
INSERT INTO quest_detall VALUES (10, 3, 8, 3);
INSERT INTO quest_detall VALUES (11, 4, 7, 1);
INSERT INTO quest_detall VALUES (12, 4, 8, 2);
INSERT INTO quest_detall VALUES (13, 4, 9, 3);
INSERT INTO quest_detall VALUES (14, 5, 10, 1);
INSERT INTO quest_detall VALUES (15, 5, 11, 2);
INSERT INTO quest_detall VALUES (16, 5, 12, 3);
INSERT INTO quest_detall VALUES (17, 5, 13, 4);
INSERT INTO quest_detall VALUES (18, 5, 14, 5);
INSERT INTO quest_detall VALUES (19, 6, 1, 1);
INSERT INTO quest_detall VALUES (20, 6, 2, 2);
INSERT INTO quest_detall VALUES (21, 7, 15, 3);
INSERT INTO quest_detall VALUES (22, 7, 16, 2);
INSERT INTO quest_detall VALUES (23, 7, 17, 1);

# mostra de qüestionaris que fan els alumnes
INSERT INTO alumne_quest VALUES(1,1,1,'2021/07/13',NULL);
INSERT INTO alumne_quest VALUES(2,1,2,'2021/07/10',NULL);
INSERT INTO alumne_quest VALUES(3,1,3,'2021/07/11',NULL);
INSERT INTO alumne_quest VALUES(4,1,4,'2021/07/12',NULL);
INSERT INTO alumne_quest VALUES(5,1,5,'2021/07/13',NULL);
INSERT INTO alumne_quest VALUES(6,2,1,'2021/07/10',NULL);
INSERT INTO alumne_quest VALUES(7,2,2,'2021/07/11',NULL);
INSERT INTO alumne_quest VALUES(8,2,3,'2021/07/12',NULL);
INSERT INTO alumne_quest VALUES(9,2,4,'2021/07/12',NULL);
INSERT INTO alumne_quest VALUES(10,2,5,'2021/07/13',NULL);

INSERT INTO alumne_quest_detall VALUES(1,1,1,1,'resposta sql 1');
INSERT INTO alumne_quest_detall VALUES(2,1,2,0,'resposta sql 2');
INSERT INTO alumne_quest_detall VALUES(3,1,3,1,'resposta sql 3');
INSERT INTO alumne_quest_detall VALUES(4,1,4,0,'resposta sql 4');
UPDATE alumne_quest SET nota=5 where id_alumne_quest=1;

INSERT INTO alumne_quest_detall VALUES(5,2,5,1,'resposta sql 5');
INSERT INTO alumne_quest_detall VALUES(6,2,6,0,'resposta sql 6');
INSERT INTO alumne_quest_detall VALUES(7,2,7,1,'resposta sql 7');
UPDATE alumne_quest SET nota=6.66 where id_alumne_quest=2;

INSERT INTO alumne_quest_detall VALUES(8,3,8,1,'resposta sql 8');
INSERT INTO alumne_quest_detall VALUES(9,3,9,1,'resposta sql 9');
INSERT INTO alumne_quest_detall VALUES(10,3,10,1,'resposta sql 10');
UPDATE alumne_quest SET nota=10 where id_alumne_quest=3;

INSERT INTO alumne_quest_detall VALUES(11,4,11,1,'resposta sql 11');
INSERT INTO alumne_quest_detall VALUES(12,4,12,0,'resposta sql 12');
INSERT INTO alumne_quest_detall VALUES(13,4,13,0,'resposta sql 13');
UPDATE alumne_quest SET nota=3.33 where id_alumne_quest=4;

INSERT INTO alumne_quest_detall VALUES(14,5,14,1,'resposta sql 14');
INSERT INTO alumne_quest_detall VALUES(15,5,15,0,'resposta sql 15');
INSERT INTO alumne_quest_detall VALUES(16,5,16,1,'resposta sql 16');
INSERT INTO alumne_quest_detall VALUES(17,5,17,0,'resposta sql 17');
INSERT INTO alumne_quest_detall VALUES(18,5,18,0,'resposta sql 18');
UPDATE alumne_quest SET nota=3.33 where id_alumne_quest=5;

INSERT INTO alumne_quest_detall VALUES(19,6,1,1,'resposta sql 19');
INSERT INTO alumne_quest_detall VALUES(20,6,2,1,'resposta sql 20');
INSERT INTO alumne_quest_detall VALUES(21,6,3,1,'resposta sql 21');
INSERT INTO alumne_quest_detall VALUES(22,6,4,0,'resposta sql 22');
UPDATE alumne_quest SET nota=7.5 where id_alumne_quest=6;

INSERT INTO alumne_quest_detall VALUES(23,7,5,1,'resposta sql 23');
INSERT INTO alumne_quest_detall VALUES(24,7,6,1,'resposta sql 24');
INSERT INTO alumne_quest_detall VALUES(25,7,7,1,'resposta sql 25');
UPDATE alumne_quest SET nota=10 where id_alumne_quest=7;

INSERT INTO alumne_quest_detall VALUES(26,8,8,0,'resposta sql 26');
INSERT INTO alumne_quest_detall VALUES(27,8,9,0,'resposta sql 27');
INSERT INTO alumne_quest_detall VALUES(28,8,10,0,'resposta sql 28');
UPDATE alumne_quest SET nota=0 where id_alumne_quest=8;

INSERT INTO alumne_quest_detall VALUES(29,9,11,1,'resposta sql 29');
INSERT INTO alumne_quest_detall VALUES(30,9,12,1,'resposta sql 30');
INSERT INTO alumne_quest_detall VALUES(31,9,13,0,'resposta sql 31');
UPDATE alumne_quest SET nota=6.66 where id_alumne_quest=9;

INSERT INTO alumne_quest_detall VALUES(32,10,14,1,'resposta sql 32');
INSERT INTO alumne_quest_detall VALUES(33,10,15,0,'resposta sql 33');
INSERT INTO alumne_quest_detall VALUES(34,10,16,1,'resposta sql 34');
INSERT INTO alumne_quest_detall VALUES(35,10,17,1,'resposta sql 35');
INSERT INTO alumne_quest_detall VALUES(36,10,18,0,'resposta sql 36');
UPDATE alumne_quest SET nota=6.0 where id_alumne_quest=10;

# consultes
# donat el id_quest, llistat de les preguntes:
#select id_quest_detall, bd, questio, solucio from quest_detall qd, bd_questio bdq, bd where qd.id_bd_questio=bdq.id_bd_questio and bd.id_bd=bdq.id_bd and id_quest=1;

# puntuem una pregunta
#select id_quest_detall from quest_detall where id_quest=1 and num=2; # 2
#insert into alumne_quest_detall values (1,3,2,1);

/*
# informe del id_quest=1
#persones que han realitzat aquest quest:
select nom, cognoms, aq.id_quest, nota from alumne a, alumne_quest aq where a.id_alumne=aq.id_alumne and aq.id_quest=1 order by cognoms;

# informe del id_quest=1 (i que l'han acabat)
#persones que han realitzat aquest quest:
select nom, cognoms, aq.id_quest, nota from alumne a, alumne_quest aq where a.id_alumne=aq.id_alumne and aq.id_quest=1 and nota is not null order by cognoms;

# informe dels alumnes que han fet (i acabat) el id_quest=1
select distinct nom, cognoms, aq.id_quest from alumne a, alumne_quest aq where a.id_alumne=aq.id_alumne and aq.id_quest=1 and nota is not null order by cognoms;

#Resum qüestionari id_quest=1 and id_usuari=3:
select quest, aq.id_alumne_quest, aq.dia, nom, cognoms, nota, questio, valor, resposta, solucio from alumne a, alumne_quest aq, quest q, alumne_quest_detall aqd, quest_detall qd, bd_questio bdq where a.id_alumne=aq.id_alumne and q.id_quest=aq.id_quest and aq.id_alumne_quest=aqd.id_alumne_quest and aqd.id_quest_detall=qd.id_quest_detall and bdq.id_bd_questio=qd.id_bd_questio and qd.id_bd_questio=bdq.id_bd_questio and q.id_quest=1 and  a.id_alumne=3 order by cognoms;
o bé:
select * from informe_quest where id_quest=1 and  id_alumne=3 order by cognoms, dia desc;
select * from informe_quest where id_quest=1 and  id_alumne=3 and id_alumne_quest=14 order by cognoms, dia desc;
//l'alumne pot haver fet vàries vegades el qüestionari, i per tant hem d'agafar l'últim que ha realitzat
select * from informe_quest where id_quest=1 and  id_alumne=3 and id_alumne_quest=(select max(id_alumne_quest) from informe_quest where id_quest=1 and  id_alumne=3);

# alumnes del professor jquintana@jaumebalmes.net (el professor és de 1DAM i els seus alumnes són 1DAM)
select * from alumne a where curs=(select curs from alumne where email='jquintana@jaumebalmes.net') and email NOT IN ('jquintana@jaumebalmes.net','empresa@jaumebalmes.net') order by cognoms;

#(outer join) quests que ha fet el professor jquintana@jaumebalmes.net, agrupat per número d'alumnes que l'ha contestat
select q.id_quest, quest, count(id_alumne) as num from (alumne_quest aq right outer join quest q on q.id_quest=aq.id_quest), professor p where q.id_professor=p.id_professor and email='jquintana@jaumebalmes.net' group by q.id_quest;

#(outer join) alumnes del professor jquintana@jaumebalmes.net, agrupat per número de quests que han contestat
select a.id_alumne, a.nom, a.cognoms, count(q.id_quest) as num from ((((alumne a inner join professor p1 ON a.curs=p1.curs) left outer join alumne_quest aq ON a.id_alumne=aq.id_alumne) left outer join quest q ON aq.id_quest=q.id_quest) left outer join professor p ON q.id_professor=p.id_professor) where p1.email='jquintana@jaumebalmes.net' group by a.id_alumne, a.nom, a.cognoms;

# un alumne ha fet un qüestionari, aquest és l'informe:
select nom, cognoms, quest, nota, q.dia, questio, valor, resposta, solucio from alumne a, alumne_quest aq, quest q, quest_detall qd, bd_questio bdq, alumne_quest_detall aqd where a.id_alumne=aq.id_alumne and aq.id_quest=q.id_quest and q.id_quest=qd.id_quest and bdq.id_bd_questio=qd.id_bd_questio and aqd.id_quest_detall=qd.id_quest_detall and aq.id_alumne_quest=aqd.id_alumne_quest and aq.id_alumne_quest=1;

*/
