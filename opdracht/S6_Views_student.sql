-- ------------------------------------------------------------------------
-- Data & Persistency
-- Opdracht S6: Views
--
-- (c) 2020 Hogeschool Utrecht
-- Tijmen Muller (tijmen.muller@hu.nl)
-- André Donk (andre.donk@hu.nl)
-- ------------------------------------------------------------------------


-- S6.1.
--
-- 1. Maak een view met de naam "deelnemers" waarmee je de volgende gegevens uit de tabellen inschrijvingen en uitvoering combineert:
--    inschrijvingen.cursist, inschrijvingen.cursus, inschrijvingen.begindatum, uitvoeringen.docent, uitvoeringen.locatie

CREATE VIEW deelnemers AS
SELECT i.cursist, i.cursus, i.begindatum, u.docent, u.locatie 
FROM inschrijvingen i
JOIN uitvoeringen u 
ON u.cursus = i.cursus 
AND u.begindatum= i.begindatum

-- 2. Gebruik de view in een query waarbij je de "deelnemers" view combineert met de "personeels" view (behandeld in de les):
    CREATE OR REPLACE VIEW personeel AS
	     SELECT mnr, voorl, naam as medewerker, afd, functie
      FROM medewerkers;


SELECT p.voorl, p.medewerker, p.functie, d.cursus, d.begindatum, d.locatie, 
       (SELECT voorl || ' ' || medewerker 
        FROM personeel 
        WHERE mnr = d.docent) AS docent
FROM deelnemers d
JOIN personeel p ON p.mnr = d.cursist;

-- 3. Is de view "deelnemers" updatable ? Waarom ?

-- de view is niet updatable omdat het data haalt uit uit twee verschillende tabellen
-- wat het lastig maakt om veranderingen in de vierw terug te koppelen aan de oorspronkelijke tabellen 

-- S6.2.
--
-- 1. Maak een view met de naam "dagcursussen". Deze view dient de gegevens op te halen: 
--      code, omschrijving en type uit de tabel curssussen met als voorwaarde dat de lengte = 1. Toon aan dat de view werkt. 

CREATE VIEW dagcursussen AS 
SELECT c.code, c.omschrijving, c.type 
FROM cursussen c
WHERE c.lengte = 1;

SELECT * from dagcursussen

-- 2. Maak een tweede view met de naam "daguitvoeringen". 
--    Deze view dient de uitvoeringsgegevens op te halen voor de "dagcurssussen" (gebruik ook de view "dagcursussen"). Toon aan dat de view werkt

CREATE OR REPLACE VIEW daguitvoeringen AS
SELECT u.cursus, u.begindatum, u.docent, u.locatie
FROM uitvoeringen u
JOIN dagcursussen d ON u.cursus = d.code;

SELECT * FROM daguitvoeringen;

-- 3. Verwijder de views en laat zien wat de verschillen zijn bij DROP view <viewnaam> CASCADE en bij DROP view <viewnaam> RESTRICT

-- DROP CASCADE dropt de dagcursussen tabel ook al depend de daguitvoeringen view hier nog op
-- bij DROP RESTRICT geeft de IDE een melding dat de view dagcursussen niet gedropt kan worden omdat de view dagcursussen hier nog op depend