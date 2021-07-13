/*
bases de dades de treball
bd (id_bd, bd, num_taules)
#proposta d'exercicis sobre la base de dades de treball
bd_questio (id_bd_questio, id_bd, questio, nivell, rollback, solucio)

usuari (id_usuari, nom, cognoms, rol, curs, email)
quest (id_quest, quest, dia, id_bd, random)
quest_detall (id_quest_detall, id_quest, id_bd_questio, num_pregunta)
usuari_quest (id_usuari_quest, id_usuari, id_quest, dia, nota)
usuari_quest_detall (id_usuari_quest_detall, id_usuari_quest, id_quest_detall, valor, resposta)
*/

# CREATE DATABASE bdquest CHARACTER SET utf8 COLLATE utf8_general_ci;
# use bdquest
# CREATE USER bdquest@localhost IDENTIFIED BY 'keiL2lai';
# GRANT ALL ON bdquest.* TO bdquest@localhost;
# GRANT ALL ON municipis.* TO bdquest@localhost;
# GRANT ALL ON sakila.* TO bdquest@localhost;
# flush privileges

DROP TABLE IF EXISTS usuari_quest_detall;
DROP TABLE IF EXISTS usuari_quest;
DROP TABLE IF EXISTS quest_detall;
DROP TABLE IF EXISTS quest;
DROP TABLE IF EXISTS usuari;
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
questio VARCHAR(255) NOT NULL,
nivell smallint CHECK (nivell IN (1,2,3,4,5)),
rollback BOOLEAN NOT NULL DEFAULT FALSE,
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

CREATE TABLE usuari (
id_usuari smallint AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(255) NOT NULL,
cognoms VARCHAR(255) NOT NULL,
rol VARCHAR(30) CHECK (rol IN ('admin', 'professor', 'alumne')),
curs VARCHAR(5) NULL,
email VARCHAR(255) NOT NULL
);

CREATE TABLE quest (
id_quest smallint AUTO_INCREMENT PRIMARY KEY,
quest VARCHAR(255) NOT NULL,
dia DATE NOT NULL,
id_bd smallint,
random BOOLEAN,
FOREIGN KEY(id_bd) REFERENCES bd(id_bd)
);

CREATE TABLE quest_detall (
id_quest_detall smallint AUTO_INCREMENT PRIMARY KEY,
id_quest smallint NOT NULL,
id_bd_questio smallint,
num_pregunta smallint,
FOREIGN KEY(id_quest) REFERENCES quest(id_quest),
FOREIGN KEY(id_bd_questio) REFERENCES bd_questio(id_bd_questio)
);


CREATE TABLE usuari_quest (
id_usuari_quest smallint AUTO_INCREMENT PRIMARY KEY,
id_usuari smallint,
id_quest smallint,
dia DATE NOT NULL,
nota decimal(4,2) CHECK (nota >= 0 and nota <= 10),
FOREIGN KEY(id_usuari) REFERENCES usuari(id_usuari),
FOREIGN KEY(id_quest) REFERENCES quest(id_quest)
);

CREATE TABLE usuari_quest_detall (
id_usuari_quest_detall smallint AUTO_INCREMENT PRIMARY KEY,
id_usuari_quest smallint,
id_quest_detall smallint,
valor smallint CHECK (valor IN (0,1)),
resposta VARCHAR(255),
FOREIGN KEY(id_usuari_quest) REFERENCES usuari_quest(id_usuari_quest),
FOREIGN KEY(id_quest_detall) REFERENCES quest_detall(id_quest_detall)
);

INSERT INTO bd VALUES (1,'municipis',3);
INSERT INTO bd VALUES (2,'sakila',23);

INSERT INTO bd_questio VALUES (1, 1, 'Llista de províncies (id i provincia), ordentat per id', 1, 0,'select id_prov, provincia from provincies order by id_prov;');
INSERT INTO bd_questio VALUES (2, 1, 'Els 5 primers municipis de Càceres (només el nom del municipi), per ordre alfabètic. NOTA: no has de saber quin és el id de Cáceres.', 1, 0, 'select municipi from municipis m, provincies p where m.id_prov=p.id_prov and provincia=''Cáceres'' order by municipi limit 5;');
INSERT INTO bd_questio VALUES (3, 1, 'Les províncies de Catalunya (id i província, ordenat per provincia)', 1, 0,'select id_prov, provincia from provincies p, comunitats c where c.id_com=p.id_com and comunitat=''Catalunya'' order by id_prov;');
INSERT INTO bd_questio VALUES (4, 1, 'Muncipis de Catalunya que comencen per ''A'' (ordre alfabètic) NOTA: no pots fer servir id_com=1.', 1, 0,'select municipi from municipis m, provincies p, comunitats c where m.id_prov=p.id_prov and c.id_com=p.id_com and comunitat=''Catalunya'' and municipi like ''A%'' order by municipi;');
INSERT INTO bd_questio VALUES (5, 1, 'Comunitats i número de províncies que contenen (id_com, comunitat, num_provincies, ordenat per id_com).', 1, 0,'select c.id_com, comunitat, count(*) as num_provincies from provincies p, comunitats c where c.id_com=p.id_com GROUP BY c.id_com, comunitat order by c.id_com;');

