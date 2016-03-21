
March 3 -- geting rank for single percentage, 
SELECT   IF(percentage>=1,rank,NULL) AS rank_1 , percentage AS percentage_1, 
s.scheduleUser_id AS scheduleUser_id 
FROM
(SELECT    r.*,
@curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, 
@prevRank := percentage,
a.*
FROM (
SELECT * , 
sum_percentage_1 AS percentage
FROM
( # submission_By_User_and_form_and_percentage starts
SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1,
sum(percentage_6) AS sum_percentage_6,
sum(percentage_29) AS sum_percentage_29,
sum(percentage_30) AS sum_percentage_30,
sum(percentage_31) AS sum_percentage_31,
sum(percentage_32) AS sum_percentage_32,
sum(percentage_anc) AS sum_percentage_anc,
sum(percentage_vs29) AS sum_percentage_vs29,
sum(percentage_vs43) AS sum_percentage_vs43
FROM 
( # submission_By_User_and_form table starts
SELECT 
#submission_By_User_and_form.*,
scheduleUser_id,
concat_user_formId, 
IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
  IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
  IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
  FROM 
  (
  SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
  FROM `Schedule`
  GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
  ) submission_By_User_and_form

  )
   submission_By_User_and_form_and_percentage
  GROUP BY scheduleUser_id

  ) submission_By_User_and_form_and_percentage_ranking
  
) a , (
	SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
) r 
ORDER BY percentage DESC) s











-- NOT VERY EFFICIENT WAY TO COMBINE TWO RANKING
SELECT * 
FROM 

( SELECT   IF(percentage>=1,rank,NULL) AS rank_1 , percentage AS percentage_1, 
s.scheduleUser_id AS scheduleUser_id 
FROM
(SELECT    r.*,
@curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, 
@prevRank := percentage,
a.*
FROM (
SELECT * , 
sum_percentage_1 AS percentage
FROM
( # submission_By_User_and_form_and_percentage starts
SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1,
sum(percentage_6) AS sum_percentage_6,
sum(percentage_29) AS sum_percentage_29,
sum(percentage_30) AS sum_percentage_30,
sum(percentage_31) AS sum_percentage_31,
sum(percentage_32) AS sum_percentage_32,
sum(percentage_anc) AS sum_percentage_anc,
sum(percentage_vs29) AS sum_percentage_vs29,
sum(percentage_vs43) AS sum_percentage_vs43
FROM 
( # submission_By_User_and_form table starts
SELECT 
#submission_By_User_and_form.*,
scheduleUser_id,
concat_user_formId, 
IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
  IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
  IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
  FROM 
  (
  SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
  FROM `Schedule`
  GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
  ) submission_By_User_and_form

  )
   submission_By_User_and_form_and_percentage
  GROUP BY scheduleUser_id

  ) submission_By_User_and_form_and_percentage_ranking
  
) a , (
  SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
) r 
ORDER BY percentage DESC) s


) a JOIN 

( SELECT   IF(percentage>=1,rank,NULL) AS rank_6 , percentage AS percentage_6, 
s.scheduleUser_id AS scheduleUser_id 
FROM
(SELECT    r.*,
@curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, 
@prevRank := percentage,
a.*
FROM (
SELECT * , 
sum_percentage_6 AS percentage
FROM
( # submission_By_User_and_form_and_percentage starts
SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1,
sum(percentage_6) AS sum_percentage_6,
sum(percentage_29) AS sum_percentage_29,
sum(percentage_30) AS sum_percentage_30,
sum(percentage_31) AS sum_percentage_31,
sum(percentage_32) AS sum_percentage_32,
sum(percentage_anc) AS sum_percentage_anc,
sum(percentage_vs29) AS sum_percentage_vs29,
sum(percentage_vs43) AS sum_percentage_vs43
FROM 
( # submission_By_User_and_form table starts
SELECT 
#submission_By_User_and_form.*,
scheduleUser_id,
concat_user_formId, 
IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
  IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
  IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
  FROM 
  (
  SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
  FROM `Schedule`
  GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
  ) submission_By_User_and_form

  )
   submission_By_User_and_form_and_percentage
  GROUP BY scheduleUser_id

  ) submission_By_User_and_form_and_percentage_ranking
  
) a , (
  SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
) r 
ORDER BY percentage DESC) s


) b

