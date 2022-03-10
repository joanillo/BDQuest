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
quest (id_quest, quest, dia, random, actiu)
quest_detall (id_quest_detall, id_quest, id_bd_questio, num_pregunta)
alumne_quest (id_alumne_quest, id_usuari, id_quest, dia, nota)
alumne_quest_detall (id_alumne_quest_detall, id_alumne_quest, id_quest_detall, valor, resposta)
*/

# CREATE DATABASE bdquest CHARACTER SET utf8 COLLATE utf8_general_ci;
# use bdquest
# CREATE USER bdquest@localhost IDENTIFIED BY 'keiL2lai';
# GRANT ALL ON bdquest.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON municipis.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON sakila.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON langtrainer.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON northwind.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON empresa.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON HR.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON bikeshop.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON vestuari.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON englishresources.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON classicmodels.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON paraulogic.* TO bdquest@localhost WITH GRANT OPTION;
# GRANT ALL ON ocells.* TO bdquest@localhost WITH GRANT OPTION;
# NOTA: si vull fer CREATE USER, GRANTS i REVOKES, he de fer: (no cal per fer selects, create, inserts sobre les taules)
# GRANT ALL ON mysql.* TO bdquest@localhost;

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
random BOOLEAN,
actiu BOOLEAN,
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
dia DATETIME NOT NULL,
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
INSERT INTO bd VALUES (4,'bikeshop',1);
INSERT INTO bd VALUES (5,'classicmodels',8);
INSERT INTO bd VALUES (6,'empresa',12);
INSERT INTO bd VALUES (7,'englishresources',7);
INSERT INTO bd VALUES (8,'northwind',20);
INSERT INTO bd VALUES (9,'vestuari',7);
INSERT INTO bd VALUES (10,'HR',7);
INSERT INTO bd VALUES (11,'paraulogic',2);
INSERT INTO bd VALUES (12,'ocells',4);

