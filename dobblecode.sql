SELECT "Symbolname", COUNT("Symbolname") AS "Anzahl"
FROM "Match"
GROUP BY "Symbolname";

CREATE TABLE "Symbolhaeufigkeit" AS
SELECT "Symbolname", COUNT("Symbolname") AS "Anzahl"
FROM "Match"
GROUP BY "Symbolname";

CREATE TABLE "Symbole fehlende Karten" AS
SELECT "Symbolname", COUNT("Symbolname") AS "Anzahl"
FROM "Match"
GROUP BY "Symbolname"
HAVING COUNT("Symbolname") IN (6, 7);

CREATE TABLE "Symbole 7er" AS
SELECT *
FROM "Symbole fehlende Karten"
WHERE "Anzahl" = 7;

CREATE TABLE "Kombinationen" AS
SELECT
    A."Symbolname" AS "Symbol1",
    B."Symbolname" AS "Symbol2",
    C."Symbolname" AS "Symbol3",
    D."Symbolname" AS "Symbol4",
    E."Symbolname" AS "Symbol5",
    F."Symbolname" AS "Symbol6",
    G."Symbolname" AS "Symbol7"
FROM "Symbole 7er" A
JOIN "Symbole 7er" B ON A."Symbolname" < B."Symbolname"
JOIN "Symbole 7er" C ON B."Symbolname" < C."Symbolname"
JOIN "Symbole 7er" D ON C."Symbolname" < D."Symbolname"
JOIN "Symbole 7er" E ON D."Symbolname" < E."Symbolname"
JOIN "Symbole 7er" F ON E."Symbolname" < F."Symbolname"
JOIN "Symbole 7er" G ON F."Symbolname" < G."Symbolname";



ALTER TABLE "Kombinationen"
ADD COLUMN "Symbol8" TEXT;

UPDATE "Kombinationen"
SET "Symbol8" = 'Schneemann';

ALTER TABLE "Kombinationen"
ADD "KandidatenID" SERIAL;

CREATE TABLE "Kandidaten_Symbole" AS
SELECT
    "KandidatenID",
    unnest(ARRAY[
        "Symbol1",
        "Symbol2",
        "Symbol3",
        "Symbol4",
        "Symbol5",
        "Symbol6",
        "Symbol7",
        "Symbol8"
    ]) AS "Symbolname"
FROM "Kombinationen";


CREATE TABLE "Suche" AS
SELECT K."KandidatenID", M."Kartennummer", K."Symbolname"
FROM "Kandidaten_Symbole"K
JOIN "Match" M
ON K."Symbolname" = M."Symbolname";

CREATE TABLE "Überschneidungen" AS
SELECT
    "KandidatenID",
    "Kartennummer",
    COUNT(*) AS "GemeinsameSymbole"
FROM "Suche"
GROUP BY "KandidatenID", "Kartennummer";


CREATE TABLE "Lösung" AS 
SELECT "KandidatenID", COUNT(*) AS "AnzahlKarten", MAX("GemeinsameSymbole") AS "MaxGemeinsameSymbole" 
FROM "Überschneidungen"
GROUP BY "KandidatenID"
ORDER BY "MaxGemeinsameSymbole";


CREATE TABLE "dieRichtigen" AS
SELECT *
FROM "Lösung"
WHERE "KandidatenID"=188 OR "KandidatenID"=2063;

CREATE TABLE "dieRichtigenKombinationen" AS
SELECT *
FROM "Kombinationen"
WHERE "KandidatenID"=188 OR "KandidatenID"=2063;

CREATE TABLE "dieRichtigenKombinationen56" AS
SELECT
    56 AS "Kartennummer",
    unnest(ARRAY[
        "Symbol1",
        "Symbol2",
        "Symbol3",
        "Symbol4",
        "Symbol5",
        "Symbol6",
        "Symbol7",
        "Symbol8"
    ]) AS "Symbolname"
FROM "dieRichtigenKombinationen"
WHERE "KandidatenID" = 188;


CREATE TABLE "dieRichtigenKombinationen57" AS
SELECT
    57 AS "Kartennummer",
    unnest(ARRAY[
        "Symbol1",
        "Symbol2",
        "Symbol3",
        "Symbol4",
        "Symbol5",
        "Symbol6",
        "Symbol7",
        "Symbol8"
    ]) AS "Symbolname"
FROM "dieRichtigenKombinationen"
WHERE "KandidatenID" = 2063;


CREATE Table "Endergebnis"
AS
SELECT * FROM "Match"
UNION ALL
SELECT * FROM "dieRichtigenKombinationen56"
UNION ALL
SELECT * FROM "dieRichtigenKombinationen57";