WHERE a.scheduleUser_id = b.scheduleUser_id 
















-- 3 INDICATORS COMBINED

SELECT * 
FROM 

( SELECT IF(percentage>=0,rank,NULL) AS rank_1 , percentage AS percentage_1,  ####
s.scheduleUser_id AS scheduleUser_id 
FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * , 
sum_percentage_1 AS percentage ###
FROM(SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1  ####
FROM (SELECT scheduleUser_id, 
IF(`formToGenerate_id`IN (1),percentage,NULL) AS percentage_1  #####
  FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule`GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s
) a JOIN 
( SELECT IF(percentage>=0,rank,NULL) AS rank_1 , percentage AS percentage_1,  ####
s.scheduleUser_id AS scheduleUser_id 
FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * , 
sum_percentage_1 AS percentage ###
FROM(SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1  ####
FROM (SELECT scheduleUser_id, 
IF(`formToGenerate_id` IN (1,6),percentage,NULL) AS percentage_1  #####
  FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule`GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s
) b JOIN
( SELECT IF(percentage>=0,rank,NULL) AS rank_1 , percentage AS percentage_1,  ####
s.scheduleUser_id AS scheduleUser_id 
FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * , 
sum_percentage_1 AS percentage ###
FROM(SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1  ####
FROM (SELECT scheduleUser_id, 
IF(`formToGenerate_id` IN (1),percentage,NULL) AS percentage_1  #####
  FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule`GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s
) c

WHERE a.scheduleUser_id = b.scheduleUser_id 
AND a.scheduleUser_id = c.scheduleUser_id




















Get ranking based on status percentage - http://fellowtuts.com/mysql/query-to-obtain-rank-function-in-mysql/
SELECT scheduleUser_id,  percentage, rank FROM
(SELECT scheduleUser_id,  percentage,
@curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, 
@prevRank := percentage
FROM (
SELECT  scheduleUser_id, ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage
FROM `Schedule`
GROUP BY scheduleUser_id
) a , (
SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
) r 
ORDER BY percentage) s



Find Percentage for different 
SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1,
sum(percentage_6) AS sum_percentage_6,
sum(percentage_29) AS sum_percentage_29,
sum(percentage_30) AS sum_percentage_30,
sum(percentage_31) AS sum_percentage_31,
sum(percentage_32) AS sum_percentage_32,
sum(percentage_anc) AS sum_percentage_anc,
sum(percentage_vs29) AS sum_percentage_vs29,
sum(percentage_vs43) AS sum_percentage_vs43
FROM 
(
SELECT 
#submission_By_User_and_form.*,
scheduleUser_id,
concat_user_formId, 
IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
FROM 
(
SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
FROM `Schedule`
GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
) submission_By_User_and_form
)
 submission_By_User_and_form_and_percentage
GROUP BY scheduleUser_id

Scheduling with highest given rank 1 and zero has NULL 
SELECT scheduleUser_id,  percentage, IF(percentage=NULL, NULL, rank) AS rank  FROM
(SELECT scheduleUser_id,  percentage,
@curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, 
@prevRank := percentage
FROM (
SELECT  scheduleUser_id, ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage
FROM `Schedule`
GROUP BY scheduleUser_id
) a , (
SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
) r 
ORDER BY percentage DESC) s




Gives table before rankings
SELECT submission_By_User_and_form_and_percentage_ranking.*
FROM
( # submission_By_User_and_form_and_percentage starts
SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1,
sum(percentage_6) AS sum_percentage_6,
sum(percentage_29) AS sum_percentage_29,
sum(percentage_30) AS sum_percentage_30,
sum(percentage_31) AS sum_percentage_31,
sum(percentage_32) AS sum_percentage_32,
sum(percentage_anc) AS sum_percentage_anc,
sum(percentage_vs29) AS sum_percentage_vs29,
sum(percentage_vs43) AS sum_percentage_vs43
FROM 
( # submission_By_User_and_form table starts
SELECT 
#submission_By_User_and_form.*,
scheduleUser_id,
concat_user_formId, 
IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
FROM 
(
SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
FROM `Schedule`
GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
) submission_By_User_and_form

)
 submission_By_User_and_form_and_percentage
GROUP BY scheduleUser_id

) submission_By_User_and_form_and_percentage_ranking




SELECT submission_By_User_and_form_and_percentage_ranking.*
FROM
( # submission_By_User_and_form_and_percentage starts
SELECT scheduleUser_id, 
sum(percentage_1) AS sum_percentage_1,
sum(percentage_6) AS sum_percentage_6,
sum(percentage_29) AS sum_percentage_29,
sum(percentage_30) AS sum_percentage_30,
sum(percentage_31) AS sum_percentage_31,
sum(percentage_32) AS sum_percentage_32,
sum(percentage_anc) AS sum_percentage_anc,
sum(percentage_vs29) AS sum_percentage_vs29,
sum(percentage_vs43) AS sum_percentage_vs43
FROM 
( # submission_By_User_and_form table starts
SELECT 
#submission_By_User_and_form.*,
scheduleUser_id,
concat_user_formId, 
IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
  IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
  IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
  FROM 
  (
  SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
  FROM `Schedule`
  GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
  ) submission_By_User_and_form

  )
   submission_By_User_and_form_and_percentage
  GROUP BY scheduleUser_id

  ) submission_By_User_and_form_and_percentage_ranking








----------------
#Indicator 1 completed


SELECT User.id AS scheduleUser_id , CONCAT(NAME, '-' , displayName) AS NAME , 
(SELECT (SELECT sectorId FROM Sector AS e WHERE  sectors_id = e.id ) FROM User_Sector AS c WHERE c.User_id= scheduleUser_id) AS sectorId,
(SELECT (SELECT tlPinId FROM TLPin AS e WHERE  tlPin_id = e.id ) FROM `User` AS c WHERE c.id= scheduleUser_id) AS tlPinId,
indicator_1.* 
FROM `User`
LEFT JOIN
(
select 
(IF(rank_one,rank_one,0)+ IF(rank_six,rank_six,0)+ IF(rank_tnine,rank_tnine,0)+ IF(rank_thirty,rank_thirty,0)+ IF(rank_thrity1,rank_thrity1,0)+ IF(rank_thrity2,rank_thrity2,0)+ IF(rank_anc,rank_anc,0)+ IF(rank_vs29,rank_vs29,0)+ IF(rank_vs43,rank_vs43,0) ) / (IF(rank_one,1,0)+ IF(rank_six,1,0)+ IF(rank_tnine,1,0)+ IF(rank_thirty,1,0)+ IF(rank_thrity1,1,0)+ IF(rank_thrity2,1,0)+ IF(rank_anc,1,0)+ IF(rank_vs29,1,0)+ IF(rank_vs43,1,0) ) AS cummulate_score_1,

IF(rank_one,rank_one,0)+ IF(rank_six,rank_six,0)+ IF(rank_tnine,rank_tnine,0)+ IF(rank_thirty,rank_thirty,0)+ IF(rank_thrity1,rank_thrity1,0)+ IF(rank_thrity2,rank_thrity2,0)+ IF(rank_anc,rank_anc,0)+ IF(rank_vs29,rank_vs29,0)+ IF(rank_vs43,rank_vs43,0) AS sum_rank_1,

IF(rank_one,1,0)+ IF(rank_six,1,0)+ IF(rank_tnine,1,0)+ IF(rank_thirty,1,0)+ IF(rank_thrity1,1,0)+ IF(rank_thrity2,1,0)+ IF(rank_anc,1,0)+ IF(rank_vs29,1,0)+ IF(rank_vs43,1,0) AS sum_rank_used_count_1,



one.scheduleUser_id AS scheduleUser_id, IF(percentage_one, CONCAT(rank_one, ' (' , percentage_one, '%)' )   , NULL) as rank_percentage_one, IF(percentage_six, CONCAT(rank_six, ' (' , percentage_six, '%)' )   , NULL) as rank_percentage_six, IF(percentage_tnine, CONCAT(rank_tnine, ' (' , percentage_tnine, '%)' )   , NULL) as rank_percentage_tnine, IF(percentage_thirty, CONCAT(rank_thirty, ' (' , percentage_thirty, '%)' )   , NULL) as rank_percentage_thirty, IF(percentage_thrity1, CONCAT(rank_thrity1, ' (' , percentage_thrity1, '%)' )   , NULL) as rank_percentage_thrity1, IF(percentage_thrity2, CONCAT(rank_thrity2, ' (' , percentage_thrity2, '%)' )   , NULL) as rank_percentage_thrity2, IF(percentage_anc, CONCAT(rank_anc, ' (' , percentage_anc, '%)' )   , NULL) as rank_percentage_anc, IF(percentage_vs29, CONCAT(rank_vs29, ' (' , percentage_vs29, '%)' )   , NULL) as rank_percentage_vs29, IF(percentage_vs43, CONCAT(rank_vs43, ' (' , percentage_vs43, '%)' )   , NULL) as rank_percentage_vs43 from ( SELECT IF(percentage>=0,rank,NULL) AS rank_one , percentage AS percentage_one,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_one AS percentage FROM(SELECT scheduleUser_id, sum(percentage_one) AS sum_percentage_one FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (1),percentage,NULL) AS percentage_one FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) one JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_six , percentage AS percentage_six,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_six AS percentage FROM(SELECT scheduleUser_id, sum(percentage_six) AS sum_percentage_six FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (6),percentage,NULL) AS percentage_six FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) six JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_tnine , percentage AS percentage_tnine,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_tnine AS percentage FROM(SELECT scheduleUser_id, sum(percentage_tnine) AS sum_percentage_tnine FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (29),percentage,NULL) AS percentage_tnine FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) tnine JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_thirty , percentage AS percentage_thirty,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_thirty AS percentage FROM(SELECT scheduleUser_id, sum(percentage_thirty) AS sum_percentage_thirty FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (30),percentage,NULL) AS percentage_thirty FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) thirty JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_thrity1 , percentage AS percentage_thrity1,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_thrity1 AS percentage FROM(SELECT scheduleUser_id, sum(percentage_thrity1) AS sum_percentage_thrity1 FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (31),percentage,NULL) AS percentage_thrity1 FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) thrity1 JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_thrity2 , percentage AS percentage_thrity2,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_thrity2 AS percentage FROM(SELECT scheduleUser_id, sum(percentage_thrity2) AS sum_percentage_thrity2 FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (32),percentage,NULL) AS percentage_thrity2 FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) thrity2 JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_anc , percentage AS percentage_anc,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_anc AS percentage FROM(SELECT scheduleUser_id, sum(percentage_anc) AS sum_percentage_anc FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (35,36,37,38),percentage,NULL) AS percentage_anc FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) anc JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_vs29 , percentage AS percentage_vs29,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_vs29 AS percentage FROM(SELECT scheduleUser_id, sum(percentage_vs29) AS sum_percentage_vs29 FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (40,42,44),percentage,NULL) AS percentage_vs29 FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) vs29 JOIN ( SELECT IF(percentage>=0,rank,NULL) AS rank_vs43 , percentage AS percentage_vs43,  s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,sum_percentage_vs43 AS percentage FROM(SELECT scheduleUser_id, sum(percentage_vs43) AS sum_percentage_vs43 FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (41,43,45),percentage,NULL) AS percentage_vs43 FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s) vs43 WHERE one.scheduleUser_id =six.scheduleUser_id AND one.scheduleUser_id =tnine.scheduleUser_id AND one.scheduleUser_id =thirty.scheduleUser_id AND one.scheduleUser_id =thrity1.scheduleUser_id AND one.scheduleUser_id =thrity2.scheduleUser_id AND one.scheduleUser_id =anc.scheduleUser_id AND one.scheduleUser_id =vs29.scheduleUser_id AND one.scheduleUser_id =vs43.scheduleUser_id





) indicator_1  

ON indicator_1.scheduleUser_id =  User.id
WHERE role_id=5















===================
Indicator 2 -- combined 3 for testing

/* Census Form:  Met & Eligible - FDCENSTAT=1 and FDELIGIBLE=1
PSRF:  Met & Pregnant - FDPSRSTS=1 and FDPSRPREGSTS=1
PVF: Live birth - FDBNFSTS=4

All other forms among Mets
ANC1: TLANC1REMSTS=1
ANC2: TLANC2REMSTS=1
ANC3: TLANC3REMSTS=1
ANC4: TLANC4REMSTS=1
PNC: TLPNCSTS=1
SES: SES_STATUS=1
VS29: (any)
VS43: (any */

SELECT * 
FROM 

( 


SELECT IF(avgCompletionTime>=0,rank,NULL) AS rank_2_1 , avgCompletionTime AS avgCompletionTime_2_1
, deviationFromMean, s.sender_id AS sender_id 
FROM (SELECT    r.*, @curRank := IF(@prevRank = avgCompletionTime, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, @prevRank := avgCompletionTime,a.* FROM (
SELECT CONCAT(sender_id, "_" , form_id) AS sender_form, sender_id, form_id, endTime,startTime, ROUND(AVG((endTime-startTime)),2 ) avgCompletionTime, ROUND(STDDEV(endTime-startTime),2) stddevCompletionTime,
 ROUND(AVG((endTime-startTime)) - (SELECT AVG((endTime-startTime)) FROM `Data` WHERE form_id IN (SELECT form_id FROM `UnitData`
WHERE  
(titleVar = "FDELIGIBLE" AND valueVar = 1) OR 
(titleVar = "FDCENSTAT" AND valueVar = 1) 
)
),2) deviationFromMean
FROM `Data` WHERE form_id IN 
(SELECT form_id FROM `UnitData`
WHERE 
(titleVar = "FDELIGIBLE" AND valueVar = 1) OR 
(titleVar = "FDCENSTAT" AND valueVar = 1) 

) GROUP BY CONCAT(sender_id, "_" , form_id)) a , 
(SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY ABS(deviationFromMean) ASC) s



) a JOIN 
( 


SELECT IF(avgCompletionTime>=0,rank,NULL) AS rank_2_1 , avgCompletionTime AS avgCompletionTime_2_1
, deviationFromMean, s.sender_id AS sender_id 
FROM (SELECT    r.*, @curRank := IF(@prevRank = avgCompletionTime, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, @prevRank := avgCompletionTime,a.* FROM (
SELECT CONCAT(sender_id, "_" , form_id) AS sender_form, sender_id, form_id, endTime,startTime, ROUND(AVG((endTime-startTime)),2 ) avgCompletionTime, ROUND(STDDEV(endTime-startTime),2) stddevCompletionTime,
 ROUND(AVG((endTime-startTime)) - (SELECT AVG((endTime-startTime)) FROM `Data` WHERE form_id IN (SELECT form_id FROM `UnitData`
WHERE  
(titleVar = "FDELIGIBLE" AND valueVar = 1) OR 
(titleVar = "FDCENSTAT" AND valueVar = 1) 
)
),2) deviationFromMean
FROM `Data` WHERE form_id IN 
(SELECT form_id FROM `UnitData`
WHERE 
(titleVar = "FDELIGIBLE" AND valueVar = 1) OR 
(titleVar = "FDCENSTAT" AND valueVar = 1) 

) GROUP BY CONCAT(sender_id, "_" , form_id)) a , 
(SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY ABS(deviationFromMean) ASC) s





) b JOIN



( 

SELECT IF(avgCompletionTime>=0,rank,NULL) AS rank_2_1 , avgCompletionTime AS avgCompletionTime_2_1
, deviationFromMean, s.sender_id AS sender_id 
FROM (SELECT    r.*, @curRank := IF(@prevRank = avgCompletionTime, @curRank, @incRank) AS rank, 
@incRank := @incRank + 1, @prevRank := avgCompletionTime,a.* FROM (
SELECT CONCAT(sender_id, "_" , form_id) AS sender_form, sender_id, form_id, endTime,startTime, ROUND(AVG((endTime-startTime)),2 ) avgCompletionTime, ROUND(STDDEV(endTime-startTime),2) stddevCompletionTime,
 ROUND(AVG((endTime-startTime)) - (SELECT AVG((endTime-startTime)) FROM `Data` WHERE form_id IN (SELECT form_id FROM `UnitData`
WHERE  
(titleVar = "FDELIGIBLE" AND valueVar = 1) OR 
(titleVar = "FDCENSTAT" AND valueVar = 1) 
)
),2) deviationFromMean
FROM `Data` WHERE form_id IN 
(SELECT form_id FROM `UnitData`
WHERE 
(titleVar = "FDELIGIBLE" AND valueVar = 1) OR 
(titleVar = "FDCENSTAT" AND valueVar = 1) 

) GROUP BY CONCAT(sender_id, "_" , form_id)) a , 
(SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY ABS(deviationFromMean) ASC) s


) c

WHERE a.sender_id = b.sender_id
AND a.sender_id = c.sender_id