INSERT INTO bd_questio VALUES (6, 2, 'Llista de ciutats i països, ordenats per país i ciutat.', 2, 0,'select city, country from city, country where city.country_id=country.country_id order by country, city;');
INSERT INTO bd_questio VALUES (7, 2, 'En quines pel·lícules ha participat l''actor GREGORY GOODING. Ordena per títol.', 2, 0, 'select title from film f, actor a, film_actor fa where f.film_id=fa.film_id and fa.actor_id=a.actor_id and first_name=''GREGORY'' and last_name=''GOODING'' order by title;');
INSERT INTO bd_questio VALUES (8, 2, 'Títols de les pel·lícules en anglès (ordre alfabètic, les 10 primeres).', 2, 0, 'select title from film f, language l where f.language_id=l.language_id and name=''English'' order by title limit 10;');
INSERT INTO bd_questio VALUES (9, 2, 'Llista de pel·lícules de la categoria Documentals (títol, ordenat alfabèticament).', 2, 0, 'select title from film f, category c, film_category fc where f.film_id=fc.film_id and fc.category_id=c.category_id and c.name=''Documentary'' order by title;');

INSERT INTO bd_questio VALUES (10, 1, 'Inserció del municipi ''Brocà'' a la província de Barcelona.', 1, 1, 'insert into municipis(id_mun,municipi,id_prov) values (8109,''Brocà'',8);');
INSERT INTO bd_questio VALUES (11, 1, 'Canviar el municipi 186 a la província 25', 1, 1, 'update municipis set id_prov=25 where id_mun=186;');
INSERT INTO bd_questio VALUES (12, 1, 'Canviar el municipi ''Callosa de Segura'' a la província de València',1,1,'update municipis set id_prov=(select id_prov from provincies where provincia=''València'') where municipi=''Callosa de Segura'';');
INSERT INTO bd_questio VALUES (13, 1, 'Esborrar els municipis de Girona que comencen per A',1,1,'delete from municipis where id_prov=(select id_prov from provincies where provincia=''Girona'') and municipi like ''A%'';');
INSERT INTO bd_questio VALUES (14, 1, 'Assignar tots els municipis de Lleida a Girona, i de Girona a Lleida (pista: crear una provincia temporal)',5,1,'insert into provincies(id_prov, provincia, id_com) values (53, ''temp'', 1);update municipis set id_prov=53 where id_prov=17;update municipis set id_prov=17 where id_prov=25;update municipis set id_prov=25 where id_prov=53;delete from provincies where id_prov=53;');

INSERT INTO bd_questio_comprovacio VALUES (10,1,'select municipi from municipis where id_mun>=8109;');
INSERT INTO bd_questio_comprovacio VALUES (10,2,'select count(*) from municipis;');
INSERT INTO bd_questio_comprovacio VALUES (11,1,'select count(*) from municipis where id_prov=3;');
INSERT INTO bd_questio_comprovacio VALUES (11,2,'select count(*) from municipis where id_prov=25;');
INSERT INTO bd_questio_comprovacio VALUES (12,1,'select count(*) from municipis where id_prov=3;');
INSERT INTO bd_questio_comprovacio VALUES (12,2,'select count(*) from municipis where id_prov=25;');
INSERT INTO bd_questio_comprovacio VALUES (13,1,'select count(*) from municipis where id_prov=17;');
INSERT INTO bd_questio_comprovacio VALUES (13,2,'select * from municipis where municipi like ''A%'' and id_prov=17 order by id_mun;');
INSERT INTO bd_questio_comprovacio VALUES (13,3,'select id_prov, count(*) from municipis group by id_prov order by id_prov;');
INSERT INTO bd_questio_comprovacio VALUES (14,1,'select id_prov, count(*) as num from provincies group by id_prov;');

INSERT INTO usuari VALUES (1, 'Joan', 'Quintana', 'admin', NULL, 'admin@jaumebalmes.net');
INSERT INTO usuari VALUES (2, 'Joan', 'Quintana', 'professor', NULL, 'jquintana@jaumebalmes.net');
INSERT INTO usuari VALUES (3, 'Arnau', 'Riera', 'alumne', '1DAM', 'empresa@jaumebalmes.net');
INSERT INTO usuari VALUES (4, 'Clara', 'Ventura', 'alumne', '1DAM', 'clara@jaumebalmes.net');
INSERT INTO usuari VALUES (5, 'Maria', 'Quintana', 'alumne', '1ASIX', '20mquintan@jaumebalmes.net');

INSERT INTO quest VALUES (1, 'bàsic municipis', '2021-07-05', 1, 0);
INSERT INTO quest VALUES (2, 'bàsic municipis 2', '2021-07-05', 1, 1);
INSERT INTO quest VALUES (3, 'bàsic sakila', '2021-07-05', 2, 0);
INSERT INTO quest VALUES (4, 'bàsic sakila 2', '2021-07-05', 2, 1);
INSERT INTO quest VALUES (5, 'bàsic DML municipis', '2021-07-11', 1, 0);

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


# consultes
# donat el id_quest, llistat de les preguntes:
#select id_quest_detall, bd, questio, solucio from quest_detall qd, bd_questio bdq, bd where qd.id_bd_questio=bdq.id_bd_questio and bd.id_bd=bdq.id_bd and id_quest=1;

# puntuem una pregunta
#select id_quest_detall from quest_detall where id_quest=1 and num=2; # 2
#insert into usuari_quest_detall values (1,3,2,1);
