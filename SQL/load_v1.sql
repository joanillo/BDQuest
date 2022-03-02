/*
bases de dades de treball
bd (id_bd, bd, num_taules)
#proposta d'exercicis sobre la base de dades de treball
bd_questio (id_bd_questio, id_bd, questio, nivell, solucio)

usuari (id_usuari, nom, cognoms, curs)
quest (id_quest, dia, id_bd)
quest_detall (id_quest_detall, id_quest, id_bd_questio, num)
nota (id_nota, id_quest, id_usuari, nota)
*/


# CREATE DATABASE bdquest CHARACTER SET utf8 COLLATE utf8_general_ci;
# use bdquest
# CREATE USER bdquest@localhost IDENTIFIED BY 'keiL2lai';
# GRANT ALL ON bdquest.* TO bdquest@localhost;
# GRANT ALL ON municipis.* TO bdquest@localhost;
# GRANT ALL ON sakila.* TO bdquest@localhost;
# flush privileges

DROP TABLE IF EXISTS bd_questio;
DROP TABLE IF EXISTS bd;
DROP TABLE IF EXISTS usuari;

CREATE TABLE bd (
id_bd smallint AUTO_INCREMENT PRIMARY KEY,
bd VARCHAR(50) NOT NULL,
num_taules smallint
);

CREATE TABLE bd_questio (
id_bd_questio smallint AUTO_INCREMENT PRIMARY KEY,
id_bd smallint references bd,
questio VARCHAR(255) NOT NULL,
nivell smallint CHECK (nivell IN (1,2,3,4,5)),
solucio text
);

CREATE TABLE usuari (
id_usuari smallint AUTO_INCREMENT PRIMARY KEY,
nom VARCHAR(255) NOT NULL,
cognoms VARCHAR(255) NOT NULL,
rol VARCHAR(30) CHECK (rol IN ('admin', 'professor', 'estudiant')),
curs VARCHAR(5) NULL
);

INSERT INTO bd VALUES (1,'municipis',3);
INSERT INTO bd VALUES (2,'sakila',23);

INSERT INTO bd_questio VALUES (1, 1, 'Llista de províncies (id i provincia), ordentat per id', 1, 'select id_prov, provincia from provincies order by id_prov;');
INSERT INTO bd_questio VALUES (2, 1, 'Els 5 primers municipis de Càceres (només el nom del municipi), per ordre alfabètic. NOTA: no has de saber quin és el id de Cáceres.', 1, 'select municipi from municipis m, provincies p where m.id_prov=p.id_prov and provincia=''Cáceres'' order by municipi limit 5;');

INSERT INTO bd_questio VALUES (3, 2, 'Llista de ciutats i països, ordenats per país i ciutat.', 2, 'select city, country from city, country where city.country_id=country.country_id order by country, city;');
INSERT INTO bd_questio VALUES (4, 2, 'En quines pel·lícules ha participat l''actor GREGORY GOODING. Ordena per títol.', 2, 'select title from film f, actor a, film_actor fa where f.film_id=fa.film_id and fa.actor_id=a.actor_id and first_name=''GREGORY'' and last_name=''GOODING'' order by title;');
