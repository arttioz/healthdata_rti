SELECT ACCIDENT_DEATH.PID , ACCIDENT_DEATH.HOSPCODE, ACCIDENT_DEATH.DIAGCODE,  ACCIDENT_DEATH.DATE_SERV,
person.CID, person.`NAME`, person.LNAME, person.sex, person.BIRTH , floor(datediff (DATE_SERV,BIRTH)/365) as age
FROM
((Select diagnosis_ipd.PID, diagnosis_ipd.HOSPCODE, diagnosis_ipd.DIAGCODE, diagnosis_ipd.DATETIME_ADMIT AS DATE_SERV
From 
diagnosis_ipd,
(SELECT DISTINCT PID, HOSPCODE 
FROM admission
WHERE admission.DISCHSTATUS = 8 or admission.DISCHSTATUS = 9 ) AS DeathAdmid
WHERE 
diagnosis_ipd.PID = DeathAdmid.PID AND 
diagnosis_ipd.HOSPCODE = DeathAdmid.HOSPCODE AND
diagnosis_ipd.DIAGCODE BETWEEN "V0" and "V899" AND
diagnosis_ipd.DATETIME_ADMIT BETWEEN "2016-03-01" and "2016-03-31" 
)
UNION
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
diagnosis_opd.DATE_SERV BETWEEN "2016-03-01" and "2016-03-31" 
)
UNION
(
Select death.Pid, death.HOSPCODE, death.CDEATH, death.DDEATH AS DATE_SERV
FROM 
death
WHERE
death.CDEATH BETWEEN "V0" and "V899" AND
death.DDEATH BETWEEN "2016-03-01" and "2016-03-31" 
)
) AS ACCIDENT_DEATH
INNER JOIN person
on ACCIDENT_DEATH.PID = person.PID AND
ACCIDENT_DEATH.HOSPCODE = person.HOSPCODE
GROUP BY PID, HOSPCODE