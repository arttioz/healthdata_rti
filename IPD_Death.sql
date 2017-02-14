SELECT DEATH_IPD.*, SUM(admission.PRICE) as Price
FROM
admission,
(
Select diagnosis_ipd.PID, diagnosis_ipd.HOSPCODE, diagnosis_ipd.DIAGCODE, diagnosis_ipd.DATETIME_ADMIT
From 
diagnosis_ipd,
(SELECT DISTINCT PID, HOSPCODE 
FROM admission
WHERE admission.DISCHSTATUS = 9 ) AS DeathAdmid
WHERE 
diagnosis_ipd.PID = DeathAdmid.PID AND 
diagnosis_ipd.HOSPCODE = DeathAdmid.HOSPCODE AND
diagnosis_ipd.DIAGCODE BETWEEN "V0" and "V899" AND
diagnosis_ipd.DATETIME_ADMIT BETWEEN "2016-01-01" and "2016-01-31" ) AS DEATH_IPD
WHERE
admission.PID = DEATH_IPD.PID AND
admission.HOSPCODE = DEATH_IPD.HOSPCODE AND
admission.DATETIME_ADMIT BETWEEN "2016-01-01" and "2016-01-31" 
GROUP BY DEATH_IPD.PID
