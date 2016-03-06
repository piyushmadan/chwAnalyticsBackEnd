
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

