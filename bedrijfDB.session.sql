SELECT p.voorl, p.medewerker, p.functie, d.cursus, d.begindatum, d.locatie, 
       (SELECT voorl || ' ' || medewerker 
        FROM personeel 
        WHERE mnr = d.docent) AS docent
FROM deelnemers d
JOIN personeel p ON p.mnr = d.cursist;