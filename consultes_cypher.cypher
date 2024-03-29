//1
MATCH (p:Individu)-[:VIU]->(h:Habitatge)
WHERE p.Year = 1866 AND h.Municipi = "CR"
RETURN count(p) AS Num_habitants, collect(p.surname)

//2
MATCH (p:Individu)-[:VIU]->(h:Habitatge)
WHERE h.Municipi = "SFLL" AND p.surname <> "nan"
RETURN p.Year AS Year, count(p) AS Num_habitants, collect(DISTINCT p.surname) AS Cognoms

//3
MATCH (p:Individu)-[:VIU]->(h:Habitatge)
WHERE h.Municipi = "SFLL" AND p.Year > 1800 AND p.Year < 1845
RETURN count(p) AS Poblacio, p.Year AS Any_padro, collect(DISTINCT h.id) AS identificadors ORDER BY Any_padro

//4
MATCH (p:Individu)-[:VIU]->(h:Habitatge)<-[:VIU]-(p2:Individu)
WHERE p.Year = 1838 AND h.Municipi = "SFLL" AND p.name='rafel' and p.surname='marti'
RETURN p2,collect(p2)

//5
MATCH (p:Individu{name:"miguel", surname:"estape", second_surname:"bofill"})-[:SAME_AS]-(p2:Individu)
RETURN p2

//6
MATCH (p:Individu{name:"miguel", surname:"estape", second_surname:"bofill"})-[:SAME_AS]-(p2:Individu)
RETURN DISTINCT p2.name, collect(DISTINCT p2.surname), collect(DISTINCT p2.second_surname)

//7
MATCH (p:Individu{name:"benito", surname:"julivert"})-[r:%]->(p2:Individu)
RETURN p2.name, p2.surname, p2.second_surname, r.Relacio

//8
MATCH (p:Individu{name:"benito", surname:"julivert"})-[r:%]->(p2:Individu)
WHERE r.Relacio = "hijo" OR r.Relacio = "hija"
RETURN p2.name AS Nom, p2.surname AS Cognom, p2.second_surname AS Segon_Cognom, r.Relacio AS Relacio ORDER BY Nom

//9
MATCH (p:Individu)-[r:FAMILIA]-(p2:Individu)
RETURN collect(DISTINCT r.Relacio) AS Relacions_Familiars

//10
MATCH (h:Habitatge)
WHERE h.Numero <> "null" AND h.Carrer <> "null" AND h.Municipi = "SFLL"
WITH h.Carrer AS Carrer, h.Numero AS Numero, count(DISTINCT h.Any_Padro) AS total_padrons, collect(DISTINCT h.Any_Padro) AS anys_padro, collect(DISTINCT h.id) AS ids
RETURN Carrer, Numero, total_padrons, anys_padro, ids
ORDER BY total_padrons DESC
LIMIT 15

//11
MATCH (p:Individu)-[r:FAMILIA]-(p2:Individu)-[:VIU]-(h:Habitatge), (p)-[r2:FAMILIA]-(p)
WHERE r.Relacio IN ["hijo", "hija","filla", "fill"] AND r2.Relacio = "cabeza" 
WITH count(p2) AS Num_fills, p, h
WHERE Num_fills > 3 AND h.Municipi = "CR"
RETURN p.name AS Nom, p.surname AS Cognom, p.second_surname AS Segon_Cognom, Num_fills
ORDER BY Num_fills DESC
LIMIT 20

//12
MATCH (p:Individu)-[r:FAMILIA]-(p2:Individu)-[:VIU]-(h:Habitatge), (p)-[r2:FAMILIA]-(p)
WHERE r.Relacio IN ["hijo", "hija","filla", "fill"]  AND  h.Municipi = "SFLL" AND p.Year = 1881 AND r2.Relacio = "cabeza"
WITH count(p2) AS Num_fills
CALL{
    MATCH (p2)-[:VIU]->(h)
    RETURN count(DISTINCT h) AS Num_llars
}
RETURN Num_fills, Num_llars, toFloat(Num_fills/Num_llars) AS Mitjana_fills_per_habitatge

//13
MATCH (p:Individu)-[:VIU]->(h:Habitatge)
WHERE h.Municipi = "CR"
WITH h.Any_Padro AS padro, h.Carrer AS carrer
CALL{
    MATCH (p)-[:VIU]->(h)
    WITH count(p) AS num
    RETURN  min(num) AS min_habitants
}
RETURN DISTINCT padro, carrer, min_habitants
ORDER BY padro DESC
