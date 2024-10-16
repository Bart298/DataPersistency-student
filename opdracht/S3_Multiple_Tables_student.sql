-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S3: Multiple Tables
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
--
--
-- Opdracht: schrijf SQL-queries om onderstaande resultaten op te vragen,
-- aan te maken, verwijderen of aan te passen in de database van de
-- bedrijfscasus.
--
-- Codeer je uitwerking onder de regel 'DROP VIEW ...' (bij een SELECT)
-- of boven de regel 'ON CONFLICT DO NOTHING;' (bij een INSERT)
-- Je kunt deze eigen query selecteren en los uitvoeren, en wijzigen tot
-- je tevreden bent.
--
-- Vervolgens kun je je uitwerkingen testen door de testregels
-- (met [TEST] erachter) te activeren (haal hiervoor de commentaartekens
-- weg) en vervolgens het hele bestand uit te voeren. Hiervoor moet je de
-- testsuite in de database hebben geladen (bedrijf_postgresql_test.sql).
-- NB: niet alle opdrachten hebben testregels.
--
-- Lever je werk pas in op Canvas als alle tests slagen.
-- ------------------------------------------------------------------------


-- S3.1.
-- Produceer een overzicht van alle cursusuitvoeringen; geef de
-- code, de begindatum, de lengte en de naam van de docent.
DROP VIEW IF EXISTS s3_1; CREATE OR REPLACE VIEW s3_1 AS                                                     -- [TEST]

SELECT c.cursus, u.begindatum, c.lengte, m.naam 
FROM uitvoeringen u
JOIN medewerkers m ON u.docent = m.mnr
JOIN cursussen c ON u.cursus = c.code


-- S3.2.
-- Geef in twee kolommen naast elkaar de achternaam van elke cursist (`cursist`)
-- van alle S02-cursussen, met de achternaam van zijn cursusdocent (`docent`).
DROP VIEW IF EXISTS s3_2; CREATE OR REPLACE VIEW s3_2 AS                                                     -- [TEST]

SELECT cursist.naam AS cursist, docent.naam AS docent
FROM inschrijvingen i 
JOIN uitvoeringen u ON i.cursus = u.cursus AND i.begindatum = u.begindatum
JOIN medewerkers cursist ON  i.cursist = cursist.mnr
JOIN medewerkers docent ON u.docent = docent.mnr
WHERE u.cursus = 'S02'

-- S3.3.
-- Geef elke afdeling (`afdeling`) met de naam van het hoofd van die
-- afdeling (`hoofd`).

DROP VIEW IF EXISTS s3_3; CREATE OR REPLACE VIEW s3_3 AS                                                     -- [TEST]

SELECT a.naam AS afdeling , m.naam AS hoofd
FROM afdelingen a
JOIN medewerkers m ON a.hoofd = m.mnr

-- S3.4.
-- Geef de namen van alle medewerkers, de naam van hun afdeling (`afdeling`)
-- en de bijbehorende locatie.

DROP VIEW IF EXISTS s3_4; CREATE OR REPLACE VIEW s3_4 AS                                                     -- [TEST]

SELECT m.naam AS medewerker, a.naam AS afdeling, a.locatie 
FROM medewerkers m
JOIN afdelingen a ON m.afd= a.anr

-- S3.5.
-- Geef de namen van alle cursisten die staan ingeschreven voor de cursus S02 van 12 april 2019
DROP VIEW IF EXISTS s3_5; CREATE OR REPLACE VIEW s3_5 AS                                                     -- [TEST]

SELECT m.naam 
FROM inschrijvingen i  
JOIN medewerkers m ON i.cursist= m.mnr
WHERE i.begindatum = '2019-4-12'

-- S3.6.
-- Geef de namen van alle medewerkers en hun toelage.
DROP VIEW IF EXISTS s3_6; CREATE OR REPLACE VIEW s3_6 AS                                                     -- [TEST]

SELECT m.naam AS medewerker, s.toelage AS toelage
FROM medewerkers m
JOIN schalen s ON m.maandsal >= s.ondergrens AND m.maandsal <= s.bovengrens

-- -------------------------[ HU TESTRAAMWERK ]--------------------------------
-- Met onderstaande query kun je je code testen. Zie bovenaan dit bestand
-- voor uitleg.

SELECT * FROM test_select('S3.1') AS resultaat
UNION
SELECT * FROM test_select('S3.2') AS resultaat
UNION
SELECT * FROM test_select('S3.3') AS resultaat
UNION
SELECT * FROM test_select('S3.4') AS resultaat
UNION
SELECT * FROM test_select('S3.5') AS resultaat
UNION
SELECT * FROM test_select('S3.6') AS resultaat
ORDER BY resultaat;

SELECT m.naam AS medewerker, round(AVG(s.toelage), -1) AS toelage
FROM medewerkers m
JOIN schalen s ON m.maandsal >= s.ondergrens AND m.maandsal <= s.bovengrens
GROUP BY medewerker