SELECT DEATH_OPD.*, SUM(service.PRICE) as Price
FROM
service,
(
Select diagnosis_opd.PID, diagnosis_opd.HOSPCODE, diagnosis_opd.DIAGCODE, diagnosis_opd.DATE_SERV
From 
diagnosis_opd,
(SELECT DISTINCT PID, HOSPCODE 
FROM service
WHERE service.TYPEOUT = 4 OR 
service.TYPEOUT = 5 OR 
service.TYPEOUT = 6) AS DeathService
WHERE 
diagnosis_opd.PID = DeathService.PID AND 
diagnosis_opd.HOSPCODE = DeathService.HOSPCODE AND
diagnosis_opd.DIAGCODE BETWEEN "V0" and "V899" AND
diagnosis_opd.DATE_SERV BETWEEN "2016-01-01" and "2016-01-31" 
) AS DEATH_OPD
WHERE
service.PID = DEATH_OPD.PID AND
service.HOSPCODE = DEATH_OPD.HOSPCODE AND
service.DATE_SERV BETWEEN "2016-01-01" and "2016-01-31" 
GROUP BY DEATH_OPD.PID
