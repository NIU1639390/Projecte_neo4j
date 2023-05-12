//Constraint habitatge
CREATE CONSTRAINT UniqueHab FOR (i:Habitatge) REQUIRE(i.id, i.Municipi, i.Any_Padro) IS UNIQUE

//Constraint individu
CREATE CONSTRAINT UniqueInd FOR (i:Individu) REQUIRE i.id IS UNIQUE

//Load Individus
LOAD CSV WITH HEADERS FROM "file:///INDIVIDUAL.csv" AS row
WITH toInteger(row.Year) AS year, toInteger(row.Id) AS id, row.name AS nom, row.surname AS cognom, row.second_surname AS scognom
MERGE (i:Individu{id:id})
    SET i.Year = year, i.name = nom, i.surname = cognom, i.second_surname = scognom
RETURN count(i)

//Load Habitatges
LOAD CSV WITH HEADERS FROM "file:///HABITATGES.csv" AS row
WITH toInteger(row.Any_Padro) AS year, toInteger(row.Id_Llar) AS id, row.Municipi AS municipi, row.Carrer AS carrer, toInteger(row.Numero) AS num
WHERE municipi <> "null" AND carrer <> "null" AND num <> "null"
MERGE (i:Habitatge{Municipi:municipi, id:id, Any_Padro:year})
    SET i.Carrer = carrer, i.Numero = num
RETURN count(i)

//Relacio Familia
LOAD CSV WITH HEADERS FROM "file:///FAMILIA.csv" AS row
WITH toInteger(row.ID_1) AS id_1, toInteger(row.ID_2) AS id_2, row.Relacio AS relacio, row.Relacio_Harmonitzada AS relacioh
MATCH (p1:Individu{id:id_1})
MATCH (p2:Individu{id:id_2})
MERGE (p1)-[rel:FAMILIA{Relacio:relacio, Relacio_Harmonitzada:relacioh}]->(p2)
RETURN count(rel)

//Relacio Same_As
LOAD CSV WITH HEADERS FROM "file:///SAME_AS.csv" AS row
WITH toInteger(row.Id_A) AS id_1, toInteger(row.Id_B) AS id_2
MATCH (p1:Individu{id:id_1})
MATCH (p2:Individu{id:id_2})
MERGE (p1)-[rel:SAME_AS]->(p2)
RETURN count(rel)

//Relacio Viu
LOAD CSV WITH HEADERS FROM "file:///VIU.csv" AS row
WITH toInteger(row.IND) AS individu, toInteger(row.Year) AS year, toInteger(row.HOUSE_ID) AS id_casa, row.Location AS municipi
MATCH (i:Individu{id:individu})
MATCH (h:Habitatge{id:id_casa, Municipi:municipi, Any_Padro:year})
MERGE (i)-[rel:VIU]->(h)
RETURN count(rel)