INSERT INTO bd_questio VALUES (1, 10, 'seleccionar tots els empleats (utilitzar *)', 1, 0,'SELECT * FROM employees');
INSERT INTO bd_questio VALUES (2, 10, 'seleccionar el id, nom, cognom i data de contractació de tots els empleats', 1, 0,'SELECT employee_id, first_name, last_name, hire_date FROM employees');
INSERT INTO bd_questio VALUES (3, 10, 'seleccionar el id, nom, cognom i data de contractació de tots els empleats, ordenat per nom', 1, 0,'SELECT employee_id, first_name, last_name, hire_date FROM employees ORDER BY first_name');
INSERT INTO bd_questio VALUES (4, 10, 'seleccionar el id, nom, cognom, data de contractació i salari de tots els empleats, ordenat per salari, de major a menor', 1, 0,'SELECT employee_id, first_name, last_name, hire_date, salary FROM employees ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (5, 10, 'seleccionar el id, nom, cognom i data de contractació de tots els empleats, ordenat per data de contractació', 1, 0,'SELECT employee_id, first_name, last_name, hire_date FROM employees ORDER BY hire_date');
INSERT INTO bd_questio VALUES (6, 10, 'seleccionar el salari dels empleats en ordre descendent', 1, 0,'SELECT salary FROM employees ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (7, 10, 'seleccionar els diferents salaris dels empleats en ordre descendent (DISTINCT)', 1, 0,'SELECT DISTINCT salary FROM employees ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (8, 10, 'seleccionar el job_id i salari dels empleats per ordre descendent de la feina (job_id), i dins de la feina el salari de menor a major', 1, 0,'SELECT job_id, salary FROM employees ORDER BY job_id DESC, salary');
INSERT INTO bd_questio VALUES (9, 10, 'seleccionar tots els job_id i salaris diferents dels empleats per ordre descendent del job_id, i després del salari en ordre ascendent', 1, 0,'SELECT DISTINCT job_id, salary FROM employees ORDER BY job_id DESC, salary ASC');
INSERT INTO bd_questio VALUES (10, 10, 'seleccionar els diferents telèfons dels empleats', 1, 0,'SELECT DISTINCT phone_number FROM employees');
INSERT INTO bd_questio VALUES (11, 10, 'seleccionar el id, nom i cognom dels primers 5 empleats, ordenats per nom', 1, 0,'SELECT employee_id, first_name, last_name FROM employees ORDER BY first_name LIMIT 5');
INSERT INTO bd_questio VALUES (12, 10, 'seleccionar el id, nom i cognom de 5 empleats, començant pel 4rt, ordenats per nom', 1, 0,'SELECT employee_id, first_name, last_name FROM employees ORDER BY first_name LIMIT 5 OFFSET 3');
INSERT INTO bd_questio VALUES (13, 10, 'ordena els empleats per ordre descendent del salari, i selecciona el id, nom, cognom i salari dels 5 primers', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees ORDER BY salary DESC LIMIT 5');
INSERT INTO bd_questio VALUES (14, 10, 'troba el salari més alt (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees ORDER BY salary DESC LIMIT 1');
INSERT INTO bd_questio VALUES (15, 10, 'troba 2n salari més alt (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 1');

INSERT INTO bd_questio VALUES (16, 10, 'trobar les persones que cobren 17000 (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary = 17000');
INSERT INTO bd_questio VALUES (17, 10, 'trobar les persones que cobren el 2n salari més alt (id, nom, cognom, salari). S''ha de fer una subconsulta', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary = (SELECT salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET 1)');
INSERT INTO bd_questio VALUES (18, 10, 'Trobar les persones que cobren més de 14000, del salari més alt al més baix (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary > 14000 ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (19, 10, 'empleats del departament=5, ordenats per cognoms (id, nom, cognom, id del departament)', 1, 0,'SELECT employee_id, first_name, last_name, department_id FROM employees WHERE department_id = 5 ORDER BY last_name');
INSERT INTO bd_questio VALUES (20, 10, 'seleccionar l\'empleat que es diu Chen (id, nom, cognom)', 1, 0,'SELECT employee_id, first_name, last_name FROM employees WHERE last_name = \'Chen\'');
INSERT INTO bd_questio VALUES (21, 10, 'trobar els empleats que s''han contractat a partir del 1999, ordenats per antiguitat (de més antic a més nou) (id, nom, cognom, data de contractació)', 1, 0,'SELECT employee_id, first_name, last_name, hire_date FROM employees WHERE hire_date >= \'1999-01-01\' ORDER BY hire_date ASC');
INSERT INTO bd_questio VALUES (22, 10, 'trobar els empleats que s''han contractat el 1999, ordenant la data de contractació de més nou a més antic (id, nom, cognom, data de contractació)', 1, 0,'SELECT employee_id, first_name, last_name, hire_date FROM employees WHERE YEAR (hire_date) = 1999 ORDER BY hire_date DESC');
INSERT INTO bd_questio VALUES (23, 10, 'seleccionar els empleats que no tenen telèfon', 1, 0,'SELECT employee_id, first_name, last_name, phone_number FROM employees WHERE phone_number IS NULL');
INSERT INTO bd_questio VALUES (24, 10, 'seleccionar els empleats que no siguin del departament 8, ordenats per cognom i nom (id, nom, cognom, id del departament)', 1, 0,'SELECT employee_id, first_name, last_name, department_id FROM employees WHERE department_id <> 8 ORDER BY last_name, first_name');
INSERT INTO bd_questio VALUES (25, 10, 'trobar els empleats que no siguin del departament 8 ni del departament 10, ordenats per cognom i nom (id, nom, cognom, id del departament)', 1, 0,'SELECT employee_id, first_name, last_name, department_id FROM employees WHERE department_id <> 8 AND department_id <> 10 ORDER BY last_name, first_name');
INSERT INTO bd_questio VALUES (26, 10, 'trobar els empleats amb salari major que 10000, de major a menor salari (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary > 10000 ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (27, 10, 'trobar els empleats del departament 8 amb salari major que 10000, de major a menor salari (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary > 10000 AND department_id = 8 ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (28, 10, 'trobar els empleats amb salari inferior a 10000, de major a menor salari (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary < 10000 ORDER BY salary DESC');
INSERT INTO bd_questio VALUES (29, 10, 'trobar els empleats amb salari més gran que 9000, de menor a major salari (id, nom, cognom, salari)', 1, 0,'SELECT employee_id, first_name, last_name, salary FROM employees WHERE salary >= 9000 ORDER BY salary');
INSERT INTO bd_questio VALUES (30, 10, 'trobar el codi postal del departament que està a Munich', 1, 0,'SELECT postal_code FROM locations WHERE city=\'Munich\'');

INSERT INTO bd_questio VALUES (31, 3, 'paraules que comencin per \'ab\'', 1, 0,'select word from WORD where word like \'ab%\'');
INSERT INTO bd_questio VALUES (32, 3, 'paraules que continguin \'ic\'', 1, 0,'select word from WORD where word like \'%ic%\'');
INSERT INTO bd_questio VALUES (33, 3, 'paraules que cotinguin \'ic\' i que acabin per \'e\'', 1, 0,'select word from WORD where word like \'%ic%\' and word like \'%e\'');
INSERT INTO bd_questio VALUES (34, 3, 'paraules que acabin per \'ve\'', 1, 0,'select word from WORD where word like \'%ve\'');
INSERT INTO bd_questio VALUES (35, 3, 'paraules que comencin per \'a\' i acabin per \'n\'', 1, 0,'select word from WORD where word like \'a%n\'');
INSERT INTO bd_questio VALUES (36, 3, 'paraules que es van introduir el dia 22/10/2018 (id_word, paraula i dia, ordenat per dia)', 1, 0,'select id_word,word,day from WORD where day=\'2018-10-22\' order by day');
INSERT INTO bd_questio VALUES (37, 3, 'paraules que es van introduir entre el dia \'05/05/2020\' i el dia \'20/10/2020\' (id_paraula, paraula i dia), ordenats per dia i per paraula', 1, 0,'select id_word,word,day from WORD where day between \'2020-05-05\' and \'2020-10-20\' order by day, word');
INSERT INTO bd_questio VALUES (38, 3, 'paraules que es van introduir l''any 2020 (id_word, paraula i dia), ordenats per dia i per paraula', 1, 0,'select id_word,word,day from WORD where day like \'2020%\' order by day, word');
INSERT INTO bd_questio VALUES (39, 3, 'paraules que comencen per \'o\', en ordre alfabètic decreixent', 1, 0,'select word from WORD where word like \'o%\' order by word desc');
INSERT INTO bd_questio VALUES (40, 3, 'paraules de l''idioma 1 i de l''usuari 1 que contingui \'ba\'', 1, 0,'select word from WORD where word like \'%ba%\' and id_login=1 and id_language=1');
INSERT INTO bd_questio VALUES (41, 3, 'quins idiomes diferents tenim a la taula word? (id_language) (ordenat per id_language)', 1, 0,'select distinct id_language from WORD order by id_language');
INSERT INTO bd_questio VALUES (42, 3, 'quins usuaris diferents tenim a la taula word (id_login, ordenat de major a menor)', 1, 0,'select distinct id_login from WORD order by id_login desc');
INSERT INTO bd_questio VALUES (43, 3, 'quines són les paraules que contenen algun valor en camp day_learnt (id_paraula, paraula i day_learnt, ordenat per paraula)', 1, 0,'select id_word,word,day_learnt from WORD where day_learnt is not null order by word');
INSERT INTO bd_questio VALUES (44, 3, 'quants valors diferents tenim a probabilitat? (ordena els valors de major a menor)', 1, 0,'select distinct probability from WORD order by probability DESC');
INSERT INTO bd_questio VALUES (45, 3, 'paraules que no siguin de  l''usuari 1 (id_paraula, paraula, usuari), per ordre alfabètic', 1, 0,'select id_word,word,id_login from WORD where id_login<>1 order by word');
INSERT INTO bd_questio VALUES (46, 3, 'paraules diferents que no siguin de  l''usuari 1 (paraula), per ordre alfabètic', 1, 0,'select distinct word from WORD where id_login<>1 order by word');

INSERT INTO bd_questio VALUES (47, 3, 'Trobar les paraules que comencen per ''b'' dels anys 2019, 2020, 2021 (word, year) (utiilitzar IN)', 1, 0,'select word,year(day) from WORD where year(day) IN (2019,2020,2021) and word like \'b%\'');
INSERT INTO bd_questio VALUES (48, 3, 'Trobar les paraules que comencen per ''f'' i que no siguin dels anys 2019, 2020, 2021 (word, year)', 1, 0,'select word,year(day) from WORD where year(day) NOT IN (2019,2020,2021) and word like \'f%\'');
INSERT INTO bd_questio VALUES (49, 3, 'Trobar les paraules que continguin ''z'' entre els anys 2012 i 2019 (word, year)', 1, 0,'select word,year(day) from WORD where year(day) BETWEEN 2012 AND 2019 and word like \'%z%\'');
INSERT INTO bd_questio VALUES (50, 3, 'Trobar les paraules que continguin ''z'' i que no estiguin entre els anys 2012 i 2019 (word, year)', 1, 0,'select word,year(day) from WORD where year(day) NOT BETWEEN 2012 AND 2019 and word like \'%z%\'');
INSERT INTO bd_questio VALUES (51, 3, 'De les paraules del 2021, fer la suma de l''any, mes i dia, i incrementar els valors un 20%.', 1, 0,'select (year(day)+month(day)+day(day))*1.2 from WORD where day like \'2021%\'');
INSERT INTO bd_questio VALUES (52, 3, 'Amb SQL, Realitzar el càlcul 204*(36+4*(345-24))', 1, 0,'select 204*(36+4*(345-24))');
INSERT INTO bd_questio VALUES (53, 3, 'Trobar les paraules que siguin dels anys 2016 o 2018 o 2020 (utilitzar OR)', 1, 0,'select word,day from WORD where YEAR(day)=2016 or YEAR(day)=2018 or YEAR(day)=2020');
INSERT INTO bd_questio VALUES (54, 3, 'Trobar les paraules que comencin per ''a'' i que siguin dels anys 2018 o 2019', 1, 0,'select word,day from WORD where word like \'a%\' and (YEAR(day)=2018 or YEAR(day)=2019)');

INSERT INTO bd_questio VALUES (55, 10, 'Països i les seves regions, ordenat primer per regió i després per país (sense utilitzar INNER JOIN)', 1, 0,'select country_name, region_name from countries c, regions r where c.region_id=r.region_id order by region_name, country_name');
INSERT INTO bd_questio VALUES (56, 10, 'Països i les seves regions, ordenat primer per regió i després per país (utilitza INNER JOIN)', 1, 0,'select country_name, region_name from countries c INNER JOIN regions r ON c.region_id=r.region_id order by region_name, country_name');
INSERT INTO bd_questio VALUES (57, 10, 'Ciutats i els seus països, ordenat primer per país i després per ciutat', 1, 0,'select city, country_name from locations l INNER JOIN countries c ON l.country_id=c.country_id order by country_name, city');
INSERT INTO bd_questio VALUES (58, 10, 'Ciutats, països i regions ordenat primer per ciutat', 1, 0,'select city, country_name, region_name from (locations l INNER JOIN countries c ON l.country_id=c.country_id) INNER JOIN regions r ON c.region_id=r.region_id  order by city');
INSERT INTO bd_questio VALUES (59, 10, 'Ciutats d''Europa, ordenat per ciutat (sense utilitzar INNER JOIN)', 1, 0,'select city from locations l, countries c, regions r WHERE l.country_id=c.country_id and c.region_id=r.region_id and region_name=''Europe'' order by city');
INSERT INTO bd_questio VALUES (60, 10, 'Ciutats d''Europa, ordenat per ciutat (utilitzar INNER JOIN)', 1, 0,'select city from (locations l INNER JOIN countries c ON l.country_id=c.country_id) INNER JOIN regions r ON c.region_id=r.region_id  WHERE region_name=''Europe'' order by city');
INSERT INTO bd_questio VALUES (61, 10, 'Països d''Europa, ordenat per país', 1, 0,'select country_name from countries c INNER JOIN regions r ON c.region_id=r.region_id WHERE region_name=''Europe'' ORDER BY country_name');
INSERT INTO bd_questio VALUES (62, 10, 'Departaments i les seves ciutats (ordenat per departament)', 1, 0,'select department_name, city from departments d INNER JOIN locations l ON d.location_id=l.location_id ORDER BY department_name');
INSERT INTO bd_questio VALUES (63, 10, 'Departaments i les seves ciutats (ordenat per departament), i amb el format ''DEPT ***:CITY ***'' (utilitza CONCAT)', 1, 0,'select CONCAT(''DEPT '',department_name,'':CITY '', city) from departments d INNER JOIN locations l ON d.location_id=l.location_id ORDER BY department_name');
INSERT INTO bd_questio VALUES (64, 10, 'Empleats i els seus departaments (nom, cognom i departament, ordenat primer per departament i després per cognom)', 1, 0,'select first_name, last_name, department_name from employees e INNER JOIN departments d ON e.department_id=d.department_id ORDER BY d.department_name, last_name');
INSERT INTO bd_questio VALUES (65, 10, 'Empleats i les seves feines (nom, cognom i feina, ordenat primer per feina i després per cognom)', 1, 0,'select first_name, last_name, job_title from employees e INNER JOIN jobs j ON e.job_id=j.job_id ORDER BY j.job_title, last_name');
INSERT INTO bd_questio VALUES (66, 10, 'Llistat dels programadors, i departament on treballen (nom, cognom, departament, ordenat per cognom)', 1, 0,'select first_name, last_name, department_name from (employees e INNER JOIN jobs j ON e.job_id=j.job_id) INNER JOIN departments d ON e.department_id=d.department_id WHERE job_title=''Programmer'' ORDER BY last_name');
INSERT INTO bd_questio VALUES (67, 10, 'Llistat dels programadors, i ciutat on treballen (nom, cognom, ciutat, ordenat per cognom)', 1, 0,'select first_name, last_name, city from ((employees e INNER JOIN jobs j ON e.job_id=j.job_id) INNER JOIN departments d ON e.department_id=d.department_id) INNER JOIN locations l ON d.location_id=l.location_id WHERE job_title=''Programmer'' ORDER BY last_name');

INSERT INTO bd_questio VALUES (68, 1, 'Llistat de províncies i la seva comunitat (ordenat per comunitat i després per província)', 1, 0,'select provincia, comunitat from provincies p INNER JOIN comunitats c ON p.id_com=c.id_com order by comunitat, provincia');
INSERT INTO bd_questio VALUES (69, 1, 'Llistat de municipis de la província de Girona, ordenat per municipi', 1, 0,'select municipi from municipis m INNER JOIN provincies p ON m.id_prov=p.id_prov and provincia=\'Girona\' order by municipi');
INSERT INTO bd_questio VALUES (70, 1, 'Llistat de províncies d''Aragó (província, comunitat)', 1, 0,'select provincia, comunitat from provincies p INNER JOIN comunitats c ON p.id_com=c.id_com where comunitat=\'Aragón\'');
INSERT INTO bd_questio VALUES (71, 1, 'Llistat de comunitats i províncies que siguin d''una comunitat de Castella (ordenat per comunitat i després de província)', 1, 0,'select comunitat, provincia from provincies p INNER JOIN comunitats c ON p.id_com=c.id_com where comunitat like \'%Castilla%\' order by comunitat, provincia');
INSERT INTO bd_questio VALUES (72, 1, 'Listat de municipis de Catalunya que comencin per A (ordenat per municipi)', 1, 0,'select municipi from ((municipis m INNER JOIN provincies p ON m.id_prov=p.id_prov) INNER JOIN comunitats c ON p.id_com=c.id_com) where municipi like \'A%\' and comunitat=\'Catalunya\' order by municipi');
INSERT INTO bd_questio VALUES (73, 1, 'Llistat de municipis, províncies i comunitats que la província comenci per ''Al'', ordenat per província i municipi, i expressat amb el format ''municipi-província-comunitat''', 1, 0,'select CONCAT(municipi,''-'',provincia,''-'',comunitat) from ((municipis m INNER JOIN provincies p ON m.id_prov=p.id_prov) INNER JOIN comunitats c ON p.id_com=c.id_com) where provincia like ''Al%'' order by provincia, municipi');
INSERT INTO bd_questio VALUES (74, 1, 'Llistat del id de municipi, municipis, províncies i comunitats, i que el id_municipi estigui entre 2000 i 2100, ordenat per identificador', 1, 0,'select id_mun, municipi, provincia, comunitat from ((municipis m INNER JOIN provincies p ON m.id_prov=p.id_prov) INNER JOIN comunitats c ON p.id_com=c.id_com) where id_mun between 2000 and 2100 order by id_mun');

INSERT INTO bd_questio VALUES (75, 9, 'Anem a navegar des de la taula OBRA fins a la taula VESTUARI. Quin és el id de l''obra La Caputxeta Vermella 2018?', 1, 0,'SELECT id_obra FROM OBRA where obra like \'%2018%\'');
INSERT INTO bd_questio VALUES (76, 9, 'Quins són els personatges que surten en l''obra 1? (id_pers, personatge)', 1, 0,'SELECT id_pers, pers FROM PERSONATGE where id_obra=1');
INSERT INTO bd_questio VALUES (77, 9, 'Quina és la referència dels vestits que utilitza el personatge 4?', 1, 0,'SELECT ref FROM VEST_PERS where id_pers=4');
INSERT INTO bd_questio VALUES (78, 9, 'Quins vestits utilitza el personatge 4 (utilitza IN a partir dels resultats anteriors)', 1, 0,'SELECT vestuari FROM VESTUARI where ref IN (11, 12, 13, 14)');
INSERT INTO bd_questio VALUES (79, 9, 'I ara ja podem fer INNER JOINS. Llistar els personatges que surten en les obres (obra, pers, rol)', 1, 0,'SELECT obra, pers, rol FROM OBRA o INNER JOIN PERSONATGE p ON o.id_obra=p.id_obra');
INSERT INTO bd_questio VALUES (80, 9, 'Llistar tot el vestuari que surt en l''obra de la Caputxeta del 2021, ordenat per id_loc (id_loc, vestuari, pers)', 1, 0,'SELECT id_loc, vestuari, pers rol FROM OBRA o\nINNER JOIN PERSONATGE p ON o.id_obra=p.id_obra\nINNER JOIN VEST_PERS vp ON p.id_pers=vp.id_pers\nINNER JOIN VESTUARI v ON vp.ref=v.ref\nWHERE obra=''La Caputxeta Vermella 2021''\nORDER BY id_loc');
INSERT INTO bd_questio VALUES (81, 9, 'Llistar tot el vestuari que surt en l''obra de la Caputxeta del 2021, ordenat per id_loc (id_loc, vestuari, pers). Utilitzar USING.', 1, 0,'SELECT id_loc, vestuari, pers rol FROM OBRA o\nINNER JOIN PERSONATGE p USING(id_obra)\nINNER JOIN VEST_PERS USING(id_pers)\nINNER JOIN VESTUARI v USING(ref)\nWHERE obra=\'La Caputxeta Vermella 2021\'\nORDER BY id_loc');
INSERT INTO bd_questio VALUES (82, 9, 'Llistar tot el vestuari que surt en l''obra de la Caputxeta del 2021, ordenat per id_loc (id_loc, vestuari, pers). No utilitzar INNER JOIN (sintaxi implícita, prèvia a SQL-92)', 1, 0,'SELECT id_loc, vestuari, pers rol FROM OBRA o, PERSONATGE p, VEST_PERS vp, VESTUARI v\nWHERE o.id_obra=p.id_obra AND p.id_pers=vp.id_pers AND vp.ref=v.ref\nAND obra=\'La Caputxeta Vermella 2021\'\nORDER BY id_loc');
INSERT INTO bd_questio VALUES (83, 9, 'Llistar tot el vestuari que surt en l''obra de la Caputxeta del 2021, ordenat per id_loc (hab, loc, vestuari, pers)', 1, 0,'SELECT loc, hab, vestuari, pers rol FROM OBRA o\nINNER JOIN PERSONATGE p ON o.id_obra=p.id_obra\nINNER JOIN VEST_PERS vp ON p.id_pers=vp.id_pers\nINNER JOIN VESTUARI v ON vp.ref=v.ref\nINNER JOIN LOCALITZACIO l ON v.id_loc=l.id_loc\nWHERE obra=\'La Caputxeta Vermella 2021\'\nORDER BY l.id_loc');
INSERT INTO bd_questio VALUES (84, 9, 'Llistar tot el vestuari que surt en l''obra de la Caputxeta del 2021, ordenat per id_loc (hab, loc, vestuari, pers). Utilitzar USING.', 1, 0,'SELECT hab, loc, vestuari, pers rol FROM OBRA o\nINNER JOIN PERSONATGE p USING(id_obra)\nINNER JOIN VEST_PERS vp USING(id_pers)\nINNER JOIN VESTUARI v USING(ref)\nINNER JOIN LOCALITZACIO l USING(id_loc)\nWHERE obra=\'La Caputxeta Vermella 2021\'\nORDER BY l.id_loc');
INSERT INTO bd_questio VALUES (85, 9, 'Llistar tot el vestuari que surt en l''obra de la Caputxeta del 2021, ordenat per id_loc (hab, loc, vestuari, pers). No utilitzar INNER JOIN (sintaxi implícita, prèvia a SQL-92)', 1, 0,'SELECT loc, hab, vestuari, pers rol FROM OBRA o, PERSONATGE p, VEST_PERS vp, VESTUARI v, LOCALITZACIO l\nWHERE o.id_obra=p.id_obra AND p.id_pers=vp.id_pers AND vp.ref=v.ref AND v.id_loc=l.id_loc\nAND obra=\'La Caputxeta Vermella 2021\'\nORDER BY l.id_loc');
INSERT INTO bd_questio VALUES (86, 9, 'Creuar les taules CATEGORIA i AMBIENTACIO per trobar les sabates (categoria=sabates) que pertanyen a l''ambientació urbana (categoria, ambientació, vestuari, id_loc)', 1, 0,'SELECT cat, amb, vestuari, id_loc FROM CATEGORIA c\nINNER JOIN VESTUARI v ON c.id_cat=v.id_cat\nINNER JOIN AMBIENTACIO a ON v.id_amb=a.id_amb\nWHERE cat=\'sabates\' AND amb=\'urbà\'');
INSERT INTO bd_questio VALUES (87, 9, 'On són les botes catiusques roses? (hab, loc, tipus, vestuari)', 1, 0,'SELECT hab, loc, tipus, vestuari FROM VESTUARI v\nINNER JOIN LOCALITZACIO l ON v.id_loc=l.id_loc\nWHERE vestuari LIKE \'%catiusques%\'');

INSERT INTO bd_questio VALUES (88, 3, 'Paraules que comencen per w (i les seves traduccions) (id_word, paraula, traducció),\nordenat per paraula i traducció (sense utilitzar inner join, tal com es feia abans de SQL 92)', 1, 0,'select WORD.id_word, word, translation from WORD, TRANSLATION\nWHERE WORD.id_word=TRANSLATION.id_word AND word like \'w%\'\nORDER BY word, translation');
INSERT INTO bd_questio VALUES (89, 3, 'Paraules que comencen per ''y'' (i les seves traduccions) (id_word, paraula, traducció),\nordenat per paraula i traducció (amb inner join, SQL 92)', 1, 0,'SELECT WORD.id_word,word, translation from WORD\nINNER JOIN TRANSLATION\nON WORD.id_word=TRANSLATION.id_word\nWHERE word like \'y%\'');
INSERT INTO bd_questio VALUES (90, 3, 'Paraules (i la traducció) de l''usuari 1 del 2020 (id_word, paraula, traducció, dia)', 1, 0,'select w.id_word, word, translation, day from WORD w\nINNER JOIN TRANSLATION t ON w.id_word=t.id_word\nINNER JOIN LOGIN l ON w.id_login=l.id_login\nWHERE year(day)=2020 AND login=\'admin\'');
INSERT INTO bd_questio VALUES (91, 3, 'Paraules angleses (id_word, paraula, traducció) de l''usuari ''admin'' del 2020', 1, 0,'SELECT w.id_word,word, translation, day FROM WORD w\nINNER JOIN TRANSLATION t ON w.id_word=t.id_word\nINNER JOIN LOGIN l ON w.id_login=l.id_login\nINNER JOIN LANGUAGE la ON w.id_language=la.id_language\nWHERE year(day)=2020 AND login=\'admin\' AND language=\'English\'');
INSERT INTO bd_questio VALUES (92, 3, 'Paraules franceses (i que la traducció sigui catalana) de l''usuari ''admin'' (id_word, paraula, traducció)', 1, 0,'SELECT w.id_word,word, translation FROM WORD w\nINNER JOIN TRANSLATION t ON w.id_word=t.id_word\nINNER JOIN LOGIN l ON w.id_login=l.id_login\nINNER JOIN LANGUAGE la1 ON w.id_language=la1.id_language\nINNER JOIN LANGUAGE la2 ON t.id_language=la2.id_language\nWHERE login=\'admin\' AND la1.abr=\'FR\' AND la2.abr=\'CAT\'');
INSERT INTO bd_questio VALUES (93, 3, 'Acrònims (TRANSLATION.type=''a'') en llengua anglesa (i el seu significat) (id_word, paraula, traducció)', 1, 0,'SELECT WORD.id_word,word, translation FROM WORD\nINNER JOIN TRANSLATION ON WORD.id_word=TRANSLATION.id_word\nWHERE type=\'ac\'');

/* xuleta examen 15/12/2021

actor: actor_id, first_name, last_name
country: country_id, country
film: title, rental_rate, length
city: city_id, city, country_id)
staff: first_name, last_name, address_id
address: address_id, address
language: language_id, name
category: category_id, name
customer: first_name, last_name, email 

*/

INSERT INTO bd_questio VALUES (94, 2, 'Mostra el nom i cognom de tots els actors, ordenat primer per cognom i després per nom.', 1, 0,'SELECT first_name, last_name FROM actor ORDER BY last_name,first_name');
INSERT INTO bd_questio VALUES (95, 2, 'Troba el id, nom i cognom dels actors que el seu nom comenci per \'Jo\'', 1, 0,'SELECT actor_id, first_name, last_name\nFROM actor\nWHERE first_name LIKE \'Jo%\'');
INSERT INTO bd_questio VALUES (96, 2, 'Troba tots els actors (concatenació nom + espai en blanc + cognom) tals que el cognom contingui \'li\', ordenat per cognom i després per nom.', 1, 0,'SELECT CONCAT(first_name, \' \', last_name) from actor where last_name like \'%LI%\' order by last_name, first_name;');
INSERT INTO bd_questio VALUES (97, 2, 'Utilitzant IN, mostra el country_id i el país dels països Afghanistan, Bangladesh i China.', 1, 0,'SELECT country_id, country FROM country WHERE country in (\'Afghanistan\', \'Bangladesh\', \'China\')');
INSERT INTO bd_questio VALUES (98, 2, 'Troba (title, rental_rate, length) totes les pel·lícules que estiguin valorades amb més o igual que 4, i que tinguin una durada de 120 minuts o més.', 1, 0,'SELECT title, rental_rate, length FROM film WHERE rental_rate>=4 AND length>=120');
INSERT INTO bd_questio VALUES (99, 2, 'Mostra tots els actors (nom, cognom) que participen a la peli \'Alone Trip\' (no utilitzis inner join, fes servir dues subselects)', 1, 0,'SELECT first_name,last_name\nFROM actor\nWHERE actor_id IN\n(select actor_id from film_actor where film_id = \n(select film_id from film where title = \'Alone Trip\'))');
INSERT INTO bd_questio VALUES (100, 2, 'Ciutats d''Espanya, ordenat per ciutat (tots els camps) (amb subconsulta)', 1, 0,'SELECT *\nFROM city\nWHERE country_id = (SELECT country_id FROM country WHERE country = \'SPAIN\')');
INSERT INTO bd_questio VALUES (101, 2, 'Ciutats d''Espanya, ordenat per ciutat (tots els camps) (sense inner join, SQL-89)', 1, 0,'SELECT *\nFROM city c, country co\nWHERE c.country_id = co.country_id and country = \'SPAIN\'');
INSERT INTO bd_questio VALUES (102, 2, 'Ciutats d''Espanya, ordenat per ciutat (id de ciutat i ciutat) (amb inner join, SQL-92)', 1, 0,'SELECT city_id, city\nFROM city INNER JOIN country USING(country_id)\nWHERE country = \'SPAIN\'');
INSERT INTO bd_questio VALUES (103, 2, 'Llista el nom, cognom i adreça dels treballadors (staff) (amb inner join)', 1, 0,'select s.first_name, s.last_name, a.address\nfrom staff s\ninner join address a\nON a.address_id = s.address_id');
INSERT INTO bd_questio VALUES (104, 2, 'Mostra els títols de les pel·lícules que comencen per K o Q i que el seu idioma és anglès (inner join)', 1, 0,'SELECT f.title from film f\nINNER JOIN language l\nUSING (language_id)\nWHERE (f.title like \'K%\' or f.title like \'Q%\') AND l.name = \'English\'');
INSERT INTO bd_questio VALUES (105, 2, 'Troba totes les pel·lícules (títol) dins la categoria \'Family\' (inner joins)', 1, 0,'SELECT f.title\nFROM film f\nINNER JOIN film_category fc ON fc.film_id = f.film_id\nINNER JOIN category c ON c.category_id = fc.category_id\nWHERE c.name = \'Family\'');
INSERT INTO bd_questio VALUES (106, 2, 'Per tal de fer una campanya publicitària, llista els clients del Canadà (nom, cognom, mail) (inner joins)', 1, 0,'SELECT c.first_name,c.last_name, c.email\nfrom customer c\nINNER JOIN address a ON c.address_id = a.address_id\nINNER JOIN city ci ON a.city_id = ci.city_id\nINNER JOIN country co ON co.country_id = ci.country_id\nWHERE co.country = \'Canada\'');

INSERT INTO bd_questio VALUES (107, 2, 'Muestra el nombre y apellido de todos los actores, ordenando primero por apellido y luego por nombre.', 1, 0,'SELECT first_name, last_name FROM actor ORDER BY last_name,first_name');
INSERT INTO bd_questio VALUES (108, 2, 'Encuentra el id, nombre y apellido de los actores que su nombre empiece por \'Jo\'', 1, 0,'SELECT actor_id, first_name, last_name\nFROM actor\nWHERE first_name LIKE \'Jo%\'');
INSERT INTO bd_questio VALUES (109, 2, 'Encuentra todos los actores (concatenación nombre + espacio en blanco + apellido) tales que el apellido contenga \'li\', ordenado por apellido y luego por nombre.', 1, 0,'SELECT CONCAT(first_name, \' \', last_name) from actor where last_name like \'%LI%\' order by last_name, first_name;');
INSERT INTO bd_questio VALUES (110, 2, 'Utilizando IN, muestra el country_id y el país de los países Afghanistan, Bangladesh y China.', 1, 0,'SELECT country_id, country FROM country WHERE country in (\'Afghanistan\', \'Bangladesh\', \'China\')');
INSERT INTO bd_questio VALUES (111, 2, 'Encuentra todas las películas (title, rental_rate, length) que estén valoradas con más o igual que 4, y que tengan una duración de 120 minutos o más.', 1, 0,'SELECT title, rental_rate, length FROM film WHERE rental_rate>=4 AND length>=120');
INSERT INTO bd_questio VALUES (112, 2, 'Muestra todos los actores (nombre, apellido) que participan en la peli \'Alone Trip\' (no utilices inner join, utiliza dos subselects)', 1, 0,'SELECT first_name,last_name\nFROM actor\nWHERE actor_id IN\n(select actor_id from film_actor where film_id = \n(select film_id from film where title = \'Alone Trip\'))');
INSERT INTO bd_questio VALUES (113, 2, 'Ciudades de España, ordenado por ciudad (todos los campos) (con subconsulta)', 1, 0,'SELECT *\nFROM city\nWHERE country_id = (SELECT country_id FROM country WHERE country = \'SPAIN\')');
INSERT INTO bd_questio VALUES (114, 2, 'Ciudades de España, ordenado por ciudad (todos los campos) (sin inner join, SQL-89)', 1, 0,'SELECT *\nFROM city c, country co\nWHERE c.country_id = co.country_id and country = \'SPAIN\'');
INSERT INTO bd_questio VALUES (115, 2, 'Ciudades de España, ordenado por ciudad (id de ciudad y ciudad) (con inner join, SQL-92)', 1, 0,'SELECT city_id, city\nFROM city INNER JOIN country USING(country_id)\nWHERE country = \'SPAIN\'');
INSERT INTO bd_questio VALUES (116, 2, 'Lista el nombre, apellido y dirección de los trabajadores (staff) (con inner join)', 1, 0,'select s.first_name, s.last_name, a.address\nfrom staff s\ninner join address a\nON a.address_id = s.address_id');
INSERT INTO bd_questio VALUES (117, 2, 'Lista los títulos de las películas que empiezan por K o Q i que su idioma es inglés (inner join)', 1, 0,'SELECT f.title from film f\nINNER JOIN language l\nUSING (language_id)\nWHERE (f.title like \'K%\' or f.title like \'Q%\') AND l.name = \'English\'');
INSERT INTO bd_questio VALUES (118, 2, 'Encuentra todas las películas (título) de la categoria \'Family\' (inner joins)', 1, 0,'SELECT f.title\nFROM film f\nINNER JOIN film_category fc ON fc.film_id = f.film_id\nINNER JOIN category c ON c.category_id = fc.category_id\nWHERE c.name = \'Family\'');
INSERT INTO bd_questio VALUES (119, 2, 'Con tal de hacer una campaña publicitaria, lista los clientes de Canadá (nombre, apellidos, mail) (inner joins)', 1, 0,'SELECT c.first_name,c.last_name, c.email\nfrom customer c\nINNER JOIN address a ON c.address_id = a.address_id\nINNER JOIN city ci ON a.city_id = ci.city_id\nINNER JOIN country co ON co.country_id = ci.country_id\nWHERE co.country = \'Canada\'');

INSERT INTO bd_questio VALUES (120, 2, 'Cituats que acaben per \'s\' (tots els camps)', 1, 0,'SELECT * FROM city WHERE city LIKE \'%s\'');
INSERT INTO bd_questio VALUES (121, 2, 'Pel·lícules amb una durada entre 80 i 100 minuts (inclosos) (id peli, títol, ordenat per id en ordre descendent)', 1, 0,'SELECT film_id, title FROM film WHERE length >= 80 and length <= 100 ORDER BY film_id DESC');
INSERT INTO bd_questio VALUES (122, 2, 'Pel·lícules (id, títol) amb un rating (camp rating) = PG i durada de més de 120 minuts.', 1, 0,'SELECT film_id, title\nFROM film\nWHERE rating = \'PG\' AND length > 120');
INSERT INTO bd_questio VALUES (123, 2, 'Mostrar el títol de la pel·lícula i el nom dels actors (cognom, nom), ordenat per títol,cognom, nom, i limita a 100 resultats (sense inner join, SQL-89)', 1, 0,'SELECT f.title, a.last_name, a.first_name\nFROM film f, actor a, film_actor fa\nWHERE f.film_id = fa.film_id\nAND a.actor_id = fa.actor_id\nORDER BY f.title LIMIT 100');
INSERT INTO bd_questio VALUES (124, 2, 'Cognom i mail dels clients que no estan actius de la botiga 1', 1, 0,'select last_name,email from customer where active=0 and store_id=1');
INSERT INTO bd_questio VALUES (125, 2, 'Cognom i mail dels clients que no estan actius de la botiga amb el manager_staff_id=2 (subconsulta)', 1, 0,'select last_name,email from customer where active=0 and store_id=\n(select store_id from store where manager_staff_id=2)');
INSERT INTO bd_questio VALUES (126, 2, 'Llista id de botiga, ciutat i país, ordenat per store_id (inner join).', 1, 0,'SELECT s.store_id, c.city, co.country\nFROM store s\nINNER JOIN address a ON a.address_id = s.address_id\nINNER JOIN city c ON c.city_id = a.city_id\nINNER JOIN country co ON c.country_id = co.country_id\nORDER by s.store_id');
INSERT INTO bd_questio VALUES (127, 2, 'Mostar el títol de la pel·lícula i la seva categoria, ordenat per categoria i títol, limita a 100 resultats (inner join)', 1, 0,'SELECT f.title, c.name\nFROM film f\nINNER JOIN film_category ca USING (film_id)\nINNER JOIN category c USING (category_id)\nORDER BY c.name, f.title LIMIT 100');
INSERT INTO bd_questio VALUES (128, 2, 'Mostrar el cognom, país, ciutat i adreça del personal de les botigues.', 1, 0,'SELECT last_name, country, city, address\nFROM country co\nINNER JOIN city c USING (country_id)\nINNER JOIN address a USING (city_id)\nINNER JOIN staff s USING (address_id)');
INSERT INTO bd_questio VALUES (129, 2, 'Mostrar el cognom, país, ciutat i adreça dels clients de Turquia.', 1, 0,'SELECT last_name, country, city, address\nFROM country co\nINNER JOIN city c USING (country_id)\nINNER JOIN address a USING (city_id)\nINNER JOIN customer cu USING (address_id)\nWHERE country=\'Turkey\'');

# inserts, updates, deletes
INSERT INTO bd_questio VALUES (130, 1, 'Inserció del municipi ''Brocà'' a la província de Barcelona.', 1, 1, 'insert into municipis(id_mun,municipi,id_prov) values (8132,''Brocà'',8)');
INSERT INTO bd_questio VALUES (131, 1, 'Inserció del municipi ''L\'Ortiga'' a la província de Girona.', 1, 1, 'insert into municipis(id_mun,municipi,id_prov) values (8132,''L\'\'Ortiga'',17)');
INSERT INTO bd_questio VALUES (132, 1, 'Inserció de la província ''Palomares'' a Andalusia.', 1, 1, 'insert into provincies(id_prov,provincia,id_com) values (53,''Palomares'',16)');
INSERT INTO bd_questio VALUES (133, 1, 'Inserció de la comunitat ''Nueva Castilla'', amb abreviació ''NC''.', 1, 1, 'insert into comunitats(id_com,comunitat,abr_com) values (20,''Nueva Castilla'',''NC'')');
INSERT INTO bd_questio VALUES (134, 1, 'Canviar el municipi 186 a la província 25', 1, 1, 'update municipis set id_prov=25 where id_mun=186');
INSERT INTO bd_questio VALUES (135, 1, 'Canviar tots els municipis entre el 10 i el 50 (inclosos) a la província de Granada', 1, 1, 'update municipis set id_prov=18 where id_mun between 10 and 50');
INSERT INTO bd_questio VALUES (136, 1, 'Canviar el municipi ''Callosa de Segura'' a la província de València (subselect)',1,1,'update municipis set id_prov=(select id_prov from provincies where provincia=''València'') where municipi=''Callosa de Segura''');
INSERT INTO bd_questio VALUES (137, 1, 'Canviar totes les províncies de Galícia (10) a Andalusia (16)',1,1,'update provincies set id_com=16 where id_com=10');
INSERT INTO bd_questio VALUES (138, 1, 'Canviar totes les províncies de Catalunya a Andalusia (16)',1,1,'update provincies set id_com=16 where id_com=(select id_com from comunitats where comunitat=''Catalunya'')');
INSERT INTO bd_questio VALUES (139, 1, 'Esborrar els municipis de Girona que comencen per A',1,1,'delete from municipis where id_prov=(select id_prov from provincies where provincia=''Girona'') and municipi like ''A%''');
INSERT INTO bd_questio VALUES (140, 1, 'Esborrar la provincia de Lugo (pista: primer s''hauran d''esborrar els municipis de Lugo)',1,1,'delete from municipis where id_prov=(select id_prov from provincies where provincia=''Lugo'');\ndelete from provincies where provincia=''Lugo''');
INSERT INTO bd_questio VALUES (141, 1, 'Esborrar la comunitat de Islas Canarias (pista: primer s''hauran d''esborrar els municipis de Las Palmas y Tenerife; després aquestes províncies; i després la comunitat)',1,1,'delete from municipis where id_prov IN (select id_prov from provincies where provincia IN (''Santa Cruz de Tenerife'', ''Las Palmas''));\ndelete from provincies where provincia IN (''Santa Cruz de Tenerife'', ''Las Palmas'');\ndelete from comunitats where comunitat=''Islas Canarias''');
INSERT INTO bd_questio VALUES (142, 1, 'Assignar tots els municipis de Lleida (25) a Girona (17), i de Girona a Lleida (pista: crear una provincia temporal)',5,1,'insert into provincies(id_prov, provincia, id_com) values (53, ''temp'', 1);update municipis set id_prov=53 where id_prov=17;update municipis set id_prov=17 where id_prov=25;update municipis set id_prov=25 where id_prov=53;delete from provincies where id_prov=53;');

INSERT INTO bd_questio VALUES (143, 3, 'Insereix l''idioma Zulú (ZU) a la bd',1,1,'insert into LANGUAGE values(5, \'Zulú\', \'ZU\')');
# compte! perquè la pregunta 144 i 145 depèn del index que tinc a la bd, i aquesta és una bd de treball que canvia amb el temps. Si treballés amb autonumèric no hi hauria problema
INSERT INTO bd_questio VALUES (144, 3, 'Insereix l''idioma Zulú (ZU) a la bd,\ni insereix la paraula ''taula'' amb zulú (mirar Google Translate) per a l''usuari 1 (id_login), amb probabilitat 100. Per al ''dia'' faràs servir la funció ''now()''.',1,1,'insert into LANGUAGE values(5, \'Zulú\', \'ZU\');\ninsert into WORD (id_word, id_language, id_login, word, probability, day) values (1451, 5, 1, \'itafula\', 100, now())');
INSERT INTO bd_questio VALUES (145, 3, 'Insereix l''idioma Zulú (ZU) a la bd,\ni insereix la paraula ''taula'' amb zulú (mirar Google Translate) per a l''usuari 1 (id_login), amb probabilitat 100. Per al dia faràs servir la funció now().\nAra insereix la seva traducció catalana (''taula'').',1,1,'insert into LANGUAGE values(5, \'Zulú\', \'ZU\');\ninsert into WORD (id_word, id_language, id_login, word, probability, day) values (1451, 5, 1, \'itafula\', 100, now());\ninsert into TRANSLATION (id_translation, id_language, id_word, translation) VALUES (2201, 2, 1451, \'taula\')');
INSERT INTO bd_questio VALUES (146, 3, 'Elimina totes les traduccions de les paraules que contenen ''draw'' (subselect)',1,1,'delete from TRANSLATION where id_word IN\n(select id_word from WORD where word like \'%draw%\')');
INSERT INTO bd_questio VALUES (147, 3, 'Elimina les paraules que contenen ''draw'', i totes les seves traduccions (sense cascade, primer has d''eliminar les traduccions).',1,1,'delete from TRANSLATION where id_word IN (select id_word from WORD where word like \'%draw%\');\ndelete from WORD where word like \'%draw%\'');
INSERT INTO bd_questio VALUES (148, 3, 'Elimina totes les paraules amb probability=0 (la bd langtrainer funciona amb cascade, per tant no cal eliminar primer les traduccions).',1,1,'delete from WORD where probability=0');
INSERT INTO bd_questio VALUES (149, 3, 'Actualitza el camp day_learnt a dia d''avui, de tots els camps que tenen probability=0.',1,1,'update WORD set day_learnt=now() where probability=0');
INSERT INTO bd_questio VALUES (150, 3, 'Converteix a majúscules totes les paraules (word)',1,1,'update WORD set word=ucase(word)');
INSERT INTO bd_questio VALUES (151, 3, 'Converteix a majúscules totes les paraules (word) del 2018 que contenen ''s'', i converteix també a majúscules les seves traduccions.',1,1,'update TRANSLATION set translation=ucase(translation) where id_word IN (select id_word from WORD where word like \'%s%\' and year(day)=2018);\nupdate WORD set word=ucase(word) where word like \'%s%\' and year(day)=2018');
INSERT INTO bd_questio VALUES (152, 3, 'Incrementa en una unitat el camp probability per a totes les paraules del 2018 (day) i que continguin una ''s''',1,1,'update WORD set probability=probability+1 where year(day)=2018 and word like \'%s%\'');

INSERT INTO bd_questio_comprovacio VALUES (130,1,'select * from municipis where id_mun>=8132');
INSERT INTO bd_questio_comprovacio VALUES (130,2,'select count(*) from municipis');
INSERT INTO bd_questio_comprovacio VALUES (131,1,'select * from municipis where id_mun>=8132');
INSERT INTO bd_questio_comprovacio VALUES (131,2,'select count(*) from municipis');
INSERT INTO bd_questio_comprovacio VALUES (132,1,'select * from provincies where id_prov>=53');
INSERT INTO bd_questio_comprovacio VALUES (132,2,'select count(*) from provincies');
INSERT INTO bd_questio_comprovacio VALUES (133,1,'select * from comunitats where id_com>=20');
INSERT INTO bd_questio_comprovacio VALUES (133,2,'select count(*) from comunitats');
INSERT INTO bd_questio_comprovacio VALUES (134,1,'select count(*) from municipis where id_prov=3');
INSERT INTO bd_questio_comprovacio VALUES (134,2,'select count(*) from municipis where id_prov=25');
INSERT INTO bd_questio_comprovacio VALUES (135,1,'select count(*) from municipis where id_prov=18');
INSERT INTO bd_questio_comprovacio VALUES (135,2,'select * from municipis limit 50');
INSERT INTO bd_questio_comprovacio VALUES (136,1,'select count(*) from municipis where id_prov=3');
INSERT INTO bd_questio_comprovacio VALUES (136,2,'select count(*) from municipis where id_prov=46');
INSERT INTO bd_questio_comprovacio VALUES (137,1,'select count(*) from provincies where id_prov=16');
INSERT INTO bd_questio_comprovacio VALUES (137,2,'select count(*) from municipis where id_prov=10');
INSERT INTO bd_questio_comprovacio VALUES (138,1,'select count(*) from provincies where id_prov=16');
INSERT INTO bd_questio_comprovacio VALUES (138,2,'select count(*) from municipis where id_prov=1');
INSERT INTO bd_questio_comprovacio VALUES (139,1,'select count(*) from municipis where id_prov=17');
INSERT INTO bd_questio_comprovacio VALUES (139,2,'select * from municipis where municipi like ''A%'' and id_prov=17 order by id_mun');
INSERT INTO bd_questio_comprovacio VALUES (140,1,'select id_prov,count(*) as num from municipis group by id_prov');
INSERT INTO bd_questio_comprovacio VALUES (140,2,'select * from provincies');
INSERT INTO bd_questio_comprovacio VALUES (141,1,'select id_prov,count(*) as num from municipis group by id_prov');
INSERT INTO bd_questio_comprovacio VALUES (141,2,'select * from provincies');
INSERT INTO bd_questio_comprovacio VALUES (141,3,'select * from comunitats');
INSERT INTO bd_questio_comprovacio VALUES (142,1,'select id_prov, count(*) as num from provincies group by id_prov');

INSERT INTO bd_questio_comprovacio VALUES (143,1,'select * from LANGUAGE');
INSERT INTO bd_questio_comprovacio VALUES (144,1,'select id_word, id_language, id_login, word from WORD where id_word>=1447');
INSERT INTO bd_questio_comprovacio VALUES (145,1,'select id_word, id_language, id_login, word from WORD where id_word>=1447');
INSERT INTO bd_questio_comprovacio VALUES (145,2,'select id_translation, id_language, id_word, translation from TRANSLATION where id_translation>=2196');
INSERT INTO bd_questio_comprovacio VALUES (146,1,'select * from TRANSLATION where id_word IN (select id_word from WORD where word like \'%draw%\')');
INSERT INTO bd_questio_comprovacio VALUES (147,1,'select * from WORD where word like \'%draw%\'');
INSERT INTO bd_questio_comprovacio VALUES (147,2,'select * from TRANSLATION where id_word IN (select id_word from WORD where word like \'%draw%\')');
INSERT INTO bd_questio_comprovacio VALUES (148,1,'select id_word from WORD where probability=0');
INSERT INTO bd_questio_comprovacio VALUES (148,2,'select * from TRANSLATION where id_word IN (select id_word from WORD where probability=0)');
INSERT INTO bd_questio_comprovacio VALUES (149,1,'select * from WORD where probability=0');
INSERT INTO bd_questio_comprovacio VALUES (150,1,'select word from WORD limit 100');
INSERT INTO bd_questio_comprovacio VALUES (151,1,'select word, translation from WORD w inner join TRANSLATION t USING(id_word) WHERE word like \'%s%\' and year(day)=2018');
INSERT INTO bd_questio_comprovacio VALUES (152,1,'select * from WORD where word like \'%s%\'');

INSERT INTO bd_questio VALUES (153, 1, 'Crear la taula comarques amb els camps id_comarca (PK), comarca i id_prov',1,2,'CREATE TABLE comarques (\nid_comarca smallint primary key,\ncomarca varchar(255),\nid_prov smallint,\nFOREIGN KEY (id_prov) REFERENCES provincies(id_prov)\n)');

INSERT INTO bd_questio_prepost VALUES (153,1,'insert into comarques values(1,''comarca1'',5)','POST');
INSERT INTO bd_questio_prepost VALUES (153,2,'insert into comarques values(2,''comarca2'',5)','POST');
INSERT INTO bd_questio_prepost VALUES (153,3,'insert into comarques values(3,''comarca3'',5)','POST');
INSERT INTO bd_questio_prepost VALUES (153,4,'select * from comarques','POST');
INSERT INTO bd_questio_prepost VALUES (153,5,'DROP TABLE comarques','POST');

INSERT INTO bd_questio VALUES (154, 1, 'Crear la taula comarques amb els camps ref_comarca (PK), nom_comarca (unique), superficie (not null), id_prov',1,2,'CREATE TABLE comarques (\nref_comarca smallint primary key,\nnom_comarca varchar(255) unique,\nsuperficie mediumint not null,\nid_prov smallint,\nFOREIGN KEY (id_prov) REFERENCES provincies(id_prov)\n)');

INSERT INTO bd_questio_prepost VALUES (154,1,'insert into comarques(ref_comarca,nom_comarca,id_prov,superficie) values(1,''comarca1'',5,1000)','POST');
INSERT INTO bd_questio_prepost VALUES (154,2,'insert into comarques(ref_comarca,nom_comarca,id_prov,superficie) values(2,''comarca2'',5,1000)','POST');
INSERT INTO bd_questio_prepost VALUES (154,3,'insert into comarques(ref_comarca,nom_comarca,id_prov,superficie) values(3,''comarca3'',5,1000)','POST');
INSERT INTO bd_questio_prepost VALUES (154,4,'select * from comarques','POST');
INSERT INTO bd_questio_prepost VALUES (154,5,'DROP TABLE comarques','POST');

INSERT INTO bd_questio VALUES (155, 1, 'Elimina la taula comarques',1,2,'DROP TABLE comarques');

INSERT INTO bd_questio_prepost VALUES (155,1,'create table comarques (id_comarca smallint, comarca varchar(50))','PRE');
INSERT INTO bd_questio_prepost VALUES (155,2,'insert into comarques values(1,''comarca1'')','PRE');
INSERT INTO bd_questio_prepost VALUES (155,3,'insert into comarques values(2,''comarca2'')','PRE');
INSERT INTO bd_questio_prepost VALUES (155,4,'select * from comarques','PRE');

INSERT INTO bd_questio VALUES (156, 1, 'Afegir a la taula municipis el camp alcalde (varchar 50, null) al final de tot.',1,2,'ALTER TABLE municipis ADD alcalde VARCHAR(50)');

INSERT INTO bd_questio_prepost VALUES (156,1,'create table municipis (id_mun smallint, municipi varchar(50))','PRE');
INSERT INTO bd_questio_prepost VALUES (156,2,'insert into municipis(id_mun,municipi,alcalde) values(1,''mun1'',NULL)','POST');
INSERT INTO bd_questio_prepost VALUES (156,3,'insert into municipis(id_mun,municipi,alcalde) values(2,''mun2'',''alcalde1'')','POST');
INSERT INTO bd_questio_prepost VALUES (156,4,'select * from municipis','POST');
INSERT INTO bd_questio_prepost VALUES (156,5,'drop table municipis','POST');

INSERT INTO bd_questio VALUES (157, 1, 'Afegir a la taula municipis el camp alcalde (varchar 50, not null) després del camp habitants.',1,2,'ALTER TABLE municipis ADD alcalde VARCHAR(50) NOT NULL AFTER habitants');

INSERT INTO bd_questio_prepost VALUES (157,1,'create table municipis (id_mun smallint, municipi varchar(50), habitants smallint)','PRE');
INSERT INTO bd_questio_prepost VALUES (157,2,'insert into municipis(id_mun,municipi,habitants,alcalde) values(1,''mun1'',1000,''alcalde1'')','POST');
INSERT INTO bd_questio_prepost VALUES (157,3,'insert into municipis(id_mun,municipi,habitants,alcalde) values(2,''mun2'',2000,''alcalde2'')','POST');
INSERT INTO bd_questio_prepost VALUES (157,4,'select * from municipis','POST');
INSERT INTO bd_questio_prepost VALUES (157,5,'drop table municipis','POST');

INSERT INTO bd_questio VALUES (158, 1, 'Elimina el camp habitants de la taula municipis.',1,2,'ALTER TABLE municipis DROP habitants');

INSERT INTO bd_questio_prepost VALUES (158,1,'create table municipis (id_mun smallint, municipi varchar(50), habitants smallint)','PRE');
INSERT INTO bd_questio_prepost VALUES (158,2,'insert into municipis(id_mun,municipi,habitants) values(1,''mun1'',1000)','PRE');
INSERT INTO bd_questio_prepost VALUES (158,3,'insert into municipis(id_mun,municipi,habitants) values(2,''mun2'',2000)','PRE');
INSERT INTO bd_questio_prepost VALUES (158,4,'select * from municipis','POST');
INSERT INTO bd_questio_prepost VALUES (158,5,'drop table municipis','POST');

INSERT INTO bd_questio VALUES (159, 1, 'Elimina els camps habitants i superficie de la taula municipis.',1,2,'ALTER TABLE municipis DROP habitants, DROP superficie');

INSERT INTO bd_questio_prepost VALUES (159,1,'create table municipis (id_mun smallint, municipi varchar(50), habitants smallint, superficie smallint)','PRE');
INSERT INTO bd_questio_prepost VALUES (159,2,'insert into municipis(id_mun,municipi,habitants) values(1,''mun1'',1000,5000)','PRE');
INSERT INTO bd_questio_prepost VALUES (159,3,'insert into municipis(id_mun,municipi,habitants) values(2,''mun2'',2000,6000)','PRE');
INSERT INTO bd_questio_prepost VALUES (159,4,'select * from municipis','POST');
INSERT INTO bd_questio_prepost VALUES (159,5,'drop table municipis','POST');

INSERT INTO bd_questio VALUES (160, 1, 'Canvia el tipus codi_postal a CHAR(5) de la taula municipis.',1,2,'ALTER TABLE municipis MODIFY codi_postal CHAR(5)');

INSERT INTO bd_questio_prepost VALUES (160,1,'create table municipis (id_mun smallint, municipi varchar(50), codi_postal CHAR(3))','PRE');
INSERT INTO bd_questio_prepost VALUES (160,2,'insert into municipis(id_mun,municipi,codi_postal) values(1,''mun1'',''234'')','PRE');
INSERT INTO bd_questio_prepost VALUES (160,3,'insert into municipis(id_mun,municipi,codi_postal) values(2,''mun2'',''543'')','PRE');
INSERT INTO bd_questio_prepost VALUES (160,3,'insert into municipis(id_mun,municipi,codi_postal) values(3,''mun3'',''54343'')','POST');
INSERT INTO bd_questio_prepost VALUES (160,4,'select * from municipis','POST');
INSERT INTO bd_questio_prepost VALUES (160,5,'drop table municipis','POST');

INSERT INTO bd_questio VALUES (161, 1, 'Canvia el tipus codi_postal a CHAR(5) i superficie a MEDIUMINT de la taula municipis.',1,2,'ALTER TABLE municipis MODIFY codi_postal CHAR(5), MODIFY superficie MEDIUMINT');

INSERT INTO bd_questio_prepost VALUES (161,1,'create table municipis (id_mun smallint, municipi varchar(50), superficie SMALLINT, codi_postal CHAR(3))','PRE');
INSERT INTO bd_questio_prepost VALUES (161,2,'insert into municipis(id_mun,municipi,superficie,codi_postal) values(1,''mun1'',30000,''234'')','PRE');
INSERT INTO bd_questio_prepost VALUES (161,3,'insert into municipis(id_mun,municipi,superficie,codi_postal) values(2,''mun2'',20000,''543'')','PRE');
INSERT INTO bd_questio_prepost VALUES (161,3,'insert into municipis(id_mun,municipi,superficie,codi_postal) values(3,''mun3'',100000,''54343'')','POST');
INSERT INTO bd_questio_prepost VALUES (161,4,'select * from municipis','POST');
INSERT INTO bd_questio_prepost VALUES (161,5,'drop table municipis','POST');

INSERT INTO bd_questio VALUES (162, 1, 'Crea la vista num_municipis a partir de la select:\nselect provincia, count(*) num from municipis m INNER JOIN provincies p\nON m.id_prov=p.id_prov GROUP BY p.id_prov',1,2,'CREATE VIEW num_municipis AS\nselect provincia, count(*) num from municipis m INNER JOIN provincies p\nON m.id_prov=p.id_prov GROUP BY p.id_prov');

INSERT INTO bd_questio_prepost VALUES (162,1,'select * from num_municipis','POST');
INSERT INTO bd_questio_prepost VALUES (162,2,'drop view num_municipis','POST');

INSERT INTO bd_questio VALUES (163, 1, 'Elimina la vista num_municipis',1,2,'DROP VIEW num_municipis');

INSERT INTO bd_questio_prepost VALUES (163,1,'create view num_municipis as select count(*) from num_municipis','PRE');
INSERT INTO bd_questio_prepost VALUES (163,2,'select * from num_municipis','PRE');
INSERT INTO bd_questio_prepost VALUES (163,3,'select * from num_municipis','POST');

INSERT INTO bd_questio VALUES (164, 11, 'Afegir el camp definicio (varchar 255) a la taula PARAULA.',1,2,'ALTER TABLE PARAULA ADD definicio VARCHAR(255)');

INSERT INTO bd_questio_prepost VALUES (164,1,'create table PARAULA (id_paraula smallint, paraula varchar(50))','PRE');
INSERT INTO bd_questio_prepost VALUES (164,2,'insert into PARAULA values(1,''par1'')','PRE');
INSERT INTO bd_questio_prepost VALUES (164,3,'insert into PARAULA values(2,''par2'',''def2'')','POST');
INSERT INTO bd_questio_prepost VALUES (164,4,'select * from PARAULA','POST');
INSERT INTO bd_questio_prepost VALUES (164,5,'drop table PARAULA','POST');

INSERT INTO bd_questio VALUES (165, 11, 'En la taula PARAULA, afegir els camps definicio (varchar 255) i diccionari (varchar 4, 2 possibles valors: DIEC, DCVB).',1,2,'ALTER TABLE PARAULA\nADD definicio VARCHAR(255),\nADD diccionari varchar(4) CHECK((diccionari) IN(''DIEC'', ''DCVB''))');

INSERT INTO bd_questio_prepost VALUES (165,1,'create table PARAULA (id_paraula smallint, paraula varchar(50))','PRE');
INSERT INTO bd_questio_prepost VALUES (165,2,'insert into PARAULA values(1,''par1'')','PRE');
INSERT INTO bd_questio_prepost VALUES (165,3,'insert into PARAULA values(2,''par2'',''def2'',''DIEC'')','POST');
INSERT INTO bd_questio_prepost VALUES (165,4,'select * from PARAULA','POST');
INSERT INTO bd_questio_prepost VALUES (165,5,'drop table PARAULA','POST');

INSERT INTO bd_questio VALUES (166, 11, 'Eliminar el camp definicio de la taula PARAULA.',1,2,'ALTER TABLE PARAULA\nDROP definicio');

INSERT INTO bd_questio_prepost VALUES (166,1,'create table PARAULA (id_paraula smallint, paraula varchar(50), definicio varchar(10))','PRE');
INSERT INTO bd_questio_prepost VALUES (166,2,'insert into PARAULA values(1,''par1'',''def1'')','PRE');
INSERT INTO bd_questio_prepost VALUES (166,3,'insert into PARAULA values(2,''par2'',''def2'')','PRE');
INSERT INTO bd_questio_prepost VALUES (166,4,'select * from PARAULA','POST');
INSERT INTO bd_questio_prepost VALUES (166,5,'drop table PARAULA','POST');

INSERT INTO bd_questio VALUES (167, 11, 'Eliminar els camps definicio i diccionari de la taula PARAULA.',1,2,'ALTER TABLE PARAULA\nDROP definicio,\nDROP diccionari');

INSERT INTO bd_questio_prepost VALUES (167,1,'create table PARAULA (id_paraula smallint, paraula varchar(50), definicio varchar(10), diccionari varchar(10))','PRE');
INSERT INTO bd_questio_prepost VALUES (167,2,'insert into PARAULA values(1,''par1'',''def1'',''dic1'')','PRE');
INSERT INTO bd_questio_prepost VALUES (167,3,'insert into PARAULA values(2,''par2'',''def2'',''dic2'')','PRE');
INSERT INTO bd_questio_prepost VALUES (167,4,'select * from PARAULA','POST');
INSERT INTO bd_questio_prepost VALUES (167,5,'drop table PARAULA','POST');

INSERT INTO bd_questio VALUES (168, 11, 'En la taula PARAULA, afegir el camp definicio (varchar 255) després de paraula, i eliminar el camp num_cars (en una sola sentència)',1,2,'ALTER TABLE PARAULA ADD definicio VARCHAR(255) AFTER paraula, DROP num_cars');

INSERT INTO bd_questio_prepost VALUES (168,1,'create table PARAULA (id_paraula smallint, paraula varchar(50), num_cars smallint)','PRE');
INSERT INTO bd_questio_prepost VALUES (168,2,'insert into PARAULA values(1,''par1'',5)','PRE');
INSERT INTO bd_questio_prepost VALUES (168,3,'insert into PARAULA values(2,''par2'',6)','PRE');
INSERT INTO bd_questio_prepost VALUES (168,3,'insert into PARAULA values(2,''par2'',''def1'')','POST');
INSERT INTO bd_questio_prepost VALUES (168,4,'select * from PARAULA','POST');
INSERT INTO bd_questio_prepost VALUES (168,5,'drop table PARAULA','POST');

INSERT INTO bd_questio VALUES (169, 11, 'En la taula PARAULA, eliminar els camps definicio i num_cars',1,2,'ALTER TABLE PARAULA DROP definicio, DROP num_cars');

INSERT INTO bd_questio_prepost VALUES (169,1,'create table PARAULA (id_paraula smallint, paraula varchar(50), definicio varchar(10), num_cars smallint','PRE');
INSERT INTO bd_questio_prepost VALUES (169,2,'insert into PARAULA values(1,''par1'',''def1'', 5)','PRE');
INSERT INTO bd_questio_prepost VALUES (169,3,'insert into PARAULA values(2,''par2'',''def2'',6)','PRE');
INSERT INTO bd_questio_prepost VALUES (169,3,'insert into PARAULA values(2,''par2'')','POST');
INSERT INTO bd_questio_prepost VALUES (169,4,'select * from PARAULA','POST');
INSERT INTO bd_questio_prepost VALUES (169,5,'drop table PARAULA','POST');

INSERT INTO bd_questio VALUES (170, 11, 'Crear la taula DEFINICIO amb els camps id_definicio smallint PK, definicio varchar 255, i el camp id_paraula mediumint com a clau forània que faci referència a PARAULA.id_paraula',1,2,'CREATE TABLE DEFINICIO (\nid_definicio SMALLINT PRIMARY KEY,\ndefinicio VARCHAR(255),\nid_paraula MEDIUMINT NOT NULL,\nFOREIGN KEY (id_paraula) REFERENCES PARAULA(id_paraula)\n)');

INSERT INTO bd_questio_prepost VALUES (170,1,'insert into DEFINICIO values(1,''def1'',1)','POST');
INSERT INTO bd_questio_prepost VALUES (170,2,'insert into DEFINICIO values(1,''def2'',1)','POST');
INSERT INTO bd_questio_prepost VALUES (170,3,'insert into DEFINICIO values(1,''def3'',2)','POST');
INSERT INTO bd_questio_prepost VALUES (170,4,'select * from DEFINICIO','POST');
INSERT INTO bd_questio_prepost VALUES (170,5,'drop table DEFINICIO','POST');

INSERT INTO bd_questio VALUES (171, 11, 'Eliminar la taula DEFINICIO.',1,2,'DROP TABLE DEFINICIO');

INSERT INTO bd_questio_prepost VALUES (171,1,'create table DEFINICIO (id_definicio smallint, definicio varchar(50)','PRE');
INSERT INTO bd_questio_prepost VALUES (171,2,'insert into DEFINICIO values(1,''def1'')','PRE');
INSERT INTO bd_questio_prepost VALUES (171,3,'insert into DEFINICIO values(1,''def2'')','PRE');
INSERT INTO bd_questio_prepost VALUES (171,4,'select * from DEFINICIO','PRE');

INSERT INTO bd_questio VALUES (172, 11, 'De la taula DEFINICIO modificar el camp id_definicio a mediumint, el camp definicio a varchar 255, i el camp id_paraula a mediumint not null.',1,2,'ALTER TABLE DEFINICIO\nMODIFY id_definicio MEDIUMINT,\nMODIFY definicio VARCHAR(255),\nMODIFY id_paraula MEDIUMINT NOT NULL');

INSERT INTO bd_questio_prepost VALUES (172,1,'create table DEFINICIO (id_definicio smallint, definicio CHAR(4), id_paraula smallint)','PRE');
INSERT INTO bd_questio_prepost VALUES (172,2,'insert into DEFINICIO values(1,''def1'',1)','PRE');
INSERT INTO bd_questio_prepost VALUES (172,3,'insert into DEFINICIO values(2,''def2'',2)','PRE');
INSERT INTO bd_questio_prepost VALUES (172,4,'insert into DEFINICIO values(3,''definicio3'',2)','POST');
INSERT INTO bd_questio_prepost VALUES (172,5,'select * from DEFINICIO','POST');
INSERT INTO bd_questio_prepost VALUES (172,6,'drop table DEFINICIO','POST');

INSERT INTO bd_questio VALUES (173, 11, 'Crea la vista informe, que retorni les paraules amb els seus dies, ordenat per paraula.',1,2,'CREATE VIEW informe AS\nSELECT paraula, dia FROM JOC J INNER JOIN PARAULA P\nON J.id_joc=P.id_joc\nORDER BY paraula');

INSERT INTO bd_questio_prepost VALUES (173,1,'select * from informe limit 300','POST');
INSERT INTO bd_questio_prepost VALUES (173,2,'drop view informe','POST');

INSERT INTO bd_questio VALUES (174, 11, 'Elimina la vista informe',1,2,'DROP VIEW informe');

INSERT INTO bd_questio_prepost VALUES (174,1,'CREATE VIEW informe AS\nSELECT paraula, dia FROM JOC J INNER JOIN PARAULA P\nON J.id_joc=P.id_joc\nORDER BY paraula','PRE');
INSERT INTO bd_questio_prepost VALUES (174,2,'select * from informe limit 10','PRE');
INSERT INTO bd_questio_prepost VALUES (174,3,'select * from informe limit 10','POST');

INSERT INTO bd_questio VALUES (175, 10, 'Quants empleats hi ha en total?', 1, 0,'SELECT COUNT(*) as total from employees');
INSERT INTO bd_questio VALUES (176, 10, 'Quants empleats hi ha a cada departament (id, total)', 1, 0,'SELECT department_id, COUNT(department_id) as total\nFROM employees\nGROUP BY department_id');
INSERT INTO bd_questio VALUES (177, 10, 'Quants empleats hi ha a cada departament (nom del departament, total)', 1, 0,'SELECT department_name, COUNT(d.department_id) as total\nFROM employees e INNER JOIN departments d USING(department_id)\nGROUP BY d.department_id');
INSERT INTO bd_questio VALUES (178, 10, 'De cada departament (id), quin és el salari mig, màxim i mínim (per al salari mig arrodoneix a dos decimals)', 1, 0,'SELECT department_id, ROUND(AVG(salary),2) avg, MAX(salary) max, MIN(salary) min\nFROM employees\nGROUP BY department_id');
INSERT INTO bd_questio VALUES (179, 10, 'De cada departament (nom del departament), quin és el salari mig, màxim i mínim (per al salari mig arrodoneix a dos decimals)', 1, 0,'SELECT department_name, ROUND(AVG(salary),2) avg, MAX(salary) max, MIN(salary) min\nFROM employees e INNER JOIN departments d USING(department_id)\nGROUP BY d.department_id');
INSERT INTO bd_questio VALUES (180, 10, 'Quin és el salari mig dels departaments per als departaments que tenen un salari mig < 5000 (de menor a major, camps id i avg, 2 decimals)', 1, 0,'SELECT department_id, ROUND(AVG(salary),2) as avg\nFROM employees\nGROUP BY department_id\nHAVING avg < 5000\nORDER BY avg');
INSERT INTO bd_questio VALUES (181, 10, 'Troba els 5 job_id amb un salari mig més alt (ordenat per salari de major a menor. job_id, avg sense decimals).', 1, 0,'SELECT job_id, ROUND(AVG(salary),0) avg\nFROM employees\nGROUP BY job_id\nORDER BY avg (salary) DESC\nLIMIT 5');
INSERT INTO bd_questio VALUES (182, 10, 'Troba el job (nom del job) amb un salari mig més petit (nom del job, avg sense decimals).', 1, 0,'SELECT job_title, ROUND(AVG(salary),0) avg\nFROM employees e INNER JOIN jobs j USING (job_id)\nGROUP BY job_title\nORDER BY avg (salary) ASC\nLIMIT 1');
INSERT INTO bd_questio VALUES (183, 10, 'Quantes seus té cada país? (id del país, num_seus)', 1, 0,'SELECT country_id, COUNT(*) num_seus FROM locations GROUP BY country_id');
INSERT INTO bd_questio VALUES (184, 10, 'Quants països té cada regió? (id de la regió, num_paisos)', 1, 0,'SELECT region_id, COUNT(*) num_paisos FROM countries GROUP BY region_id');
INSERT INTO bd_questio VALUES (185, 10, 'Quants països té cada regió? (nom de la regió, num_paisos)', 1, 0,'SELECT region_name, COUNT(*) num_paisos FROM countries c\nINNER JOIN regions r USING (region_id)\nGROUP BY region_id');
INSERT INTO bd_questio VALUES (186, 10, 'Llista les ciutats i la seva regió (nom de la ciutat, nom de la regió)', 1, 0,'SELECT city, region_name FROM locations l\nINNER JOIN countries c USING (country_id)\nINNER JOIN regions r USING (region_id)');
INSERT INTO bd_questio VALUES (187, 10, 'Quantes seus té cada regió? (nom de la regió, num_seus)', 1, 0,'SELECT region_name, count(city) num_seus FROM locations l\nINNER JOIN countries c USING (country_id)\nINNER JOIN regions r USING (region_id)\nGROUP BY region_name;');
INSERT INTO bd_questio VALUES (188, 10, 'Llista els mànagers (manager_id) i els seus subordinats (employee_id)', 1, 0,'select manager_id, employee_id FROM employees order by manager_id');
INSERT INTO bd_questio VALUES (189, 10, 'Quants subordinats té cada mànager (manager_id, total)', 1, 0,'select manager_id, count(employee_id) total FROM employees\nGROUP BY manager_id\norder by manager_id');
INSERT INTO bd_questio VALUES (190, 10, 'Quants dependents té cada empleat (id empleat, total)', 1, 0,'SELECT employee_id, count(*) total\nFROM dependents\nGROUP BY employee_id');
INSERT INTO bd_questio VALUES (191, 10, 'Nom dels empleats i total de dependents (nom, cognom, total)', 1, 0,'SELECT e.first_name,e.last_name, count(*) total\nFROM employees e INNER JOIN dependents d USING(employee_id)\nGROUP BY e.employee_id, e.first_name,e.last_name');

INSERT INTO bd_questio VALUES (192, 9, 'Quantes peces de vestuari tinc de cada categoria (id_cat)?', 1, 0,'SELECT id_cat,count(*) total FROM VESTUARI GROUP BY id_cat');
INSERT INTO bd_questio VALUES (193, 9, 'Quantes peces de vestuari tinc de cada categoria (nom categoria)?', 1, 0,'SELECT cat,count(*) total FROM VESTUARI V\nINNER JOIN CATEGORIA C USING(id_cat)\nGROUP BY cat');
INSERT INTO bd_questio VALUES (194, 9, 'Quantes peces de vestuari tinc de cada categoria (nom categoria) i que s\'han fet servir en alguna obra?', 1, 0,'SELECT cat,count(*) total FROM VESTUARI V\nINNER JOIN CATEGORIA C USING(id_cat)\nINNER JOIN VEST_PERS VP USING(ref)\nGROUP BY cat');
INSERT INTO bd_questio VALUES (195, 9, 'Quantes peces de roba no estan en cap categoria?', 1, 0,'SELECT COUNT(*) total FROM VESTUARI WHERE id_cat IS NULL');
INSERT INTO bd_questio VALUES (196, 9, 'Quantes peces de vestuari tinc de cada ambientacio (id_amb)?', 1, 0,'SELECT id_amb,count(*) total FROM VESTUARI GROUP BY id_amb');
INSERT INTO bd_questio VALUES (197, 9, 'Quantes peces de vestuari tinc de cada ambientació (nom ambientació)?', 1, 0,'SELECT amb,count(*) total FROM VESTUARI V\nINNER JOIN AMBIENTACIO A ON V.id_amb=A.id_amb\nGROUP BY amb');
INSERT INTO bd_questio VALUES (198, 9, 'Relació de personatges (nom del personatge) i número de peces de vestuari que porten?', 1, 0,'SELECT pers, COUNT(*) total FROM PERSONATGE\nINNER JOIN VEST_PERS USING (id_pers)\nGROUP BY pers');
INSERT INTO bd_questio VALUES (199, 9, 'Quin és el personatge (i obra en què participa) que té més vestuari (personatge, obra, total)?', 1, 0,'SELECT pers, obra, COUNT(*) total FROM PERSONATGE\nINNER JOIN VEST_PERS USING (id_pers)\nINNER JOIN OBRA USING (id_obra)\nGROUP BY pers, obra\nORDER BY total DESC\nLIMIT 1');
INSERT INTO bd_questio VALUES (200, 9, 'Dels personatges caçadors, digues el número de peces de vestuari i obra en què participen (personatge, obra, total)?', 1, 0,'SELECT pers, obra, COUNT(*) total FROM PERSONATGE\nINNER JOIN VEST_PERS USING (id_pers)\nINNER JOIN OBRA USING (id_obra)\nGROUP BY pers, obra\nHAVING pers=\'caçador\'');
INSERT INTO bd_questio VALUES (201, 9, 'Quants personatges participen a cada obra (obra, num_personatges)?', 1, 0,'SELECT obra, count(*) num_personatges FROM OBRA O\nINNER JOIN PERSONATGE P USING(id_obra)\nGROUP BY obra');
INSERT INTO bd_questio VALUES (202, 9, 'Quantes peces de vestuari es necessita a cada obra (obra, total)?', 1, 0,'select obra, count(*) total from OBRA O\nINNER JOIN PERSONATGE P USING(id_obra)\nINNER JOIN VEST_PERS USING(id_pers)\nGROUP BY obra');
INSERT INTO bd_questio VALUES (203, 9, 'Quines són les 3 obres que utilitzen menys peces de vestuari (obra, total)?', 1, 0,'select obra, count(*) total from OBRA O\nINNER JOIN PERSONATGE P USING(id_obra)\nINNER JOIN VEST_PERS USING(id_pers)\nGROUP BY obra\nORDER BY total asc LIMIT 3');
INSERT INTO bd_questio VALUES (204, 9, 'Quina és la localització que conté més peces de vestuari (loc, total)?', 1, 0,'select loc, count(*) total FROM VESTUARI V\nINNER JOIN LOCALITZACIO L USING(id_loc)\nGROUP BY loc\nORDER BY total DESC LIMIT 1');
INSERT INTO bd_questio VALUES (205, 9, 'Relació de la localització (loc) (i habitació en la que està) i el número de peces de vestuari que conté.', 1, 0,'select loc, hab, count(*) total FROM VESTUARI V\nINNER JOIN LOCALITZACIO L USING(id_loc)\nGROUP BY loc, hab');
INSERT INTO bd_questio VALUES (206, 9, 'Quines són les localitzacions que tenen més de 15 peces de vestuari?', 1, 0,'select loc, count(*) total FROM VESTUARI V INNER JOIN LOCALITZACIO L USING(id_loc)\nGROUP BY loc\nHAVING total>15');
INSERT INTO bd_questio VALUES (207, 9, 'Relació de localització (loc), CATEGORIA (nom de la categoria) i peces de vestuari que contenen (total)?', 1, 0,'select loc,cat,count(*) total from VESTUARI V INNER JOIN LOCALITZACIO L\nUSING(id_loc)\nINNER JOIN CATEGORIA C USING (id_cat)\nGROUP BY loc,cat\norder by loc,cat');
INSERT INTO bd_questio VALUES (208, 9, 'Relació d\'anys i número d\'obres representades cada any.', 1, 0,'select year, count(*) num FROM OBRA GROUP BY year');

INSERT INTO bd_questio VALUES (209, 10, 'Llista, ordenada per cognom, de tots els noms i cognoms tant d''empleats com dels dependents (union)', 1, 0,'SELECT first_name, last_name FROM employees\nUNION\nSELECT first_name, last_name FROM dependents\nORDER BY last_name');
INSERT INTO bd_questio VALUES (210, 2, 'Llista, ordenada per cognom i nom, de tots els noms i cognoms tant de staff com dels actors (union).', 1, 0,'SELECT first_name, last_name FROM staff\nunion\nSELECT first_name, last_name FROM actor\norder by last_name, first_name');
INSERT INTO bd_questio VALUES (211, 2, 'Països que surten tant a customer_list com a staff_list (union).', 1, 0,'SELECT country FROM customer_list\nunion\nSELECT country FROM staff_list');
INSERT INTO bd_questio VALUES (212, 2, 'Països diferents que surten tant a customer_list com a stall_list. Implementar el INTERSECT sense fer el INTERSECT. Es fa amb un inner join (resultat Canadà)', 1, 0,'SELECT distinct cl.country FROM customer_list cl\ninner join staff_list sl\nON cl.country=sl.country');
INSERT INTO bd_questio VALUES (213, 2, 'Països diferents de customer_list, i que no apareixen a staff_list. Implementar el MINUS sense fer el MINUS (Canadà no apareix)', 1, 0,'SELECT distinct country FROM customer_list\nWHERE country NOT IN (SELECT country FROM staff_list)');

INSERT INTO bd_questio VALUES (214, 9, 'Llista de vestuari encara que no tingui ambientació (ref, vestuari, id_amb, amb).', 1, 0,'SELECT ref,vestuari, id_amb, amb FROM VESTUARI V\nLEFT JOIN AMBIENTACIO A\nUSING (id_amb)');
INSERT INTO bd_questio VALUES (215, 9, 'Llista de vestuari que no té ambientació (ref, vestuari)', 1, 0,'SELECT ref,vestuari FROM VESTUARI V\nLEFT JOIN AMBIENTACIO A\nUSING (id_amb)\nWHERE A.id_amb IS NULL');
INSERT INTO bd_questio VALUES (216, 9, 'Llista de vestuari que no té ambientació, i la seva localització (ref, vestuari, loc).', 1, 0,'SELECT ref,vestuari, loc FROM VESTUARI V\nLEFT JOIN AMBIENTACIO A\nUSING (id_amb)\nINNER JOIN LOCALITZACIO L\nUSING (id_loc)\nWHERE A.id_amb IS NULL');
INSERT INTO bd_questio VALUES (217, 9, 'Llista de les ambientacions que no tenen associat cap vestuari (ref,vestuari, id_amb, amb).', 1, 0,'SELECT ref,vestuari, id_amb, amb FROM VESTUARI V\nRIGHT JOIN AMBIENTACIO A\nUSING (id_amb)\nWHERE ref IS NULL');
INSERT INTO bd_questio VALUES (218, 9, 'Llista de vestuari encara que no tingui categoria (ref, vestuari, id_cat, cat).', 1, 0,'SELECT ref,vestuari, id_cat, cat FROM VESTUARI V\nLEFT JOIN CATEGORIA C\nUSING (id_cat)');
INSERT INTO bd_questio VALUES (219, 9, 'Llista de vestuari que no tingui categoria (ref, vestuari).', 1, 0,'SELECT ref,vestuari FROM VESTUARI V\nLEFT JOIN CATEGORIA C\nUSING (id_cat)\nWHERE C.id_cat IS NULL');
INSERT INTO bd_questio VALUES (220, 9, 'Llista de vestuari que no tingui categoria, i la seva localització (ref, vestuari, loc).', 1, 0,'SELECT ref,vestuari, loc FROM VESTUARI V\nLEFT JOIN CATEGORIA C\nUSING (id_cat)\nINNER JOIN LOCALITZACIO L\nUSING (id_loc)\nWHERE C.id_cat IS NULL');
INSERT INTO bd_questio VALUES (221, 9, 'Llista de les categoriaes que no tenen associat cap vestuari (ref,vestuari, id_cat, cat).', 1, 0,'SELECT ref,vestuari, id_cat, cat FROM VESTUARI V\nRIGHT JOIN CATEGORIA C\nUSING (id_cat)\nWHERE ref IS NULL');
INSERT INTO bd_questio VALUES (222, 9, 'Personatges que no estan en cap obra (id_pers, pers, id_obra, obra).', 1, 0,'SELECT id_pers, pers, id_obra, obra FROM PERSONATGE P\nLEFT JOIN OBRA O\nUSING(id_obra)\nWHERE id_obra IS NULL');
INSERT INTO bd_questio VALUES (223, 9, 'Obres que no tenen cap personatge (id_obra, obra, id_pers, pers) (d''aquesta manera detectem els errors).', 1, 0,'SELECT id_obra, obra, id_pers, pers FROM OBRA O\nLEFT JOIN PERSONATGE P\nUSING(id_obra)\nWHERE id_pers IS NULL');
INSERT INTO bd_questio VALUES (224, 9, 'Personatges que no tenen vestuari (id_pers, pers, ref).', 1, 0,'SELECT id_pers, pers, ref FROM PERSONATGE P\nLEFT JOIN VEST_PERS VP\nUSING (id_pers)\nWHERE ref IS NULL');
INSERT INTO bd_questio VALUES (225, 9, 'Vestuaris que no tenen personatge (ref, vestuari, id_pers).', 1, 0,'SELECT ref, vestuari, id_pers FROM VESTUARI V\nLEFT JOIN VEST_PERS VP\nUSING (ref)\nWHERE id_pers IS NULL');
INSERT INTO bd_questio VALUES (226, 9, 'Llista de personatges i vestuaris, encara que els personatges no tinguin vestuari, i encara que els vestuaris no tinguin personatge (id_pers, pers, ref, vestuari).', 1, 0,'SELECT id_pers, pers, ref, vestuari FROM PERSONATGE P\nLEFT JOIN VEST_PERS VP\nUSING (id_pers)\nLEFT JOIN VESTUARI V\nUSING (ref)\nUNION\nSELECT id_pers, pers, ref, vestuari FROM VESTUARI V\nLEFT JOIN VEST_PERS VP\nUSING (ref)\nLEFT JOIN PERSONATGE P\nUSING (id_pers)');
INSERT INTO bd_questio VALUES (227, 9, 'Llista de personatges i vestuaris, que els personatges no tinguin vestuari, o bé que els vestuaris no tinguin personatge (id_pers, pers, ref, vestuari).', 1, 0,'SELECT id_pers, pers, ref, vestuari FROM PERSONATGE P\nLEFT JOIN VEST_PERS VP\nUSING (id_pers)\nLEFT JOIN VESTUARI V\nUSING (ref)\nWHERE ref IS NULL\nUNION\nSELECT id_pers, pers, ref, vestuari FROM VESTUARI V\nLEFT JOIN VEST_PERS VP\nUSING (ref)\nLEFT JOIN PERSONATGE P\nUSING (id_pers)\nWHERE id_pers IS NULL');

INSERT INTO bd_questio VALUES (228, 12, 'Llistar els biòlegs (nom, cognom) que participen en el projecte, per ordre alfabètic del cognom.', 1, 0,'select nom,cognom from BIOLEG order by cognom');
INSERT INTO bd_questio VALUES (229, 12, 'Llistar els ocells presents en el Delta del Llobregat (nom comú, i nom científic). Ordenat per nom científic.', 1, 0,'select nom_comu, nom_cientific from OCELL order by nom_cientific');
INSERT INTO bd_questio VALUES (230, 12, 'Llistar tots els ocells que són ànecs (id i nom comú, ordenat pel nom)', 1, 0,'select id_ocell, nom_comu from OCELL where nom_comu like ''%anec%'' order by nom_comu');
INSERT INTO bd_questio VALUES (231, 12, 'Llistar tots els biòlegs que el seu nom comenci per ''P'' (id, nom, cognom, ordenat primer per cognom i després per nom)', 1, 0,'select id_bioleg, nom, cognom from BIOLEG where nom like ''P%'' order by cognom, nom');
INSERT INTO bd_questio VALUES (232, 12, 'Llistar tots els biòlegs que són responsables d''un mirador (id, cognom), ordenat per cognom', 1, 0,'select id_bioleg, cognom from BIOLEG where id_mirador is not null order by cognom');
INSERT INTO bd_questio VALUES (233, 12, 'Llistar tots els biòlegs que no són responsables d''un mirador (id, nom), ordenat per nom en ordre descendent.', 1, 0,'select id_bioleg, nom from BIOLEG where id_mirador is null order by nom DESC');
INSERT INTO bd_questio VALUES (234, 12, 'Llistar les inicials dels biòlegs (per ex, PC, MP), ordenat per nom i per cognom.', 1, 0,'select concat(left(nom,1),left(cognom,1)) as inicials from BIOLEG order by nom,cognom');
INSERT INTO bd_questio VALUES (235, 12, 'Llistar el gènere i l''espècie dels ocells de forma separada (per ex, Cygnus i olor separats). (ajuda: https://sebhastian.com/mysql-split-string/)', 1, 0,'select SUBSTRING_INDEX(nom_cientific,'' '',1) as genere, SUBSTRING_INDEX(nom_cientific,' ',-1) as especie from OCELL');
INSERT INTO bd_questio VALUES (236, 12, 'Quins valors tenim en el camp abundància de la taula OCELL? (valors diferents)', 1, 0,'select distinct abundancia from OCELL');
INSERT INTO bd_questio VALUES (237, 12, 'Quins dies es van fer l''avistament d''ocells (yyyy-mm-dd)? (ordenat per yyyy-mm-dd, 2 valors)', 1, 0,'select distinct DATE(dia_hora) FROM AVISTAMENT');
INSERT INTO bd_questio VALUES (238, 12, 'Quin és el valor màxim del id d''avistament?', 1, 0,'select max(id_avistament) from AVISTAMENT');
INSERT INTO bd_questio VALUES (239, 12, 'Quin és el valor màxim del id d''ocell?', 1, 0,'select max(id_ocell) from OCELL');
INSERT INTO bd_questio VALUES (240, 12, 'Quin és el valor mig de la longitud del nom dels miradors?', 1, 0,'select AVG(LENGTH(mirador)) as avg_mirador from MIRADOR');
INSERT INTO bd_questio VALUES (241, 12, 'Quin és el valor mig de la longitud del cognom dels biòlegs?', 1, 0,'select AVG(LENGTH(cognom)) as avg_cognom from BIOLEG');
INSERT INTO bd_questio VALUES (242, 12, 'Quants avistaments ha fet el biòleg id=5?', 1, 0,'select count(*) from AVISTAMENT WHERE id_bioleg=5');
INSERT INTO bd_questio VALUES (243, 12, 'Quants avistaments s''han fet el dia 5 de març?', 1, 0,'select count(*) from AVISTAMENT WHERE DATE(dia_hora)=''2022-03-05''');
INSERT INTO bd_questio VALUES (244, 12, 'Llista els 10 primers resultats d''ocells, ordenant-los per nom comú en ordre descendent (id, nom comú)', 1, 0,'select id_ocell, nom_comu from OCELL order by nom_comu DESC LIMIT 10');
INSERT INTO bd_questio VALUES (245, 12, 'Llista els 5 primers valors dels avistaments més matiners del diumenge 6 de març (tots els camps, ordenat per datetime)', 1, 0,'select * from AVISTAMENT WHERE DATE(dia_hora)=''22-03-06'' order by dia_hora asc limit 5');
INSERT INTO bd_questio VALUES (246, 12, 'Llista els ocells que el seu nom comú conté una ''x'' i amb més de 10 lletres.', 1, 0,'select * from OCELL where nom_comu like ''%x%'' and LENGTH(nom_comu)>10');
INSERT INTO bd_questio VALUES (247, 12, 'Llista els ocells que el seu nom científic conté ''y'' i amb més de 15 lletres.', 1, 0,'select * from OCELL where nom_cientific like ''%y%'' and LENGTH(nom_cientific)>15');
INSERT INTO bd_questio VALUES (248, 12, 'Fer la llista d''ocells, juntament amb la longitud del seu nom comú (nom comú i número de caràcters, ordenat de menor a major).', 1, 0,'select nom_comu, LENGTH(nom_comu) as num FROM OCELL order by num');
INSERT INTO bd_questio VALUES (249, 12, 'Fer la llista de miradors, juntament amb la longitud del nom del mirador (nom del mirador i número de caràcters, ordenat de menor a major).', 1, 0,'select mirador, LENGTH(mirador) as num FROM MIRADOR order by num');
INSERT INTO bd_questio VALUES (250, 12, 'Quins són els biòlegs (nom, cognom) que són responsables d''un mirador que comença per Aguait? (subconsulta)', 1, 0,'select nom, cognom from BIOLEG where id_mirador IN (select id_mirador from MIRADOR WHERE mirador like ''Aguait%'')');
INSERT INTO bd_questio VALUES (251, 12, 'Quins són els miradors que tenen responsable? Ordenat per mirador. (subconsulta)', 1, 0,'select * from MIRADOR where id_mirador IN (select id_mirador from BIOLEG) ORDER BY mirador');
INSERT INTO bd_questio VALUES (252, 12, 'Llistat dels miradors i el seu responsable (només els que tenen responsable). Nom del mirador i cognom, ordenat per mirador.', 1, 0,'select mirador, cognom from MIRADOR M\nINNER JOIN BIOLEG B ON M.id_mirador=B.id_mirador\nORDER BY mirador');
INSERT INTO bd_questio VALUES (253, 12, 'Llistat dels miradors i el seu responsable (només els que tenen responsable). Nom del mirador i cognom, ordenat per mirador.', 1, 0,'select mirador, cognom from MIRADOR M\nINNER JOIN BIOLEG B ON M.id_mirador=B.id_mirador\nORDER BY mirador');
INSERT INTO bd_questio VALUES (254, 12, 'Llistar tots els ocells que ha avistat el biòleg id=3 (id_ocell, nom comú, valor únic).', 1, 0,'select id_ocell, nom_comu from OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nWHERE id_bioleg=3');
INSERT INTO bd_questio VALUES (255, 12, 'Llistar tots els miradors on ha estat observant el biòleg id=4 (id_mirador, mirador, valor únic).', 1, 0,'select distinct id_mirador, mirador from MIRADOR M\nINNER JOIN AVISTAMENT A USING(id_mirador)\nWHERE id_bioleg=4');
INSERT INTO bd_questio VALUES (256, 12, 'Llistar tots els ocells que ha avistat el biòleg Jordi Casademunt (id_ocell, nom comú, dia_hora).', 1, 0,'select id_ocell, nom_comu, dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING (id_ocell)\nINNER JOIN BIOLEG B USING (id_bioleg)\nWHERE nom=''Jordi'' AND cognom=''Casademunt''');
INSERT INTO bd_questio VALUES (257, 12, 'Llistar tots els ocells que s''han avistat des del Mirador de Cal Beitas (id_ocell, nom comú, dia_hora).', 1, 0,'select id_ocell, nom_comu, dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING (id_ocell)\nINNER JOIN MIRADOR M USING (id_mirador)\nWHERE mirador=''Mirador de Cal Beitas''');
INSERT INTO bd_questio VALUES (258, 12, 'Quin biòleg ha fet l''avistament més matiner del 5 de març? (nom, cognom, dia_hora)', 1, 0,'select nom,cognom,dia_hora FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nORDER BY dia_hora ASC LIMIT 1');
INSERT INTO bd_questio VALUES (259, 12, 'Quin ocell es va veure primer el dia 5 de març? (nom comú, dia_hora)', 1, 0,'select nom_comu,dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nORDER BY dia_hora ASC LIMIT 1');
INSERT INTO bd_questio VALUES (260, 12, 'Quin ocell es va veure últim el dia 6 de març? (nom comú, dia_hora)', 1, 0,'select nom_comu,dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nORDER BY dia_hora DESC LIMIT 1');
INSERT INTO bd_questio VALUES (261, 12, 'Quin biòleg va fer l''últim avistament el dia 6 de març? (nom, cognom, dia_hora)', 1, 0,'select nom,cognom,dia_hora FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nORDER BY dia_hora DESC LIMIT 1');

INSERT INTO bd_questio VALUES (262, 12, 'Fer el llistat d''ocells vistos, biòlegs, miradors i dia_hora, ordenats per línia temporal (nom comú, cognom, nom del mirador, dia_hora)', 1, 0,'select nom_comu,cognom,mirador,dia_hora from OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN BIOLEG B USING(id_bioleg)\nINNER JOIN MIRADOR M ON A.id_mirador=M.id_mirador\nORDER BY dia_hora');
INSERT INTO bd_questio VALUES (263, 12, 'Fer el llistat d''ocells vistos, biòlegs, miradors i dia_hora, ordenats per línia temporal (nom comú, cognom, nom del mirador, dia_hora)', 1, 0,'select nom_comu,cognom,mirador,dia_hora from OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN BIOLEG B USING(id_bioleg)\nINNER JOIN MIRADOR M ON A.id_mirador=M.id_mirador\nORDER BY dia_hora');
INSERT INTO bd_questio VALUES (264, 12, 'Quins ocells va veure el Roger Berrué el 5 de març? (id, nom comú, nom cientific)', 1, 0,'select id_ocell,nom_comu,nom_cientific FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN BIOLEG B USING(id_bioleg)\nWHERE nom=''Roger'' AND cognom=''Berrué'' AND DATE(dia_hora)=''2022-03-05''');
INSERT INTO bd_questio VALUES (265, 12, 'Quins biòlegs han observat un ànec negre durant aquest cap de setmana de campanya? (nom i cognom, ordenat per cognom, valors únics)', 1, 0,'select DISTINCT nom, cognom FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nINNER JOIN OCELL O USING(id_ocell)\nWHERE nom_comu=''Ànec negre''\nORDER BY cognom');
INSERT INTO bd_questio VALUES (266, 12, 'Quins biòlegs han fet avistaments des de l''Aguait de Cal Tet? (nom i cognom) (valors únics, ordenat per cognom)', 1, 0,'select DISTINCT nom, cognom FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nINNER JOIN MIRADOR M ON M.id_mirador=A.id_mirador\nWHERE mirador=''Aguait de Cal Tet''\nORDER BY cognom');
INSERT INTO bd_questio VALUES (267, 12, 'Quins ocells s''han vist des de l''Aguait de la Maresma? (nom comú, nom científic) (valors únics, ordenat per nom comú)', 1, 0,'select DISTINCT nom_comu, nom_cientific FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN MIRADOR M USING(id_mirador)\nWHERE mirador=''Aguait de la Maresma''\nORDER BY nom_comu');
INSERT INTO bd_questio VALUES (268, 12, 'Quins ocells es van veure el dissabte 5 de març entre les 15 i les 17h? (nom comú, valors únics, ordenat per nom comú)', 1, 0,'select DISTINCT nom_comu FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nWHERE DATE(dia_hora)=''2022-03-05'' AND HOUR(dia_hora)>=15 AND HOUR(dia_hora)<=17 ORDER BY nom_comu');
INSERT INTO bd_questio VALUES (269, 12, 'Quins biòlegs estaven actius el diumenge 6 de març de 9 a 10 del matí) (nom i cognom, valors únics, ordenat per nom).', 1, 0,'select DISTINCT nom, cognom FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nWHERE DATE(dia_hora)=''2022-03-06'' AND HOUR(dia_hora)>=9 AND HOUR(dia_hora)<=10\nORDER BY nom');
INSERT INTO bd_questio VALUES (270, 12, 'Llistar els ocells, i el número d''avistaments de cada ocell, que s''han fet el cap de setmana (nom comú i número, ordenat de major a menor).', 1, 0,'select nom_comu, count(*) num FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nGROUP BY nom_comu\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (271, 12, 'Llistar els ocells, i el número d''avistaments de cada ocell, que s''han fet el dissabte (nom comú i número, ordenat de major a menor).', 1, 0,'select nom_comu, count(*) num FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nWHERE DATE(dia_hora)=''2022-03-05''\nGROUP BY nom_comu\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (272, 12, 'Llistar els miradors, i el número d''avistaments que s''han fet des dels miradors el diumenge (nom del mirador i número, ordenat de major a menor).', 1, 0,'select mirador, count(*) num FROM MIRADOR M\nINNER JOIN AVISTAMENT A USING(id_mirador)\nWHERE DATE(dia_hora)=''2022-03-06''\nGROUP BY mirador\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (273, 12, 'Llistar els biòlegs, i el número d''avistaments que han fet durant el cap de setmana (nom, cognom i número, ordenat de major a menor).', 1, 0,'select nom, cognom, count(*) num FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nGROUP BY nom, cognom\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (274, 12, 'Fer el resum dels dies (yyyy-mm-dd) i el número d''avistaments que s''ha fet cada dia (ordenat per dia)', 1, 0,'select DATE(dia_hora) dia, count(*) num FROM AVISTAMENT GROUP BY dia');
INSERT INTO bd_questio VALUES (275, 12, 'Fer el resum dels dies (yyyy-mm-dd) i el número d''avistaments que s''ha fet cada dia (ordenat per dia)', 1, 0,'select DATE(dia_hora) dia, count(*) num FROM AVISTAMENT GROUP BY dia');
INSERT INTO bd_questio VALUES (276, 12, 'Llista de mirador, i dins de cada mirador llistar els biòlegs i número d''ocells que han avistat (nom del mirador, cognom, número, ordenat per mirador i cognom)', 1, 0,'select mirador, cognom, count(*) num from MIRADOR M\nINNER JOIN AVISTAMENT USING(id_mirador)\nINNER JOIN BIOLEG USING (id_bioleg)\nGROUP BY mirador, cognom\nORDER BY mirador, cognom');
INSERT INTO bd_questio VALUES (277, 12, 'Llista dels biòlegs, i per cada biòleg llistar els miradors i número d''ocells que han avistat (cognom, nom del mirador, número, ordenat per cognom i mirador)', 1, 0,'select cognom, mirador, count(*) num from BIOLEG\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nINNER JOIN MIRADOR M ON M.id_mirador=A.id_mirador\nGROUP BY cognom, mirador\nORDER BY cognom, mirador');
INSERT INTO bd_questio VALUES (278, 12, 'Quin és l''ocell més vist? (nom comú, nom científic)', 1, 0,'select nom_comu, nom_cientific FROM OCELL\nINNER JOIN AVISTAMENT USING(id_ocell)\nGROUP BY nom_comu, nom_cientific\nORDER BY COUNT(*) DESC LIMIT 1');
INSERT INTO bd_questio VALUES (279, 12, 'Quin és l''ocell menys vist? (nom comú, nom científic)', 1, 0,'select nom_comu, nom_cientific FROM OCELL\nINNER JOIN AVISTAMENT USING(id_ocell)\nGROUP BY nom_comu, nom_cientific\nORDER BY COUNT(*) LIMIT 1');
INSERT INTO bd_questio VALUES (280, 12, 'Quin biòleg ha fet més avistaments? (nom i cognom tot junt separat per un espai en blanc)', 1, 0,'select CONCAT(nom," ",cognom) as nom_complet FROM BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\nGROUP BY nom, cognom\nORDER BY COUNT(*) DESC LIMIT 1');
INSERT INTO bd_questio VALUES (281, 12, 'Des de quin mirador s''han fet més avistaments? (format "1. Mirador...")', 1, 0,'select CONCAT(id_mirador,". ",mirador) as mirador FROM MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\nGROUP BY id_mirador, mirador\nORDER BY COUNT(*) DESC LIMIT 1');
INSERT INTO bd_questio VALUES (282, 12, 'Llista de tots els miradors, i els seus responsables si en tenen (nom del mirador, cognom), ordenat per mirador.', 1, 0,'select mirador, cognom from MIRADOR M\nLEFT OUTER JOIN BIOLEG B ON M.id_mirador=B.id_mirador\nORDER BY mirador');
INSERT INTO bd_questio VALUES (283, 12, 'Llista de tots els biòlegs, i els noms dels miradors dels quals són responsables (si en tenen) (cognom i nom del mirador, ordenat per cognom).', 1, 0,'select cognom,mirador from BIOLEG B\nLEFT OUTER JOIN MIRADOR M ON M.id_mirador=B.id_mirador\nORDER BY cognom');
INSERT INTO bd_questio VALUES (284, 12, 'Llista de biòlegs que aquest cap de setmana no han pogut participar en la campanya (nom i cognom)', 1, 0,'select nom, cognom from BIOLEG where cognom NOT IN(\nselect distinct cognom FROM BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\n)');
INSERT INTO bd_questio VALUES (285, 12, 'Llista de miradors des dels quals no s''ha fet cap avistament (nom del mirador).', 1, 0,'select mirador from MIRADOR where mirador NOT IN(\nselect distinct mirador FROM MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\n)');
INSERT INTO bd_questio VALUES (286, 12, 'Quins són els ocells que no es van avistar el dissabte? (nom comú).', 1, 0,'select nom_comu from OCELL where nom_comu NOT IN(\nselect distinct nom_comu FROM OCELL INNER JOIN AVISTAMENT USING(id_ocell)\nWHERE DATE(dia_hora)=''2022-03-05''\n)');
INSERT INTO bd_questio VALUES (287, 12, 'Quins són els ocells que no es van avistar el cap de setmana? (nom comú).', 1, 0,'select nom_comu from OCELL where nom_comu NOT IN(\nselect distinct nom_comu FROM OCELL INNER JOIN AVISTAMENT USING(id_ocell)\n)');
INSERT INTO bd_questio VALUES (288, 12, 'Número d''avistaments agrupat per universitat (nom de la universitat, número)', 1, 0,'select universitat, count(*) num FROM BIOLEG B\nINNER JOIN AVISTAMENT USING(id_bioleg)\nGROUP BY universitat');
INSERT INTO bd_questio VALUES (289, 12, 'Número d''avistaments agrupat per universitat (nom de la universitat, número)', 1, 0,'select universitat, count(*) num FROM BIOLEG B\nINNER JOIN AVISTAMENT USING(id_bioleg)\nGROUP BY universitat');
INSERT INTO bd_questio VALUES (290, 12, 'De l''Aguait de Cal Tet, quins ocells s''han vist en aquest aguait, i quin número d''avistaments de cadascun (nom comú, número, ordenat per nom comú).', 1, 0,'select nom_comu, count(*) num from MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\nINNER JOIN OCELL USING(id_ocell)\nwhere mirador=''Aguait de Cal Tet''\nGROUP BY nom_comu ORDER BY nom_comu');
INSERT INTO bd_questio VALUES (291, 12, 'La Núria Vallès, quins ocells ha vist, i quin número d''avistaments de cadascun (nom comú, número, ordenat per nom comú).', 1, 0,'select nom_comu, count(*) num from BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\nINNER JOIN OCELL USING(id_ocell)\nwhere nom=''Núria'' AND cognom=''Vallès''\nGROUP BY nom_comu ORDER BY nom_comu;');
INSERT INTO bd_questio VALUES (292, 12, 'Llistar tots els ocells, i les persones que els ha vist (també ha de sortir a la llista els ocells que no els vist ningú). Ordenat per nom comú i cognom. Valors únics.', 1, 0,'select distinct nom_comu,cognom from OCELL\nLEFT OUTER JOIN AVISTAMENT USING(id_ocell)\nLEFT OUTER JOIN BIOLEG USING(id_bioleg)\nORDER BY nom_comu, cognom');
INSERT INTO bd_questio VALUES (293, 12, 'Llistar tots els ocells, i els miradors des d''on s''han vist (també ha de sortir a la llista els ocells que no s''han vist). Ordenat per nom comú i mirador. Valors únics.', 1, 0,'select distinct nom_comu,mirador from OCELL\nLEFT OUTER JOIN AVISTAMENT USING(id_ocell)\nLEFT OUTER JOIN MIRADOR USING(id_mirador)\nORDER BY nom_comu, mirador');
INSERT INTO bd_questio VALUES (294, 12, 'Llistar tots els biòlegs que han vist un Ànec cuallarg (nom i cognoms, valors únics)', 1, 0,'select distinct nom, cognom from BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\nINNER JOIN OCELL USING(id_ocell)\nWHERE nom_comu=''Ànec cuallarg''');
INSERT INTO bd_questio VALUES (295, 12, 'Llistar tots els miradors on s''ha vist un Ànec cuallarg (nom del mirador, valors únics)', 1, 0,'select distinct mirador from MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\nINNER JOIN OCELL USING(id_ocell)\nWHERE nom_comu=''Ànec cuallarg''');

INSERT INTO bd_questio VALUES (296, 12, 'Listar los biólogos (nombre, apellido) que participan en el proyecto, por orden alfabético del apellido.', 1, 0,'select nom,cognom from BIOLEG order by cognom');
INSERT INTO bd_questio VALUES (297, 12, 'Listar los pájaros presentes en el Delta del Llobregat (nombre común, y nombre científico). Ordenado por nombre científico.', 1, 0,'select nom_comu, nom_cientific from OCELL order by nom_cientific');
INSERT INTO bd_questio VALUES (298, 12, 'Listar todos los pájaros que son patos (ànecs) (id y nombre común, ordenado por el nombre)', 1, 0,'select id_ocell, nom_comu from OCELL where nom_comu like ''%anec%'' order by nom_comu');
INSERT INTO bd_questio VALUES (299, 12, 'Listar todos los biólogos que su nombre empiece por ''P'' (id, nombre, apellido), ordenado primero por apellido y después por el nombre)', 1, 0,'select id_bioleg,nom,cognom from BIOLEG where nom like ''P%'' order by cognom, nom');
INSERT INTO bd_questio VALUES (300, 12, 'Listar todos los biólogos que son responsables de un mirador (id, apellido), ordenado por apellido', 1, 0,'select id_bioleg, cognom from BIOLEG where id_mirador is not null order by cognom');
INSERT INTO bd_questio VALUES (301, 12, 'Listar todos los biólogos que no son responsables de un mirador (id, nombre), ordenado por nombre en orden descendiente.', 1, 0,'select id_bioleg, nom from BIOLEG where id_mirador is null order by nom DESC');
INSERT INTO bd_questio VALUES (302, 12, 'Listar las iniciales de los biólogos (por ej, PC, MP), ordenado por nombre y por apellido.', 1, 0,'select concat(left(nom,1),left(cognom,1)) as inicials from BIOLEG order by nom,cognom');
INSERT INTO bd_questio VALUES (303, 12, 'Listar el género y la especie de los pájaros de forma separada (per ex, Cygnus i olor separats). (ajuda: https://sebhastian.com/mysql-split-string/)', 1, 0,'select SUBSTRING_INDEX(nom_cientific,'' '',1) as genere, SUBSTRING_INDEX(nom_cientific,'' '',-1) as especie from OCELL');
INSERT INTO bd_questio VALUES (304, 12, 'Qué valores tenemos en el campo abundancia de la tabla OCELL? (valores diferentes)', 1, 0,'select distinct abundancia from OCELL');
INSERT INTO bd_questio VALUES (305, 12, 'Qué días se hicieron avistamientos de pájaros (yyyy-mm-dd)? (Ordenado por yyyy-mm-dd)', 1, 0,'select distinct DATE(dia_hora) FROM AVISTAMENT');
INSERT INTO bd_questio VALUES (306, 12, 'Cuál es el valor máximo del id de avistamiento?', 1, 0,'select max(id_avistament) from AVISTAMENT');
INSERT INTO bd_questio VALUES (307, 12, 'Cuál es el valor máximo del id de pájaro?', 1, 0,'select max(id_ocell) from OCELL');
INSERT INTO bd_questio VALUES (308, 12, 'Cuál es el valor medio de la longitud del nombre de los miradores?', 1, 0,'select AVG(LENGTH(mirador)) as avg_mirador from MIRADOR');
INSERT INTO bd_questio VALUES (309, 12, 'Cuál es el valor medio de la longitud del apellido de los biólogos?', 1, 0,'select AVG(LENGTH(cognom)) as avg_cognom from BIOLEG');
INSERT INTO bd_questio VALUES (310, 12, 'Cuántos avistamientos ha hecho el biólogo id=5?', 1, 0,'select count(*) from AVISTAMENT WHERE id_bioleg=5');
INSERT INTO bd_questio VALUES (311, 12, 'Cuántos avistamientos se han hecho el día 5 de marzo?', 1, 0,'select count(*) from AVISTAMENT WHERE DATE(dia_hora)=''2022-03-05''');
INSERT INTO bd_questio VALUES (312, 12, 'Lista los 10 primeros resultados de pájaros, ordenándolos por nombre común en orden descendente (id, nombre común)', 1, 0,'select id_ocell, nom_comu from OCELL order by nom_comu DESC LIMIT 10');
INSERT INTO bd_questio VALUES (313, 12, 'Lista los 5 primeros valores de los avistamientos más tempranos del domingo 6 de marzo (todos los campos, ordenado por datetime)', 1, 0,'select * from AVISTAMENT WHERE DATE(dia_hora)=''22-03-06'' order by dia_hora asc limit 5');
INSERT INTO bd_questio VALUES (314, 12, 'Lista los pájaros que su nombre común contenga una ''x'' y con más de 10 letras.', 1, 0,'select * from OCELL where nom_comu like ''%x%'' and LENGTH(nom_comu)>10');
INSERT INTO bd_questio VALUES (315, 12, 'Lista los pájaros que su nombre científico contenga ''y'' y con más de 15 letras.', 1, 0,'select * from OCELL where nom_cientific like ''%y%'' and LENGTH(nom_cientific)>15');
INSERT INTO bd_questio VALUES (316, 12, 'Hacer la lista de pájaros, junto con la longitud de su nombre común (nombre común y número de caracteres, ordenado de menor a mayor).', 1, 0,'select nom_comu, LENGTH(nom_comu) as num FROM OCELL order by num');
INSERT INTO bd_questio VALUES (317, 12, 'Hacer la lista de miradores, junto con la longitud del nombre del mirador (nombre del mirador y número de caracteres, ordenado de menor a mayor).', 1, 0,'select mirador, LENGTH(mirador) as num FROM MIRADOR order by num');
INSERT INTO bd_questio VALUES (318, 12, 'Cuáles son los biólogos (nombre, apellido) que son responsables de un mirador que empieza por Aguait? (subconsulta)', 1, 0,'select nom,cognom from BIOLEG where id_mirador IN (select id_mirador from MIRADOR WHERE mirador like ''Aguait%'')');
INSERT INTO bd_questio VALUES (319, 12, 'Cuáles son los miradores que tienen responsable? Ordenado por mirador. (subconsulta)', 1, 0,'select * from MIRADOR where id_mirador IN (select id_mirador from BIOLEG) ORDER BY mirador');
INSERT INTO bd_questio VALUES (320, 12, 'Listado de los miradores y su responsable (sólo los que tienen responsable). Nombre del mirador y apellido, ordenado por mirador.', 1, 0,'select mirador, cognom from MIRADOR M\nINNER JOIN BIOLEG B ON M.id_mirador=B.id_mirador\nORDER BY mirador');
INSERT INTO bd_questio VALUES (321, 12, 'Listado de los miradores y su responsable (sólo los que tienen responsable). Nombre del mirador y apellido, ordenado por mirador.', 1, 0,'select mirador, cognom from MIRADOR M\nINNER JOIN BIOLEG B ON M.id_mirador=B.id_mirador\nORDER BY mirador');
INSERT INTO bd_questio VALUES (322, 12, 'Listar todos los pájaros que ha avistado el biólogo id=3 (id_ocell, nombre común, valores únicos).', 1, 0,'select id_ocell, nom_comu from OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nWHERE id_bioleg=3');
INSERT INTO bd_questio VALUES (323, 12, 'Listar todos los miradores donde ha estado observando el biólogo id=4 (id_mirador, mirador, valores únicos).', 1, 0,'select distinct id_mirador, mirador from MIRADOR M\nINNER JOIN AVISTAMENT A USING(id_mirador)\nWHERE id_bioleg=4');
INSERT INTO bd_questio VALUES (324, 12, 'Listar todos los pájaros que ha avistado el biólogo Jordi Casademunt (id_ocell, nombre común, dia_hora).', 1, 0,'select id_ocell, nom_comu, dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING (id_ocell)\nINNER JOIN BIOLEG B USING (id_bioleg)\nWHERE nom=''Jordi'' AND cognom=''Casademunt''');
INSERT INTO bd_questio VALUES (325, 12, 'Listar todos los pájaros que se han avistado desde el Mirador de Cal Beitas (id_ocell, nombre común, dia_hora).', 1, 0,'select id_ocell, nom_comu, dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING (id_ocell)\nINNER JOIN MIRADOR M USING (id_mirador)\nWHERE mirador=''Mirador de Cal Beitas''');
INSERT INTO bd_questio VALUES (326, 12, 'Qué biólogo ha hecho el avistamiento más temprano del 5 de marzo? (nombre, apellido, dia_hora)', 1, 0,'select nom,cognom,dia_hora FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nORDER BY dia_hora ASC LIMIT 1');
INSERT INTO bd_questio VALUES (327, 12, 'Qué pájaro se vio primero el día 5 de marzo? (nombre común, dia_hora)', 1, 0,'select nom_comu,dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nORDER BY dia_hora ASC LIMIT 1');
INSERT INTO bd_questio VALUES (328, 12, 'Qué pájaro se vio último el día 6 de marzo? (nombre común, dia_hora)', 1, 0,'select nom_comu,dia_hora FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nORDER BY dia_hora DESC LIMIT 1');
INSERT INTO bd_questio VALUES (329, 12, 'Qué biólogo hizo el último avistamiento el día 6 de marzo? (nombre, apellido, dia_hora)', 1, 0,'select nom,cognom,dia_hora FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nORDER BY dia_hora DESC LIMIT 1');

INSERT INTO bd_questio VALUES (330, 12, 'Hacer el listado de pájaros vistos, biólogos, miradores y dia_hora, ordenados por línia temporal (nombre común, apellido, nombre del mirador, dia_hora)', 1, 0,'select nom_comu,cognom,mirador,dia_hora from OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN BIOLEG B USING(id_bioleg)\nINNER JOIN MIRADOR M ON A.id_mirador=M.id_mirador\nORDER BY dia_hora');
INSERT INTO bd_questio VALUES (331, 12, 'Hacer el listado de pájaros vistos, biólogos, miradores y dia_hora, ordenados por línia temporal (nombre común, apellido, nombre del mirador, dia_hora)', 1, 0,'select nom_comu,cognom,mirador,dia_hora from OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN BIOLEG B USING(id_bioleg)\nINNER JOIN MIRADOR M ON A.id_mirador=M.id_mirador\nORDER BY dia_hora');
INSERT INTO bd_questio VALUES (332, 12, 'Qué pájaros vio Roger Berrué el 5 de marzo? (id, nombre común, nombre científico)', 1, 0,'select id_ocell,nom_comu,nom_cientific FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN BIOLEG B USING(id_bioleg)\nWHERE nom=''Roger'' AND cognom=''Berrué'' AND DATE(dia_hora)=''2022-03-05''');
INSERT INTO bd_questio VALUES (333, 12, 'Qué biólogos han observado un pato negro (ànec negre) durante este fin de semana de campaña? (nombre y apellido, ordenado por apellido, valores únicos)', 1, 0,'select DISTINCT nom,cognom FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nINNER JOIN OCELL O USING(id_ocell)\nWHERE nom_comu=''Ànec negre''\nORDER BY cognom');
INSERT INTO bd_questio VALUES (334, 12, 'Qué biólogos han hecho avistamientos desde el Aguait de Cal Tet? (nombre y apellidos) (valores únicos, ordenado por apellido)', 1, 0,'select DISTINCT (nombre, apellido) FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nINNER JOIN MIRADOR M ON M.id_mirador=A.id_mirador\nWHERE mirador=''Aguait de Cal Tet''\nORDER BY cognom');
INSERT INTO bd_questio VALUES (335, 12, 'Qué pájaros se han visto desde el Aguait de la Maresma? (nombre común, nombre científico) (valores únicos, ordenado por nombre común)', 1, 0,'select DISTINCT nom_comu, nom_cientific FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nINNER JOIN MIRADOR M USING(id_mirador)\nWHERE mirador=''Aguait de la Maresma''\nORDER BY nom_comu');
INSERT INTO bd_questio VALUES (336, 12, 'Qué pájaros es vieron el sábado 5 de marzo entre las 15 y las 17h? (nombre común, valores únicos, ordenado por nombre común)', 1, 0,'select DISTINCT nom_comu FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nWHERE DATE(dia_hora)=''2022-03-05'' AND HOUR(dia_hora)>=15 AND HOUR(dia_hora)<=17 ORDER BY nom_comu');
INSERT INTO bd_questio VALUES (337, 12, 'Qué biólogos estaban activos el domingo 6 de marzo de 9 a 10 de la mañana) (nombre i apellido, valores únicos, ordenado por nombre).', 1, 0,'select DISTINCT nom,cognom FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nWHERE DATE(dia_hora)=''2022-03-06'' AND HOUR(dia_hora)>=9 AND HOUR(dia_hora)<=10\nORDER BY nom');
INSERT INTO bd_questio VALUES (338, 12, 'Listar los pájaros, y el número de avistamientos de cada pájaro, que se han hecho el fin de semana (nombre común y número, ordenado de mayor a menor).', 1, 0,'select nom_comu, count(*) num FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nGROUP BY nom_comu\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (339, 12, 'Listar los pájaros, y el número de avistamientos de cada pájaro, que se han hecho el sábado (nombre común y número, ordenado de mayor a menor).', 1, 0,'select nom_comu, count(*) num FROM OCELL O\nINNER JOIN AVISTAMENT A USING(id_ocell)\nWHERE DATE(dia_hora)=''2022-03-05''\nGROUP BY nom_comu\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (340, 12, 'Listar los miradores, y el número de avistamientos que se han hecho desde los miradores el domingo (nombre del mirador y número, ordenado de mayor a menor).', 1, 0,'select mirador, count(*) num FROM MIRADOR M\nINNER JOIN AVISTAMENT A USING(id_mirador)\nWHERE DATE(dia_hora)=''2022-03-06''\nGROUP BY mirador\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (341, 12, 'Listar los biólogos, y el número de avistamientos que han hecho durante el fin de semana (nombre, apellido y número, ordenado de mayor a menor).', 1, 0,'select nom,cognom, count(*) num FROM BIOLEG B\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nGROUP BY (nombre, apellido)\nORDER BY num DESC');
INSERT INTO bd_questio VALUES (342, 12, 'Hacer el resumen de los días (yyyy-mm-dd) y el número de avistaments que se ha hecho cada día (ordenado por día)', 1, 0,'select DATE(dia_hora) dia, count(*) num FROM AVISTAMENT GROUP BY dia');
INSERT INTO bd_questio VALUES (343, 12, 'Hacer el resumen de los días (yyyy-mm-dd) y el número d eavistaments que se ha hecho cada día (ordenado por día)', 1, 0,'select DATE(dia_hora) dia, count(*) num FROM AVISTAMENT GROUP BY dia');
INSERT INTO bd_questio VALUES (344, 12, 'Lista de miradores, y dentro de cada mirador listar los biólogos y número de pájaros que han avistado (nombre del mirador, apellido, número, ordenado por mirador y apellido)', 1, 0,'select mirador, cognom, count(*) num from MIRADOR M\nINNER JOIN AVISTAMENT USING(id_mirador)\nINNER JOIN BIOLEG USING (id_bioleg)\nGROUP BY mirador, cognom\nORDER BY mirador, cognom');
INSERT INTO bd_questio VALUES (345, 12, 'Lista de los biólogos, y por cada biólogo listar los miradores y número de pájaros que han avistado (apellido, nombre del mirador, número, ordenado por apellido y mirador)', 1, 0,'select cognom, mirador, count(*) num from BIOLEG\nINNER JOIN AVISTAMENT A USING(id_bioleg)\nINNER JOIN MIRADOR M ON M.id_mirador=A.id_mirador\nGROUP BY cognom, mirador\nORDER BY cognom, mirador');
INSERT INTO bd_questio VALUES (346, 12, 'Cuál es el pájaro mas visto? (nombre común, nombre científico)', 1, 0,'select nom_comu, nom_cientific FROM OCELL\nINNER JOIN AVISTAMENT USING(id_ocell)\nGROUP BY nom_comu, nom_cientific\nORDER BY COUNT(*) DESC LIMIT 1');
INSERT INTO bd_questio VALUES (347, 12, 'Cuál es el pájaro menos visto (nombre común, nombre científico)?', 1, 0,'select nom_comu, nom_cientific FROM OCELL\nINNER JOIN AVISTAMENT USING(id_ocell)\nGROUP BY nom_comu, nom_cientific\nORDER BY COUNT(*) LIMIT 1');
INSERT INTO bd_questio VALUES (348, 12, 'Qué biólogo ha hecho más avistamientos? (nombre y apellido todo junto separados por un espacio en blanco)', 1, 0,'select CONCAT(nom," ",cognom) as nom_complet FROM BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\nGROUP BY nom,cognom\nORDER BY COUNT(*) DESC LIMIT 1');
INSERT INTO bd_questio VALUES (349, 12, 'Desde qué mirador se han hecho más avistamientos? (formato "1. Mirador...")', 1, 0,'select CONCAT(id_mirador,". ",mirador) as mirador FROM MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\nGROUP BY id_mirador, mirador\nORDER BY COUNT(*) DESC LIMIT 1');
INSERT INTO bd_questio VALUES (350, 12, 'Lista de todos los miradores, y sus responsables si es que tienen (nombre del mirador, apellido), ordenado por mirador.', 1, 0,'select mirador, cognom from MIRADOR M\nLEFT OUTER JOIN BIOLEG B ON M.id_mirador=B.id_mirador\nORDER BY mirador');
INSERT INTO bd_questio VALUES (351, 12, 'Lista de todos los biólogos, y el nombre de los miradores de los que son responsables (si es que tienen) (apellido y nombre del mirador, ordenado por apellido).', 1, 0,'select cognom,mirador from BIOLEG B\nLEFT OUTER JOIN MIRADOR M ON M.id_mirador=B.id_mirador\nORDER BY cognom');
INSERT INTO bd_questio VALUES (352, 12, 'Lista de biólogos que este fin de semana no han podido participar en la campaña (nombre y apellido)', 1, 0,'select nom,cognom from BIOLEG where cognom NOT IN(\nselect distinct cognom FROM BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\n)');
INSERT INTO bd_questio VALUES (353, 12, 'Lista de miradores desde los que no se ha hecho ningún avistamiento (nombre del mirador).', 1, 0,'select mirador from MIRADOR where mirador NOT IN(\nselect distinct mirador FROM MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\n)');
INSERT INTO bd_questio VALUES (354, 12, 'Cuáles son los pájaros que no se avistaron el sábado? (nombre común).', 1, 0,'select nom_comu from OCELL where nom_comu NOT IN(\nselect distinct nom_comu FROM OCELL INNER JOIN AVISTAMENT USING(id_ocell)\nWHERE DATE(dia_hora)=''2022-03-05''\n)');
INSERT INTO bd_questio VALUES (355, 12, 'Cuáles son los pájaros que no se avistaron el fin de semana? (nombre común).', 1, 0,'select nom_comu from OCELL where nom_comu NOT IN(\nselect distinct nom_comu FROM OCELL INNER JOIN AVISTAMENT USING(id_ocell)\n)');
INSERT INTO bd_questio VALUES (356, 12, 'Número de avistamientos agrupados por universidad (nombre de la universidad, número)', 1, 0,'select universitat, count(*) num FROM BIOLEG B\nINNER JOIN AVISTAMENT USING(id_bioleg)\nGROUP BY universitat');
INSERT INTO bd_questio VALUES (357, 12, 'Número de avistamientos agrupados por universidad (nombre de la universidad, número)', 1, 0,'select universitat, count(*) num FROM BIOLEG B\nINNER JOIN AVISTAMENT USING(id_bioleg)\nGROUP BY universitat');
INSERT INTO bd_questio VALUES (358, 12, 'En el Aguait de Cal Tet, qué pájaros se han visto en esta guarida, y qué número de avistamientos de cada uno (nombre común, número, ordenado por nombre común).', 1, 0,'select nom_comu, count(*) num from MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\nINNER JOIN OCELL USING(id_ocell)\nwhere mirador=''Aguait de Cal Tet''\nGROUP BY nom_comu ORDER BY nom_comu');
INSERT INTO bd_questio VALUES (359, 12, 'Núria Vallès, qué pájaros ha visto, y qué número de avistamientos de cada uno (nombre común, número, ordenado por nombre común).', 1, 0,'select nom_comu, count(*) num from BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\nINNER JOIN OCELL USING(id_ocell)\nwhere nom=''Núria'' AND cognom=''Vallès''\nGROUP BY nom_comu ORDER BY nom_comu;');
INSERT INTO bd_questio VALUES (360, 12, 'Listar todos los pájaros, y las personas que los han visto (también ha de salir en la lista los pájaros que no los ha visto nadie). Ordenado por nombre común y apellido. Valores únicos.', 1, 0,'select distinct nom_comu,cognom from OCELL\nLEFT OUTER JOIN AVISTAMENT USING(id_ocell)\nLEFT OUTER JOIN BIOLEG USING(id_bioleg)\nORDER BY nom_comu, cognom');
INSERT INTO bd_questio VALUES (361, 12, 'Listar todos los pájaros, y los miradores desde donde se han visto (también ha de salir en la lista los pájaros que no se han visto). Ordenado por nombre común y mirador. Valores únicos.', 1, 0,'select distinct nom_comu,mirador from OCELL\nLEFT OUTER JOIN AVISTAMENT USING(id_ocell)\nLEFT OUTER JOIN MIRADOR USING(id_mirador)\nORDER BY nom_comu, mirador');
INSERT INTO bd_questio VALUES (362, 12, 'Listar todos los biólogos que han visto un Ànec cuallarg (nombre y apellidos, valores únicos)', 1, 0,'select distinct nom,cognom from BIOLEG\nINNER JOIN AVISTAMENT USING(id_bioleg)\nINNER JOIN OCELL USING(id_ocell)\nWHERE nom_comu=''Ànec cuallarg''');
INSERT INTO bd_questio VALUES (363, 12, 'Listar todos los miradores donde se ha visto un Ànec cuallarg (nombre del mirador, valores únicos)', 1, 0,'select distinct mirador from MIRADOR\nINNER JOIN AVISTAMENT USING(id_mirador)\nINNER JOIN OCELL USING(id_ocell)\nWHERE nom_comu=''Ànec cuallarg''');

INSERT INTO bd_questio VALUES (364, 1, 'Crear usuari usertest per connectar-se localment (localhost)', 1, 2,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''');
INSERT INTO bd_questio VALUES (365, 1, 'Eliminar usuari usertest (localhost)', 1, 2,'DROP USER ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (366, 1, 'Donar permisos a l''usuari usertest per modificar el camp municipis.municipis', 1, 2,'GRANT UPDATE(municipi) ON municipis.municipis TO ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (367, 1, 'Donar tots els privilegis a l''usuari usertest (localhost) sobre la base de dades de municipis', 1, 2,'GRANT ALL PRIVILEGES ON municipis.* TO ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (368, 1, 'Donar privilegis de només lectura a l''usuari usertest (localhost) sobre la taula de comunitats', 1, 2,'GRANT SELECT ON municipis.comunitats TO ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (369, 9, 'Donar privilegis de inserció i de modificació de superfície sobre la taula municipis, a l''usuari usertest (localhost)', 1, 2,'GRANT INSERT, UPDATE(superficie) ON municipis.municipis TO ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (370, 9, 'Mostrar els permisos de l''usertest (localhost) ', 1, 2,'SHOW GRANTS FOR ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (371, 9, 'Donar el privilegi d''esborrat de comunitats a l''usuari usertest (localhost)', 1, 2,'GRANT DELETE ON municipis.comunitats TO ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (372, 9, 'Donar el privilegi de lectura sobre la vista INFORME_MUNICIPIS a l''usuari usertest (localhost)', 1, 2,'GRANT SELECT ON municipis.INFORME_MUNICIPIS TO ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (373, 9, 'Revocar el privilegi de inserció sobre la taula municipis a l''usuari usertest (localhost)', 1, 2,'REVOKE INSERT ON municipis.municipis FROM ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (374, 9, 'Revocar el privilegi de lectura, inserció, modificació i esborrat sobre la taula municipis a l''usuari usertest (localhost)', 1, 2,'REVOKE SELECT,INSERT,UPDATE,DELETE ON municipis.municipis FROM ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (375, 9, 'Revocar tots els privilegis sobre la taula municipis a l''usuari usertest (localhost)', 1, 2,'REVOKE ALL privileges ON municipis.municipis FROM ''usertest''@''localhost''');
INSERT INTO bd_questio VALUES (376, 9, 'Revocar tots els privilegis a l''usuari usertest (localhost)', 1, 2,'REVOKE ALL PRIVILEGES, GRANT OPTION FROM ''usertest''@''localhost''');

INSERT INTO bd_questio_prepost VALUES (364,1,'GRANT ALL ON municipis.* TO ''usertest''@localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (364,2,'FLUSH PRIVILEGES','POST'); # no cal
INSERT INTO bd_questio_prepost VALUES (364,3,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (364,4,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (365,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (365,2,'SHOW GRANTS FOR ''usertest''@''localhost''','PRE');
#per a un drop user, he de tornar a fer el drop user perquè si l'alumne s'equivoca, quedaria l'usuari creat
INSERT INTO bd_questio_prepost VALUES (365,4,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (366,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (366,2,'FLUSH PRIVILEGES','PRE');
INSERT INTO bd_questio_prepost VALUES (366,3,'FLUSH PRIVILEGES','POST');
INSERT INTO bd_questio_prepost VALUES (366,4,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (366,5,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (367,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (367,2,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (367,3,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (368,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (368,2,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (368,3,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (369,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (369,2,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (369,3,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (370,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (370,2,'GRANT INSERT, UPDATE(superficie) ON municipis.municipis TO ''usertest''@''localhost''','PRE');
INSERT INTO bd_questio_prepost VALUES (370,3,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (371,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (371,2,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (371,3,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (372,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (372,2,'create view municipis.INFORME_MUNICIPIS AS (SELECT municipi from municipis.municipis where id_mun>7800)','PRE');
INSERT INTO bd_questio_prepost VALUES (372,3,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (372,4,'drop view municipis.INFORME_MUNICIPIS','POST');
INSERT INTO bd_questio_prepost VALUES (372,5,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (373,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (373,2,'GRANT INSERT ON municipis.municipis TO ''usertest''@''localhost''','PRE');
INSERT INTO bd_questio_prepost VALUES (373,3,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (373,4,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (374,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (374,2,'GRANT SELECT,INSERT,UPDATE,DELETE ON municipis.municipis TO ''usertest''@''localhost''','PRE');
INSERT INTO bd_questio_prepost VALUES (374,3,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (374,4,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (375,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (375,2,'GRANT SELECT,INSERT,UPDATE,DELETE ON municipis.municipis TO ''usertest''@''localhost''','PRE');
INSERT INTO bd_questio_prepost VALUES (375,3,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (375,4,'DROP USER ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (376,1,'CREATE USER ''usertest''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (376,2,'GRANT SELECT,INSERT,UPDATE,DELETE ON municipis.municipis TO ''usertest''@''localhost''','PRE');
INSERT INTO bd_questio_prepost VALUES (376,3,'SHOW GRANTS FOR ''usertest''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (376,4,'DROP USER ''usertest''@''localhost''','POST');

# ===========

INSERT INTO alumne VALUES (1, 'Joan', 'Quintana', '1DAM', 'jquintana@jaumebalmes.net',1);
INSERT INTO alumne VALUES (2, 'Juan Carlos','Abucay', '1DAM', 'jabucay19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (3, 'Ignacio', 'Albiol', '1DAM', 'ialbiol21@jaumebalmes.net',1);
INSERT INTO alumne VALUES (4, 'Eric', 'Baldó', '1DAM', 'ebaldo@jaumebalmes.net',1);
INSERT INTO alumne VALUES (5, 'Marione', 'Basaysay', '1DAM', 'mbasaysa@jaumebalmes.net',1);
INSERT INTO alumne VALUES (6, 'Sergi', 'Cabedo', '1DAM', 'scabedo21@jaumebalmes.net',1);
INSERT INTO alumne VALUES (7, 'Oriol', 'Cáncer', '1DAM', 'ocancer@jaumebalmes.net',1);
INSERT INTO alumne VALUES (8, 'Víctor', 'Chacón', '1DAM', 'vchacon@jaumebalmes.net',1);
INSERT INTO alumne VALUES (9, 'Bernard', 'Cruz Zavaleta', '1DAM', 'bcruz21@jaumebalmes.net',1);
INSERT INTO alumne VALUES (10, 'Alex', 'Cunillera', '1DAM', 'acunille@jaumebalmes.net',1);
INSERT INTO alumne VALUES (11, 'José Ricardo', 'Francisco Davila', '1DAM', 'jfrancis@jaumebalmes.net',1);
INSERT INTO alumne VALUES (12, 'Ian', 'Gómez Palena', '1DAM', 'igomezp18@jaumebalmes.net',1);
INSERT INTO alumne VALUES (13, 'Felipe', 'González Muñoz', '1DAM', 'fgonzale@jaumebalmes.net',1);
INSERT INTO alumne VALUES (14, 'Soap', 'Iglesias', '1DAM', 'siglesias18@jaumebalmes.net',1);
INSERT INTO alumne VALUES (15, 'Adrià', 'Jiménez', '1DAM', 'ajimenez20@jaumebalmes.net',1);
INSERT INTO alumne VALUES (16, 'Marco', 'Laureano', '1DAM', 'mlaurean19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (17, 'Daniel', 'López Torres', '1DAM', 'dlopez0@jaumebalmes.net',1);
INSERT INTO alumne VALUES (18, 'Arnau', 'Lorenzo', '1DAM', 'alorenzo18@jaumebalmes.net',1);
INSERT INTO alumne VALUES (19, 'Yassir', 'Mahboub', '1DAM', 'ymahboub@jaumebalmes.net',1);
INSERT INTO alumne VALUES (20, 'Javier', 'Marrugat', '1DAM', 'jmarruga18@jaumebalmes.net',1);
INSERT INTO alumne VALUES (21, 'Eduardo', 'Martorell', '1DAM', 'emartore@jaumebalmes.net',1);
INSERT INTO alumne VALUES (22, 'Carles', 'Mauri Seguí', '1DAM', 'cmauri18@jaumebalmes.net',1);
INSERT INTO alumne VALUES (23, 'Guillermo', 'Noceda', '1DAM', 'gnoceda@jaumebalmes.net',1);
INSERT INTO alumne VALUES (24, 'Arnau', 'Ochoa', '1DAM', 'aochoa21@jaumebalmes.net',1);
INSERT INTO alumne VALUES (25, 'Jofre', 'Palacios', '1DAM', 'jpalacio@jaumebalmes.net',1);
INSERT INTO alumne VALUES (26, 'Christian', 'Perona', '1DAM', 'cperona@jaumebalmes.net',1);
INSERT INTO alumne VALUES (27, 'Carlos', 'Pons', '1DAM', 'cpons19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (28, 'Xavier', 'Rodríguez Zaragoza', '1DAM', 'xrodrigu@jaumebalmes.net',1);
INSERT INTO alumne VALUES (29, 'David', 'Rosal', '1DAM', 'drosal@jaumebalmes.net',1);
INSERT INTO alumne VALUES (30, 'Joel', 'Sánchez', '1DAM', 'jsanchez19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (31, 'Pol', 'Schwinzer', '1DAM', 'pschwinz18@jaumebalmes.net',1);
INSERT INTO alumne VALUES (32, 'Lonious', 'Sosa', '1DAM', 'lsosa19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (33, 'Deninson', 'Tapia', '1DAM', 'dtapia@jaumebalmes.net',1);
INSERT INTO alumne VALUES (34, 'Miguel', 'Urdaneta', '1DAM', 'murdanet@jaumebalmes.net',1);
INSERT INTO alumne VALUES (35, 'Joel', 'Valera', '1DAM', 'jvalera19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (36, 'Xesc', 'Albiach', '1DAM', 'xalbiach20@jaumebalmes.net',1);
INSERT INTO alumne VALUES (37, 'Sergio', 'Ronda', '1DAM', 'sronda19@jaumebalmes.net',1);
INSERT INTO alumne VALUES (38, 'Empresa', 'Balmes', '1DAM', 'empresa@jaumebalmes.net',1);
INSERT INTO alumne VALUES (39, 'Pau', 'Chacón', '1DAM', 'pchacon19@jaumebalmes.net',1);

INSERT INTO professor VALUES (1, 'Joan', 'Quintana', '1DAM', 'jquintana@jaumebalmes.net');
INSERT INTO professor VALUES (2, 'Joan', 'Quintana', '1DAW', 'admin@jaumebalmes.net');

INSERT INTO quest VALUES (1, 'bàsic HR I', 1, '2021-11-17', 0, 1);
INSERT INTO quest VALUES (2, 'bàsic HR II', 1, '2021-11-17', 0, 1);
INSERT INTO quest VALUES (3, 'bàsic langtrainer III', 1, '2021-11-22', 0, 1);
INSERT INTO quest VALUES (4, 'bàsic langtrainer IV', 1, '2021-11-22', 0, 1);
INSERT INTO quest VALUES (5, 'INNER JOINS I', 1, '2021-11-24', 10, 0, 1);
INSERT INTO quest VALUES (6, 'INNER JOINS II (municipis)', 1, '2021-11-24', 0, 1);
INSERT INTO quest VALUES (7, 'INNER JOINS III (vestuari)', 1, '2021-11-30', 0, 1);
INSERT INTO quest VALUES (8, 'INNER JOINS IV (langtrainer)', 1, '2021-11-30', 0, 1);
INSERT INTO quest VALUES (9, 'Ex 15/12/2021 (sakila)(CAT)', 1, '2021-12-14', 0, 1);
INSERT INTO quest VALUES (10, 'Ex 15/12/2021 (sakila)(ESP)', 1, '2021-12-14', 0, 1);
INSERT INTO quest VALUES (11, 'Barreja Sakila', 1, '2021-12-14', 0, 1);
INSERT INTO quest VALUES (12, 'municipis: insert, update, delete', 1, '2021-12-20', 0, 1);
INSERT INTO quest VALUES (13, 'langtrainer: insert, update, delete', 1, '2021-12-21', 0, 1);
INSERT INTO quest VALUES (14, 'municipis: create, alter, drop', 1, '2022-01-24', 0, 1);
INSERT INTO quest VALUES (15, 'paraulogic: create, alter, drop', 1, '2022-01-24', 0, 1);
INSERT INTO quest VALUES (16, 'HR: GROUP BY', 1, '2022-02-02', 0, 1);
INSERT INTO quest VALUES (17, 'vestuari: GROUP BY', 1, '2022-02-02', 0, 1);
INSERT INTO quest VALUES (18, 'UNION', 1, '2022-02-08', 0, 1);
INSERT INTO quest VALUES (19, 'LEFT JOIN', 1, '2022-02-09', 0, 1);
INSERT INTO quest VALUES (20, 'Barreja I', 1, '2022-02-16', 1, 1);
INSERT INTO quest VALUES (21, 'Barreja II', 1, '2022-02-16', 1, 1);
INSERT INTO quest VALUES (22, 'Examen UF2-BD 1a part', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (23, 'Examen UF2-BD 1a part', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (24, 'Examen UF2-BD 2a part', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (25, 'Examen UF2-BD 2a part', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (26, 'Examen UF2-BD 1a part (cast)', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (27, 'Examen UF2-BD 1a part (cast)', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (28, 'Examen UF2-BD 2a part (cast)', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (29, 'Examen UF2-BD 2a part (cast)', 1, '2022-03-09', 0, 1);
INSERT INTO quest VALUES (30, 'Usuaris i privilegis', 1, '2022-03-07',0, 1);

INSERT INTO quest_detall VALUES (1, 1, 1, 1);
INSERT INTO quest_detall VALUES (2, 1, 2, 2);
INSERT INTO quest_detall VALUES (3, 1, 3, 3);
INSERT INTO quest_detall VALUES (4, 1, 4, 4);
INSERT INTO quest_detall VALUES (5, 1, 5, 5);
INSERT INTO quest_detall VALUES (6, 1, 6, 6);
INSERT INTO quest_detall VALUES (7, 1, 7, 7);
INSERT INTO quest_detall VALUES (8, 1, 8, 8);
INSERT INTO quest_detall VALUES (9, 1, 9, 9);
INSERT INTO quest_detall VALUES (10, 1, 10, 10);
INSERT INTO quest_detall VALUES (11, 1, 11, 11);
INSERT INTO quest_detall VALUES (12, 1, 12, 12);
INSERT INTO quest_detall VALUES (13, 1, 13, 13);
INSERT INTO quest_detall VALUES (14, 1, 14, 14);
INSERT INTO quest_detall VALUES (15, 1, 15, 15);

INSERT INTO quest_detall VALUES (16, 2, 16, 1);
INSERT INTO quest_detall VALUES (17, 2, 17, 2);
INSERT INTO quest_detall VALUES (18, 2, 18, 3);
INSERT INTO quest_detall VALUES (19, 2, 19, 4);
INSERT INTO quest_detall VALUES (20, 2, 20, 5);
INSERT INTO quest_detall VALUES (21, 2, 21, 6);
INSERT INTO quest_detall VALUES (22, 2, 22, 7);
INSERT INTO quest_detall VALUES (23, 2, 23, 8);
INSERT INTO quest_detall VALUES (24, 2, 24, 9);
INSERT INTO quest_detall VALUES (25, 2, 25, 10);
INSERT INTO quest_detall VALUES (26, 2, 26, 11);
INSERT INTO quest_detall VALUES (27, 2, 27, 12);
INSERT INTO quest_detall VALUES (28, 2, 28, 13);
INSERT INTO quest_detall VALUES (29, 2, 29, 14);
INSERT INTO quest_detall VALUES (30, 2, 30, 15);

INSERT INTO quest_detall VALUES (31, 3, 31, 1);
INSERT INTO quest_detall VALUES (32, 3, 32, 2);
INSERT INTO quest_detall VALUES (33, 3, 33, 3);
INSERT INTO quest_detall VALUES (34, 3, 34, 4);
INSERT INTO quest_detall VALUES (35, 3, 35, 5);
INSERT INTO quest_detall VALUES (36, 3, 36, 6);
INSERT INTO quest_detall VALUES (37, 3, 37, 7);
INSERT INTO quest_detall VALUES (38, 3, 38, 8);
INSERT INTO quest_detall VALUES (39, 3, 39, 9);
INSERT INTO quest_detall VALUES (40, 3, 40, 10);
INSERT INTO quest_detall VALUES (41, 3, 41, 11);
INSERT INTO quest_detall VALUES (42, 3, 42, 12);
INSERT INTO quest_detall VALUES (43, 3, 43, 13);
INSERT INTO quest_detall VALUES (44, 3, 44, 14);
INSERT INTO quest_detall VALUES (45, 3, 45, 15);
INSERT INTO quest_detall VALUES (46, 3, 46, 16);

INSERT INTO quest_detall VALUES (47, 4, 47, 1);
INSERT INTO quest_detall VALUES (48, 4, 48, 2);
INSERT INTO quest_detall VALUES (49, 4, 49, 3);
INSERT INTO quest_detall VALUES (50, 4, 50, 4);
INSERT INTO quest_detall VALUES (51, 4, 51, 5);
INSERT INTO quest_detall VALUES (52, 4, 52, 6);
INSERT INTO quest_detall VALUES (53, 4, 53, 7);
INSERT INTO quest_detall VALUES (54, 4, 54, 8);

INSERT INTO quest_detall VALUES (55, 5, 55, 1);
INSERT INTO quest_detall VALUES (56, 5, 56, 2);
INSERT INTO quest_detall VALUES (57, 5, 57, 3);
INSERT INTO quest_detall VALUES (58, 5, 58, 4);
INSERT INTO quest_detall VALUES (59, 5, 59, 5);
INSERT INTO quest_detall VALUES (60, 5, 60, 6);
INSERT INTO quest_detall VALUES (61, 5, 61, 7);
INSERT INTO quest_detall VALUES (62, 5, 62, 8);
INSERT INTO quest_detall VALUES (63, 5, 63, 9);
INSERT INTO quest_detall VALUES (64, 5, 64, 10);
INSERT INTO quest_detall VALUES (65, 5, 65, 11);
INSERT INTO quest_detall VALUES (66, 5, 66, 12);
INSERT INTO quest_detall VALUES (67, 5, 67, 13);

INSERT INTO quest_detall VALUES (68, 6, 68, 1);
INSERT INTO quest_detall VALUES (69, 6, 69, 2);
INSERT INTO quest_detall VALUES (70, 6, 70, 3);
INSERT INTO quest_detall VALUES (71, 6, 71, 4);
INSERT INTO quest_detall VALUES (72, 6, 72, 5);
INSERT INTO quest_detall VALUES (73, 6, 73, 6);
INSERT INTO quest_detall VALUES (74, 6, 74, 7);

INSERT INTO quest_detall VALUES (75, 7, 75, 1);
INSERT INTO quest_detall VALUES (76, 7, 76, 2);
INSERT INTO quest_detall VALUES (77, 7, 77, 3);
INSERT INTO quest_detall VALUES (78, 7, 78, 4);
INSERT INTO quest_detall VALUES (79, 7, 79, 5);
INSERT INTO quest_detall VALUES (80, 7, 80, 6);
INSERT INTO quest_detall VALUES (81, 7, 81, 7);
INSERT INTO quest_detall VALUES (82, 7, 82, 8);
INSERT INTO quest_detall VALUES (83, 7, 83, 9);
INSERT INTO quest_detall VALUES (84, 7, 84, 10);
INSERT INTO quest_detall VALUES (85, 7, 85, 11);
INSERT INTO quest_detall VALUES (86, 7, 86, 12);
INSERT INTO quest_detall VALUES (87, 7, 87, 13);

INSERT INTO quest_detall VALUES (88, 8, 88, 1);
INSERT INTO quest_detall VALUES (89, 8, 89, 2);
INSERT INTO quest_detall VALUES (90, 8, 90, 3);
INSERT INTO quest_detall VALUES (91, 8, 91, 4);
INSERT INTO quest_detall VALUES (92, 8, 92, 5);
INSERT INTO quest_detall VALUES (93, 8, 93, 6);

INSERT INTO quest_detall VALUES (94, 9, 94, 1);
INSERT INTO quest_detall VALUES (95, 9, 95, 2);
INSERT INTO quest_detall VALUES (96, 9, 96, 3);
INSERT INTO quest_detall VALUES (97, 9, 97, 4);
INSERT INTO quest_detall VALUES (98, 9, 98, 5);
INSERT INTO quest_detall VALUES (99, 9, 99, 6);
INSERT INTO quest_detall VALUES (100, 9, 100, 7);
INSERT INTO quest_detall VALUES (101, 9, 101, 8);
INSERT INTO quest_detall VALUES (102, 9, 102, 9);
INSERT INTO quest_detall VALUES (103, 9, 103, 10);
INSERT INTO quest_detall VALUES (104, 9, 104, 11);
INSERT INTO quest_detall VALUES (105, 9, 105, 12);
INSERT INTO quest_detall VALUES (106, 9, 106, 13);

INSERT INTO quest_detall VALUES (107, 10, 107, 1);
INSERT INTO quest_detall VALUES (108, 10, 108, 2);
INSERT INTO quest_detall VALUES (109, 10, 109, 3);
INSERT INTO quest_detall VALUES (110, 10, 110, 4);
INSERT INTO quest_detall VALUES (111, 10, 111, 5);
INSERT INTO quest_detall VALUES (112, 10, 112, 6);
INSERT INTO quest_detall VALUES (113, 10, 113, 7);
INSERT INTO quest_detall VALUES (114, 10, 114, 8);
INSERT INTO quest_detall VALUES (115, 10, 115, 9);
INSERT INTO quest_detall VALUES (116, 10, 116, 10);
INSERT INTO quest_detall VALUES (117, 10, 117, 11);
INSERT INTO quest_detall VALUES (118, 10, 118, 12);
INSERT INTO quest_detall VALUES (119, 10, 119, 13);

INSERT INTO quest_detall VALUES (120, 11, 120, 1);
INSERT INTO quest_detall VALUES (121, 11, 121, 2);
INSERT INTO quest_detall VALUES (122, 11, 122, 3);
INSERT INTO quest_detall VALUES (123, 11, 123, 4);
INSERT INTO quest_detall VALUES (124, 11, 124, 5);
INSERT INTO quest_detall VALUES (125, 11, 125, 6);
INSERT INTO quest_detall VALUES (126, 11, 126, 7);
INSERT INTO quest_detall VALUES (127, 11, 127, 8);
INSERT INTO quest_detall VALUES (128, 11, 128, 9);
INSERT INTO quest_detall VALUES (129, 11, 129, 10);

INSERT INTO quest_detall VALUES (130, 12, 130, 1);
INSERT INTO quest_detall VALUES (131, 12, 131, 2);
INSERT INTO quest_detall VALUES (132, 12, 132, 3);
INSERT INTO quest_detall VALUES (133, 12, 133, 4);
INSERT INTO quest_detall VALUES (134, 12, 134, 5);
INSERT INTO quest_detall VALUES (135, 12, 135, 6);
INSERT INTO quest_detall VALUES (136, 12, 136, 7);
INSERT INTO quest_detall VALUES (137, 12, 137, 8);
INSERT INTO quest_detall VALUES (138, 12, 138, 9);
INSERT INTO quest_detall VALUES (139, 12, 139, 10);
INSERT INTO quest_detall VALUES (140, 12, 140, 11);
INSERT INTO quest_detall VALUES (141, 12, 141, 12);
INSERT INTO quest_detall VALUES (142, 12, 142, 13);

INSERT INTO quest_detall VALUES (143, 13, 143, 1);
INSERT INTO quest_detall VALUES (144, 13, 144, 2);
INSERT INTO quest_detall VALUES (145, 13, 145, 3);
INSERT INTO quest_detall VALUES (146, 13, 146, 4);
INSERT INTO quest_detall VALUES (147, 13, 147, 5);
INSERT INTO quest_detall VALUES (148, 13, 148, 6);
INSERT INTO quest_detall VALUES (149, 13, 149, 7);
INSERT INTO quest_detall VALUES (150, 13, 150, 8);
INSERT INTO quest_detall VALUES (151, 13, 151, 9);
INSERT INTO quest_detall VALUES (152, 13, 152, 10);

INSERT INTO quest_detall VALUES (153, 14, 153, 1);
INSERT INTO quest_detall VALUES (154, 14, 154, 2);
INSERT INTO quest_detall VALUES (155, 14, 155, 3);
INSERT INTO quest_detall VALUES (156, 14, 156, 4);
INSERT INTO quest_detall VALUES (157, 14, 157, 5);
INSERT INTO quest_detall VALUES (158, 14, 158, 6);
INSERT INTO quest_detall VALUES (159, 14, 159, 7);
INSERT INTO quest_detall VALUES (160, 14, 160, 8);
INSERT INTO quest_detall VALUES (161, 14, 161, 9);
INSERT INTO quest_detall VALUES (162, 14, 162, 10);
INSERT INTO quest_detall VALUES (163, 14, 163, 11);

INSERT INTO quest_detall VALUES (164, 15, 164, 1);
INSERT INTO quest_detall VALUES (165, 15, 165, 2);
INSERT INTO quest_detall VALUES (166, 15, 166, 3);
INSERT INTO quest_detall VALUES (167, 15, 167, 4);
INSERT INTO quest_detall VALUES (168, 15, 168, 5);
INSERT INTO quest_detall VALUES (169, 15, 169, 6);
INSERT INTO quest_detall VALUES (170, 15, 170, 7);
INSERT INTO quest_detall VALUES (171, 15, 171, 8);
INSERT INTO quest_detall VALUES (172, 15, 172, 9);
INSERT INTO quest_detall VALUES (173, 15, 173, 10);
INSERT INTO quest_detall VALUES (174, 15, 174, 11);

INSERT INTO quest_detall VALUES (175, 16, 175, 1);
INSERT INTO quest_detall VALUES (176, 16, 176, 2);
INSERT INTO quest_detall VALUES (177, 16, 177, 3);
INSERT INTO quest_detall VALUES (178, 16, 178, 4);
INSERT INTO quest_detall VALUES (179, 16, 179, 5);
INSERT INTO quest_detall VALUES (180, 16, 180, 6);
INSERT INTO quest_detall VALUES (181, 16, 181, 7);
INSERT INTO quest_detall VALUES (182, 16, 182, 8);
INSERT INTO quest_detall VALUES (183, 16, 183, 9);
INSERT INTO quest_detall VALUES (184, 16, 184, 10);
INSERT INTO quest_detall VALUES (185, 16, 185, 11);
INSERT INTO quest_detall VALUES (186, 16, 186, 12);
INSERT INTO quest_detall VALUES (187, 16, 187, 13);
INSERT INTO quest_detall VALUES (188, 16, 188, 14);
INSERT INTO quest_detall VALUES (189, 16, 189, 15);
INSERT INTO quest_detall VALUES (190, 16, 190, 16);
INSERT INTO quest_detall VALUES (191, 16, 191, 17);

INSERT INTO quest_detall VALUES (192, 17, 192, 1);
INSERT INTO quest_detall VALUES (193, 17, 192, 2);
INSERT INTO quest_detall VALUES (194, 17, 194, 3);
INSERT INTO quest_detall VALUES (195, 17, 195, 4);
INSERT INTO quest_detall VALUES (196, 17, 196, 5);
INSERT INTO quest_detall VALUES (197, 17, 197, 6);
INSERT INTO quest_detall VALUES (198, 17, 198, 7);
INSERT INTO quest_detall VALUES (199, 17, 199, 8);
INSERT INTO quest_detall VALUES (200, 17, 200, 9);
INSERT INTO quest_detall VALUES (201, 17, 201, 10);
INSERT INTO quest_detall VALUES (202, 17, 202, 11);
INSERT INTO quest_detall VALUES (203, 17, 203, 12);
INSERT INTO quest_detall VALUES (204, 17, 204, 13);
INSERT INTO quest_detall VALUES (205, 17, 205, 14);
INSERT INTO quest_detall VALUES (206, 17, 206, 15);
INSERT INTO quest_detall VALUES (207, 17, 207, 16);
INSERT INTO quest_detall VALUES (208, 17, 208, 17);

INSERT INTO quest_detall VALUES (209, 18, 209, 1);
INSERT INTO quest_detall VALUES (210, 18, 210, 2);
INSERT INTO quest_detall VALUES (211, 18, 211, 3);
INSERT INTO quest_detall VALUES (212, 18, 212, 4);
INSERT INTO quest_detall VALUES (213, 18, 213, 5);

INSERT INTO quest_detall VALUES (214, 19, 214, 1);
INSERT INTO quest_detall VALUES (215, 19, 215, 2);
INSERT INTO quest_detall VALUES (216, 19, 216, 3);
INSERT INTO quest_detall VALUES (217, 19, 217, 4);
INSERT INTO quest_detall VALUES (218, 19, 218, 5);
INSERT INTO quest_detall VALUES (219, 19, 219, 6);
INSERT INTO quest_detall VALUES (220, 19, 220, 7);
INSERT INTO quest_detall VALUES (221, 19, 221, 8);
INSERT INTO quest_detall VALUES (222, 19, 222, 9);
INSERT INTO quest_detall VALUES (223, 19, 223, 10);
INSERT INTO quest_detall VALUES (224, 19, 224, 11);
INSERT INTO quest_detall VALUES (225, 19, 225, 12);
INSERT INTO quest_detall VALUES (226, 19, 226, 13);
INSERT INTO quest_detall VALUES (227, 19, 227, 14);

INSERT INTO quest_detall VALUES (228, 20, 4, 1);
INSERT INTO quest_detall VALUES (229, 20, 12, 2);
INSERT INTO quest_detall VALUES (230, 20, 21, 3);
INSERT INTO quest_detall VALUES (231, 20, 143, 4);
INSERT INTO quest_detall VALUES (232, 20, 150, 5);
INSERT INTO quest_detall VALUES (233, 20, 28, 6);
INSERT INTO quest_detall VALUES (234, 20, 35, 7);
INSERT INTO quest_detall VALUES (235, 20, 43, 8);
INSERT INTO quest_detall VALUES (236, 20, 70, 9);
INSERT INTO quest_detall VALUES (237, 20, 74, 10);
INSERT INTO quest_detall VALUES (238, 20, 77, 11);
INSERT INTO quest_detall VALUES (239, 20, 205, 12);
INSERT INTO quest_detall VALUES (240, 20, 211, 13);
INSERT INTO quest_detall VALUES (241, 20, 84, 14);
INSERT INTO quest_detall VALUES (242, 20, 90, 15);
INSERT INTO quest_detall VALUES (243, 20, 97, 16);
INSERT INTO quest_detall VALUES (244, 20, 127, 17);
INSERT INTO quest_detall VALUES (245, 20, 132, 18);

INSERT INTO quest_detall VALUES (246, 21, 136, 1);
INSERT INTO quest_detall VALUES (247, 21, 140, 2);
INSERT INTO quest_detall VALUES (248, 21, 154, 3);
INSERT INTO quest_detall VALUES (249, 21, 156, 4);
INSERT INTO quest_detall VALUES (250, 21, 159, 5);
INSERT INTO quest_detall VALUES (251, 21, 162, 6);
INSERT INTO quest_detall VALUES (252, 21, 166, 7);
INSERT INTO quest_detall VALUES (253, 21, 175, 8);
INSERT INTO quest_detall VALUES (254, 21, 49, 9);
INSERT INTO quest_detall VALUES (255, 21, 56, 10);
INSERT INTO quest_detall VALUES (256, 21, 66, 11);
INSERT INTO quest_detall VALUES (257, 21, 179, 12);
INSERT INTO quest_detall VALUES (258, 21, 187, 13);
INSERT INTO quest_detall VALUES (259, 21, 196, 14);
INSERT INTO quest_detall VALUES (260, 21, 216, 15);
INSERT INTO quest_detall VALUES (261, 21, 224, 16);
INSERT INTO quest_detall VALUES (262, 21, 104, 17);
INSERT INTO quest_detall VALUES (263, 21, 122, 18);

INSERT INTO quest_detall VALUES (264, 22, 228, 1);
INSERT INTO quest_detall VALUES (265, 22, 230, 2);
INSERT INTO quest_detall VALUES (266, 22, 232, 3);
INSERT INTO quest_detall VALUES (267, 22, 234, 4);
INSERT INTO quest_detall VALUES (268, 22, 236, 5);
INSERT INTO quest_detall VALUES (269, 22, 238, 6);
INSERT INTO quest_detall VALUES (270, 22, 240, 7);
INSERT INTO quest_detall VALUES (271, 22, 242, 8);
INSERT INTO quest_detall VALUES (272, 22, 244, 9);
INSERT INTO quest_detall VALUES (273, 22, 246, 10);
INSERT INTO quest_detall VALUES (274, 22, 248, 11);
INSERT INTO quest_detall VALUES (275, 22, 250, 12);
INSERT INTO quest_detall VALUES (276, 22, 252, 13);
INSERT INTO quest_detall VALUES (277, 22, 254, 14);
INSERT INTO quest_detall VALUES (278, 22, 256, 15);
INSERT INTO quest_detall VALUES (279, 22, 258, 16);
INSERT INTO quest_detall VALUES (280, 22, 260, 17);

INSERT INTO quest_detall VALUES (298, 23, 229, 1);
INSERT INTO quest_detall VALUES (299, 23, 231, 2);
INSERT INTO quest_detall VALUES (300, 23, 233, 3);
INSERT INTO quest_detall VALUES (301, 23, 235, 4);
INSERT INTO quest_detall VALUES (302, 23, 237, 5);
INSERT INTO quest_detall VALUES (303, 23, 239, 6);
INSERT INTO quest_detall VALUES (304, 23, 241, 7);
INSERT INTO quest_detall VALUES (305, 23, 243, 8);
INSERT INTO quest_detall VALUES (306, 23, 245, 9);
INSERT INTO quest_detall VALUES (307, 23, 247, 10);
INSERT INTO quest_detall VALUES (308, 23, 249, 11);
INSERT INTO quest_detall VALUES (309, 23, 251, 12);
INSERT INTO quest_detall VALUES (310, 23, 253, 13);
INSERT INTO quest_detall VALUES (311, 23, 255, 14);
INSERT INTO quest_detall VALUES (312, 23, 257, 15);
INSERT INTO quest_detall VALUES (313, 23, 259, 16);
INSERT INTO quest_detall VALUES (314, 23, 261, 17);

INSERT INTO quest_detall VALUES (281, 24, 262, 1);
INSERT INTO quest_detall VALUES (282, 24, 264, 2);
INSERT INTO quest_detall VALUES (283, 24, 266, 3);
INSERT INTO quest_detall VALUES (284, 24, 268, 4);
INSERT INTO quest_detall VALUES (285, 24, 270, 5);
INSERT INTO quest_detall VALUES (286, 24, 272, 6);
INSERT INTO quest_detall VALUES (287, 24, 274, 7);
INSERT INTO quest_detall VALUES (288, 24, 276, 8);
INSERT INTO quest_detall VALUES (289, 24, 278, 9);
INSERT INTO quest_detall VALUES (290, 24, 280, 10);
INSERT INTO quest_detall VALUES (291, 24, 282, 11);
INSERT INTO quest_detall VALUES (292, 24, 284, 12);
INSERT INTO quest_detall VALUES (293, 24, 286, 13);
INSERT INTO quest_detall VALUES (294, 24, 288, 14);
INSERT INTO quest_detall VALUES (295, 24, 290, 15);
INSERT INTO quest_detall VALUES (296, 24, 292, 16);
INSERT INTO quest_detall VALUES (297, 24, 294, 17);

INSERT INTO quest_detall VALUES (315, 25, 263, 1);
INSERT INTO quest_detall VALUES (316, 25, 265, 2);
INSERT INTO quest_detall VALUES (317, 25, 267, 3);
INSERT INTO quest_detall VALUES (318, 25, 269, 4);
INSERT INTO quest_detall VALUES (319, 25, 271, 5);
INSERT INTO quest_detall VALUES (320, 25, 273, 6);
INSERT INTO quest_detall VALUES (321, 25, 275, 7);
INSERT INTO quest_detall VALUES (322, 25, 277, 8);
INSERT INTO quest_detall VALUES (323, 25, 279, 9);
INSERT INTO quest_detall VALUES (324, 25, 281, 10);
INSERT INTO quest_detall VALUES (325, 25, 283, 11);
INSERT INTO quest_detall VALUES (326, 25, 285, 12);
INSERT INTO quest_detall VALUES (327, 25, 287, 13);
INSERT INTO quest_detall VALUES (328, 25, 289, 14);
INSERT INTO quest_detall VALUES (329, 25, 291, 15);
INSERT INTO quest_detall VALUES (330, 25, 293, 16);
INSERT INTO quest_detall VALUES (331, 25, 295, 17);

INSERT INTO quest_detall VALUES (332, 26, 296, 1);
INSERT INTO quest_detall VALUES (333, 26, 298, 2);
INSERT INTO quest_detall VALUES (334, 26, 300, 3);
INSERT INTO quest_detall VALUES (335, 26, 302, 4);
INSERT INTO quest_detall VALUES (336, 26, 304, 5);
INSERT INTO quest_detall VALUES (337, 26, 306, 6);
INSERT INTO quest_detall VALUES (338, 26, 308, 7);
INSERT INTO quest_detall VALUES (339, 26, 310, 8);
INSERT INTO quest_detall VALUES (340, 26, 312, 9);
INSERT INTO quest_detall VALUES (341, 26, 314, 10);
INSERT INTO quest_detall VALUES (342, 26, 316, 11);
INSERT INTO quest_detall VALUES (343, 26, 318, 12);
INSERT INTO quest_detall VALUES (344, 26, 320, 13);
INSERT INTO quest_detall VALUES (345, 26, 322, 14);
INSERT INTO quest_detall VALUES (346, 26, 324, 15);
INSERT INTO quest_detall VALUES (347, 26, 326, 16);
INSERT INTO quest_detall VALUES (348, 26, 328, 17);

INSERT INTO quest_detall VALUES (366, 27, 297, 1);
INSERT INTO quest_detall VALUES (367, 27, 299, 2);
INSERT INTO quest_detall VALUES (368, 27, 301, 3);
INSERT INTO quest_detall VALUES (369, 27, 303, 4);
INSERT INTO quest_detall VALUES (370, 27, 305, 5);
INSERT INTO quest_detall VALUES (371, 27, 307, 6);
INSERT INTO quest_detall VALUES (372, 27, 309, 7);
INSERT INTO quest_detall VALUES (373, 27, 311, 8);
INSERT INTO quest_detall VALUES (374, 27, 313, 9);
INSERT INTO quest_detall VALUES (375, 27, 315, 10);
INSERT INTO quest_detall VALUES (376, 27, 317, 11);
INSERT INTO quest_detall VALUES (377, 27, 319, 12);
INSERT INTO quest_detall VALUES (378, 27, 321, 13);
INSERT INTO quest_detall VALUES (379, 27, 323, 14);
INSERT INTO quest_detall VALUES (380, 27, 325, 15);
INSERT INTO quest_detall VALUES (381, 27, 327, 16);
INSERT INTO quest_detall VALUES (382, 27, 329, 17);

INSERT INTO quest_detall VALUES (349, 28, 330, 1);
INSERT INTO quest_detall VALUES (350, 28, 332, 2);
INSERT INTO quest_detall VALUES (351, 28, 334, 3);
INSERT INTO quest_detall VALUES (352, 28, 336, 4);
INSERT INTO quest_detall VALUES (353, 28, 338, 5);
INSERT INTO quest_detall VALUES (354, 28, 340, 6);
INSERT INTO quest_detall VALUES (355, 28, 342, 7);
INSERT INTO quest_detall VALUES (356, 28, 344, 8);
INSERT INTO quest_detall VALUES (357, 28, 346, 9);
INSERT INTO quest_detall VALUES (358, 28, 348, 10);
INSERT INTO quest_detall VALUES (359, 28, 350, 11);
INSERT INTO quest_detall VALUES (360, 28, 352, 12);
INSERT INTO quest_detall VALUES (361, 28, 354, 13);
INSERT INTO quest_detall VALUES (362, 28, 356, 14);
INSERT INTO quest_detall VALUES (363, 28, 358, 15);
INSERT INTO quest_detall VALUES (364, 28, 360, 16);
INSERT INTO quest_detall VALUES (365, 28, 362, 17);

INSERT INTO quest_detall VALUES (383, 29, 331, 1);
INSERT INTO quest_detall VALUES (384, 29, 333, 2);
INSERT INTO quest_detall VALUES (385, 29, 335, 3);
INSERT INTO quest_detall VALUES (386, 29, 337, 4);
INSERT INTO quest_detall VALUES (387, 29, 339, 5);
INSERT INTO quest_detall VALUES (388, 29, 341, 6);
INSERT INTO quest_detall VALUES (389, 29, 343, 7);
INSERT INTO quest_detall VALUES (390, 29, 345, 8);
INSERT INTO quest_detall VALUES (391, 29, 347, 9);
INSERT INTO quest_detall VALUES (392, 29, 349, 10);
INSERT INTO quest_detall VALUES (393, 29, 351, 11);
INSERT INTO quest_detall VALUES (394, 29, 353, 12);
INSERT INTO quest_detall VALUES (395, 29, 355, 13);
INSERT INTO quest_detall VALUES (396, 29, 357, 14);
INSERT INTO quest_detall VALUES (397, 29, 359, 15);
INSERT INTO quest_detall VALUES (398, 29, 361, 16);
INSERT INTO quest_detall VALUES (399, 29, 363, 17);

INSERT INTO quest_detall VALUES (400, 30, 364, 1);
INSERT INTO quest_detall VALUES (401, 30, 365, 2);
INSERT INTO quest_detall VALUES (402, 30, 366, 3);
INSERT INTO quest_detall VALUES (403, 30, 367, 4);
INSERT INTO quest_detall VALUES (404, 30, 368, 5);
INSERT INTO quest_detall VALUES (405, 30, 369, 6);
INSERT INTO quest_detall VALUES (406, 30, 370, 7);
INSERT INTO quest_detall VALUES (407, 30, 371, 8);
INSERT INTO quest_detall VALUES (408, 30, 372, 9);
INSERT INTO quest_detall VALUES (409, 30, 373, 10);
INSERT INTO quest_detall VALUES (410, 30, 374, 11);
INSERT INTO quest_detall VALUES (411, 30, 375, 12);
INSERT INTO quest_detall VALUES (412, 30, 376, 13);

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

# 15/12/2021 (examen)
# qüestionaris que ha fet l'alumne
# select * from alumne_quest where id_alumne=8;

# respostes de l'alumne d'aquest qüestionaris:
/*
select questio, valor, resposta, solucio
from alumne a, alumne_quest aq, quest q, quest_detall qd, bd_questio bdq, alumne_quest_detall aqd
where a.id_alumne=aq.id_alumne and aq.id_quest=q.id_quest and
q.id_quest=qd.id_quest and bdq.id_bd_questio=qd.id_bd_questio and
aqd.id_quest_detall=qd.id_quest_detall and
aq.id_alumne_quest=aqd.id_alumne_quest and aq.id_alumne_quest=544;
*/

/*
Per veure l'activitat de l'alumne al llarg del temps (i per veure si ha repetit l'examen)
aquest alumne ha repetit l'examen (el 9 i el 10 és el mateix examen):
mysql> select * from alumne_quest where id_alumne=18;
+-----------------+-----------+----------+------------+------+
| id_alumne_quest | id_alumne | id_quest | dia        | nota |
+-----------------+-----------+----------+------------+------+
|             538 |        18 |        9 | 2021-12-15 | 3.85 |
|             566 |        18 |       10 | 2021-12-15 | 8.46 |
+-----------------+-----------+----------+------------+------+
*/

/*
Consulta per controlar com van els alumnes mentre estan fent un examen:
select id_alumne_quest,id_quest,dia,nom,cognoms,nota from alumne a inner join alumne_quest aq using(id_alumne)
where id_alumne>1 and id_quest>=22 order by id_alumne, id_quest, id_alumne_quest;
*/

/*
Per testejar una pregunta concreta:
delete from alumne_quest_detall;
delete from alumne_quest;
delete from quest_detall;
delete from quest;
delete from professor;
delete from alumne;
delete from bd_questio;

INSERT INTO bd_questio VALUES (1, 10, 'seleccionar el id, nom de tots els empleats limit 2', 1, 0,'SELECT employee_id, first_name FROM employees limit 2');
INSERT INTO bd_questio VALUES (1, 10, 'seleccionar el id, nom\nde tots els empleats limit 2', 1, 0,'SELECT employee_id, first_name\nFROM employees limit 2');
INSERT INTO alumne VALUES (1, 'Joan', 'Quintana', '1DAM', 'jquintana@jaumebalmes.net',1);
INSERT INTO professor VALUES (1, 'Joan', 'Quintana', '1DAM', 'jquintana@jaumebalmes.net');
INSERT INTO professor VALUES (2, 'Joan', 'Quintana', '1DAW', 'admin@jaumebalmes.net');
INSERT INTO quest VALUES (1, 'bàsic HR I', 1, '2021-11-17', 0, 1);
INSERT INTO quest_detall VALUES (1, 1, 1, 1);
*/
/*
o bé si només vull eliminar unes preguntes concretes:
delete from alumne_quest_detall where id_quest_detall>=153;
delete from alumne_quest where id_quest=14;
delete from quest_detall where id_quest_detall>=153;
delete from bd_questio_prepost where id_bd_questio>=153;
delete from bd_questio where id_bd_questio>=153;
delete from quest where id_quest=14;
*/


/*
USUARIS:

delete from alumne_quest_detall where id_quest_detall>=228;
delete from alumne_quest where id_quest=20;
delete from quest_detall where id_quest_detall>=228;
delete from bd_questio_prepost where id_bd_questio>=228;
delete from bd_questio where id_bd_questio>=228;
delete from quest where id_quest=20;

INSERT INTO quest VALUES (20, 'PROVA', 1, '2022-02-12', 0, 1);

INSERT INTO bd_questio VALUES (228, 9, 'Crear usuari pepet', 1, 2,'CREATE USER pepet@localhost IDENTIFIED BY ''keiL2lai''');
INSERT INTO bd_questio VALUES (229, 9, 'Eliminar usuari pepet', 1, 2,'DROP USER pepet@localhost');
INSERT INTO bd_questio VALUES (230, 9, 'Crear usuari pepet', 1, 2,'CREATE USER ''pepet''@''localhost'' IDENTIFIED BY ''keiL2lai''');
INSERT INTO bd_questio VALUES (231, 9, 'Eliminar usuari pepet', 1, 2,'DROP USER ''pepet''@''localhost''');
INSERT INTO bd_questio VALUES (232, 9, 'Donar permisos a l''usuari pepet per modificar el camp municipis.municipis', 1, 2,'GRANT UPDATE(municipi) ON municipis.municipis TO ''pepet''@''localhost''');

INSERT INTO bd_questio_prepost VALUES (228,1,'GRANT ALL ON municipis.* TO pepet@localhost','POST');
INSERT INTO bd_questio_prepost VALUES (228,2,'FLUSH PRIVILEGES','POST');
INSERT INTO bd_questio_prepost VALUES (228,3,'SHOW GRANTS FOR pepet@localhost','POST');
INSERT INTO bd_questio_prepost VALUES (228,4,'DROP USER pepet@localhost','POST');
INSERT INTO bd_questio_prepost VALUES (229,1,'CREATE USER pepet@localhost IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (229,2,'SHOW GRANTS FOR pepet@localhost','PRE');
INSERT INTO bd_questio_prepost VALUES (230,1,'GRANT ALL ON municipis.* TO ''pepet''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (230,2,'FLUSH PRIVILEGES','POST');
INSERT INTO bd_questio_prepost VALUES (230,3,'SHOW GRANTS FOR ''pepet''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (230,4,'DROP USER ''pepet''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (231,1,'CREATE USER ''pepet''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (231,2,'SHOW GRANTS FOR ''pepet''@''localhost''','PRE');
INSERT INTO bd_questio_prepost VALUES (232,1,'CREATE USER ''pepet''@''localhost'' IDENTIFIED BY ''keiL2lai''','PRE');
INSERT INTO bd_questio_prepost VALUES (232,2,'FLUSH PRIVILEGES','PRE');
INSERT INTO bd_questio_prepost VALUES (232,3,'FLUSH PRIVILEGES','POST');
INSERT INTO bd_questio_prepost VALUES (232,4,'SHOW GRANTS FOR ''pepet''@''localhost''','POST');
INSERT INTO bd_questio_prepost VALUES (232,5,'DROP USER ''pepet''@''localhost''','POST');

INSERT INTO quest_detall VALUES (228, 20, 228, 1);
INSERT INTO quest_detall VALUES (229, 20, 229, 2);
INSERT INTO quest_detall VALUES (230, 20, 230, 3);
INSERT INTO quest_detall VALUES (231, 20, 231, 4);
INSERT INTO quest_detall VALUES (232, 20, 232, 5);
*/

/*
PROCEDIMENTS:

delete from alumne_quest_detall where id_quest_detall>=228;
delete from alumne_quest where id_quest=20;
delete from quest_detall where id_quest_detall>=228;
delete from bd_questio_prepost where id_bd_questio>=228;
delete from bd_questio where id_bd_questio>=228;
delete from quest where id_quest=20;

INSERT INTO quest VALUES (20, 'PROVA', 1, '2022-02-12', 0, 1);

INSERT INTO bd_questio VALUES (228, 5, 'Crear el procediment GetCustomerLevel, amb un paràmetre d''entrada i un de sortida, que miri els clients que tinguin un crèdit superior a 50000, retornant ''PLATINUM'' o ''NO PLATINUM''', 1, 2,'CREATE PROCEDURE GetCustomerLevel(\n\tIN  pCustomerNumber INT,\n\tOUT pCustomerLevel  VARCHAR(20))\nBEGIN\n\tDECLARE credit DECIMAL DEFAULT 0;\n\tSELECT creditLimit\n\tINTO credit\n\tFROM customers\n\tWHERE customerNumber = pCustomerNumber;\n\tIF credit > 50000 THEN\n\t\tSET pCustomerLevel = ''PLATINUM'';\n\tELSE\n\t\tSET pCustomerLevel = ''NOT PLATINUM'';\n\tEND IF;\nEND');

INSERT INTO bd_questio_prepost VALUES (228,1,'CALL GetCustomerLevel(140,@level)','POST');
INSERT INTO bd_questio_prepost VALUES (228,2,'SELECT @level','POST');
INSERT INTO bd_questio_prepost VALUES (228,3,'CALL GetCustomerLevel(328,@level)','POST');
INSERT INTO bd_questio_prepost VALUES (228,4,'SELECT @level','POST');
INSERT INTO bd_questio_prepost VALUES (228,5,'CALL GetCustomerLevel(260,@level)','POST');
INSERT INTO bd_questio_prepost VALUES (228,6,'SELECT @level','POST');
INSERT INTO bd_questio_prepost VALUES (228,7,'CALL GetCustomerLevel(381,@level)','POST');
INSERT INTO bd_questio_prepost VALUES (228,8,'SELECT @level','POST');
INSERT INTO bd_questio_prepost VALUES (228,9,'CALL GetCustomerLevel(379,@level)','POST');
INSERT INTO bd_questio_prepost VALUES (228,10,'SELECT @level','POST');
INSERT INTO bd_questio_prepost VALUES (228,11,'DROP PROCEDURE GetCustomerLevel','POST');

INSERT INTO quest_detall VALUES (228, 20, 228, 1);

Per mirar els procedures que hi ha en una base de dades:
SHOW PROCEDURE STATUS WHERE Db = 'classicmodels';
</pre>
