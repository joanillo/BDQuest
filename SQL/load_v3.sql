/*
bases de dades de treball
bd (id_bd, bd, num_taules)
#proposta d'exercicis sobre la base de dades de treball
bd_questio (id_bd_questio, id_bd, questio, nivell, solucio)

usuari (id_usuari, nom, cognoms, curs)
quest (id_quest, quest, dia, id_bd, random)
quest_detall (id_quest_detall, id_quest, id_bd_questio, num)
usuari_quest (id_usuari_quest, id_usuari, id_quest, dia, nota)
usuari_quest_detall (id_usuari_quest_detall, id_usuari_quest, id_quest_detall, valor)
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
DROP TABLE IF EXISTS bd_questio;
DROP TABLE IF EXISTS bd;

CREATE TABLE bd (
id_bd smallint AUTO_INCREMENT PRIMARY KEY,
bd VARCHAR(50) NOT NULL,
num_taules smallint
);

CREATE TABLE bd_questio (
id_bd_questio smallint AUTO_INCREMENT PRIMARY KEY,
id_bd smallint references BD,
questio VARCHAR(255) NOT NULL,
nivell smallint CHECK (nivell IN (1,2,3,4,5)),
solucio text
);

CREATE TABLE usuari (
id_usuari smallint AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(255) NOT NULL,
cognoms VARCHAR(255) NOT NULL,
rol VARCHAR(30) CHECK (rol IN ('admin', 'professor', 'alumne')),
curs VARCHAR(5) NULL
);

CREATE TABLE quest (
id_quest smallint AUTO_INCREMENT PRIMARY KEY,
quest VARCHAR(255) NOT NULL,
dia DATE NOT NULL,
id_bd smallint REFERENCES bd,
random BOOLEAN
);

CREATE TABLE quest_detall (
id_quest_detall smallint AUTO_INCREMENT PRIMARY KEY,
id_quest smallint NOT NULL REFERENCES quest,
id_bd_questio smallint REFERENCES bd_questio,
num smallint
);

CREATE TABLE usuari_quest (
id_usuari_quest smallint AUTO_INCREMENT PRIMARY KEY,
id_usuari smallint REFERENCES usuari(id_usuari),
id_quest smallint REFERENCES quest,
dia DATE NOT NULL,
nota decimal(4,2) CHECK (nota >= 0 and nota <= 10)
);

CREATE TABLE usuari_quest_detall (
id_usuari_quest_detall smallint AUTO_INCREMENT PRIMARY KEY,
id_usuari_quest smallint REFERENCES usuari_quest,
id_quest_detall smallint REFERENCES quest_detall,
valor smallint CHECK (valor IN (0,1))
);

INSERT INTO bd VALUES (1,'municipis',3);
INSERT INTO bd VALUES (2,'sakila',23);

INSERT INTO bd_questio VALUES (1, 1, 'Llista de províncies (id i provincia), ordentat per id', 1, 'select id_prov, provincia from provincies order by id_prov;');
INSERT INTO bd_questio VALUES (2, 1, 'Els 5 primers municipis de Càceres (només el nom del municipi), per ordre alfabètic. NOTA: no has de saber quin és el id de Cáceres.', 1, 'select municipi from municipis m, provincies p where m.id_prov=p.id_prov and provincia=''Cáceres'' order by municipi limit 5;');
INSERT INTO bd_questio VALUES (3, 1, 'Les províncies de Catalunya (id i província, ordenat per provincia)', 1, 'select id_prov, provincia from provincies p, comunitats c where c.id_com=p.id_com and comunitat=''Catalunya'' order by id_prov;');
INSERT INTO bd_questio VALUES (4, 1, 'Muncipis de Catalunya que comencen per ''A'' (ordre alfabètic) NOTA: no pots fer servir id_com=1.', 1, 'select municipi from municipis m, provincies p, comunitats c where m.id_prov=p.id_prov and c.id_com=p.id_com and comunitat=''Catalunya'' and municipi like ''A%'' order by municipi;');
INSERT INTO bd_questio VALUES (5, 1, 'Comunitats i número de províncies que contenen (id_com, comunitat, num_provincies, ordenat per id_com).', 1, 'select c.id_com, comunitat, count(*) as num_provincies from provincies p, comunitats c where c.id_com=p.id_com GROUP BY c.id_com, comunitat order by c.id_com;');

INSERT INTO bd_questio VALUES (6, 2, 'Llista de ciutats i països, ordenats per país i ciutat.', 2, 'select city, country from city, country where city.country_id=country.country_id order by country, city;');
INSERT INTO bd_questio VALUES (7, 2, 'En quines pel·lícules ha participat l''actor GREGORY GOODING. Ordena per títol.', 2, 'select title from film f, actor a, film_actor fa where f.film_id=fa.film_id and fa.actor_id=a.actor_id and first_name=''GREGORY'' and last_name=''GOODING'' order by title;');
INSERT INTO bd_questio VALUES (8, 2, 'Títols de les pel·lícules en anglès (ordre alfabètic, les 10 primeres).', 2, 'select title from film f, language l where f.language_id=l.language_id and name=''English'' order by title limit 10;');
INSERT INTO bd_questio VALUES (9, 2, 'Llista de pel·lícules de la categoria Documentals (títol, ordenat alfabèticament).', 2, 'select title from film f, category c, film_category fc where f.film_id=fc.film_id and fc.category_id=c.category_id and c.name=''Documentary'' order by title;');

INSERT INTO usuari VALUES (1, 'Joan', 'Quintana', 'admin', NULL);
INSERT INTO usuari VALUES (2, 'Joan', 'Quintana', 'professor', NULL);
INSERT INTO usuari VALUES (3, 'Arnau', 'Riera', 'alumne', '1DAM');
INSERT INTO usuari VALUES (4, 'Clara', 'Ventura', 'alumne', '1DAM');

INSERT INTO quest VALUES (1, 'bàsic municipis', '2021-07-05', 1, 0);
INSERT INTO quest VALUES (2, 'bàsic municipis 2', '2021-07-05', 1, 1);
INSERT INTO quest VALUES (3, 'bàsic sakila', '2021-07-05', 2, 0);
INSERT INTO quest VALUES (4, 'bàsic sakila 2', '2021-07-05', 2, 1);

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


# consultes
# donat el id_quest, llistat de les preguntes:
select id_quest_detall, bd, questio, solucio from quest_detall qd, bd_questio bdq, bd where qd.id_bd_questio=bdq.id_bd_questio and bd.id_bd=bdq.id_bd and id_quest=1;

# puntuem una pregunta
select id_quest_detall from quest_detall where id_quest=1 and num=2; # 2
insert into usuari_quest_detall values (1,3,2,1);
