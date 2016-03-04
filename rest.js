var mysql = require("mysql");
function REST_ROUTER(router,connection,md5) {
    var self = this;
    self.handleRoutes(router,connection,md5);
}

REST_ROUTER.prototype.handleRoutes= function(router,connection,md5) {

   router.get("/formStatusReport",function(req,res){

      console.log(req.query)

//query: { aggregator: 'sector_id', groupBy: 'STATUS' }

      var group_by_attribute = req.query.groupBy || "sector_id";

//      var group_by_attributeMapping = " (SELECT sectorId FROM Sector AS c WHERE c.id= sector_id)"

      var  group_by_attributeMapping= group_by_attribute;

    switch(req.query.groupBy || "sector_id") {
      case "jweek_id":
          group_by_attributeMapping = " (SELECT CONCAT(jweek_id, ' (' , SUBSTR(fromDate,1,10) , ' to ' , SUBSTR(toDate,1,10) , ')' ) FROM JWeek AS c WHERE c.id= jweek_id)"
          break;

      case "role_id":
          group_by_attributeMapping = " (SELECT name FROM Role AS c WHERE c.id= role_id)"
         break;

      case "scheduleUser_id":
          group_by_attributeMapping = " (SELECT (SELECT sectorId from Sector as e WHERE  sector_id = e.id ) FROM User_Sector AS c WHERE c.User_id= scheduleUser_id) AS sectorId,"+ 
                                      " (SELECT (SELECT tlPinId from TLPin as e WHERE  tlPin_id = e.id ) FROM User AS c WHERE c.id= scheduleUser_id) AS tlPinId ,"+
                                      " (SELECT CONCAT(name, '-' , displayName) FROM User AS c WHERE c.id= scheduleUser_id)"
          break;

        case "sector_id":
          group_by_attributeMapping = " (SELECT sectorId from Sector as e WHERE  sector_id = e.id )  AS sectorId, " + 
                                      " (SELECT (SELECT tlPinId from TLPin as e WHERE  tlPin_id = e.id )  FROM Sector AS c WHERE c.id= sector_id) AS tlPinId ,"+
                                      " (SELECT sectorId from Sector as e WHERE  sector_id = e.id )  "
          break;

        case "formToGenerate_id":
          group_by_attributeMapping = " (SELECT name FROM `Form` AS c WHERE c.id= formToGenerate_id)"
          break;        

        default:
          group_by_attributeMapping= group_by_attribute;
    }


    var startDate = req.query.startDate || "2015-01-01" ;

    var endDate = req.query.endDate || "2017-01-01" ;


    switch(req.query.aggregator) {
        case "STATUS":
        default:
          var disaggregation = "SUM( STATUS= 'ACTIVE' ) AS active,"+
                            "SUM( STATUS= 'CANCELED' ) AS cancelled,"+
                            "SUM( STATUS= 'DONE'  ) AS done,"+      
                            "((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage"; 
    }


      var query = "SELECT " + group_by_attributeMapping + " as group_by_attribute , " + disaggregation +  " FROM `Schedule` "+
                  "WHERE date>=\""+ startDate + "\" and date <=\""+ endDate + "\" GROUP BY " +  group_by_attribute;

      console.log(query);

      var table = ["Schedule"];
      query = mysql.format(query,table); 
      connection.query(query,function(err,rows){
            if(err) {
              console.log(err);
               res.json({"Error" : true, "Message" : "Error executing MySQL query"});
            } else {
                res.json({"Error" : false, 
                          "Message" : "Success", 
                          "ver": 0.1, 
                          "result" : rows, 
                          "groupByAttribute": group_by_attribute,
                          "disaggregation": disaggregation                         
                        });
            }
          }); 
      });

   router.get("/FormStatusCount",function(req,res){

      console.log(req.query)

      var group_by_attribute = req.query.groupBy || "jweek_id";

      var group_by_attributeMapping = " (SELECT CONCAT(jweek_id, ' (' , SUBSTR(fromDate,1,10) , ' to ' , SUBSTR(toDate,1,10) , ')' ) FROM JWeek AS c WHERE c.id= jweek_id)"


      var startDate = req.query.startDate || "2015-01-01" ;

      var endDate = req.query.endDate || "2017-01-01" ;


    switch(req.query.aggregator) {
        case "STATUS":
        default:
          var disaggregation =  "SUM( STATUS= 'DONE'  ) AS completed,"+   
                                "(SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')) AS scheduled";   
                               // "((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage"; 
    }


      var query = "SELECT "+ group_by_attributeMapping + " as time , " + 
                  disaggregation +  " FROM `Schedule` " +
                  "WHERE date>=\""+ startDate + "\" and date <=\""+ endDate + "\" GROUP BY " +  group_by_attribute;

      console.log(query);

      var table = ["Schedule"];
      query = mysql.format(query,table); 
      connection.query(query,function(err,rows){
            if(err) {
              console.log(err);
               res.json({"Error" : true, "Message" : "Error executing MySQL query"});
            } else {
                res.json({"Error" : false, 
                          "Message" : "Success", 
                          "ver": 0.1, 
                          "result" : rows, 
                 
                        });
            }
          }); 
      });


   router.get("/FormUnitDataCount",function(req,res){

      console.log(req.query)

      var group_by_attribute = req.query.groupBy || " YEAR(created_at), MONTH(created_at), DATE(created_at)";

      var group_by_attributeMapping = " DATE_FORMAT(created_at, '%Y-%m-%d') "; //" DATE(created_at)"; //" (SELECT CONCAT(jweek_id, ' (' , SUBSTR(fromDate,1,10) , ' to ' , SUBSTR(toDate,1,10) , ')' ) FROM JWeek AS c WHERE c.id= jweek_id)"

      var startDate = req.query.startDate || "2015-01-01" ;

      var endDate = req.query.endDate || "2017-01-01" ;


//Surveillance Consented (FDCENCONSENT=1)
//Eligible MWRAs (FDELIGIBLE = 1 from Census)
//Pregnancies Identified (FDPREGSTS= 1 - Count(FDBNFSTS=0))
//Enrollment Consented (FDPSRCONSENT=1)
//Live births (Sum of FDBNFLB)



// Census:
// Met (FDCENSTAT = 1)
// Not Met (FDCENSTAT=2)
// Refusal (Visit Status) (FDCENSTAT=6)
// Permanent Move (FDCENSTAT=7)
// Woman Died (FDCENSTAT=8)
// DMC (FDCENSTAT=999)
// Pending (Scheduled - COUNT(CENSUS Submissions))
// Consented (FDCENCONSENT = 1)
// Refused (FDCENCONSENT = 6)

// PSRF:
// Met (FDPSRSTS = 1)
// Not Met (FDPSRSTS =2)
// Menopausal or Wom / Hus Sterilized (Count where FDPSRSTS = 3, FDPSRSTS = 4, or FDPSRSTS = 44)
// Divorced / Separated (FDPSRSTS = 5)
// Refusal (Visit Status) (FDPSRSTS = 6)
// Permanent Move (FDPSRSTS=7)
// Woman Died (FDPSRSTS=8)
// Husband Died (FDPSRSTS = 88)
// DMC (FDPSRSTS=999)
// Pending (Scheduled - COUNT(PSRF Submissions))
// Consented (FDPSRCONSENT = 1)
// Refused (FDPSRCONSENT = 6)
//  Pregnancies Identified (FDPSRPREGSTS = 1)

// PVF:
// False Pregnancy Report (FDBNFSTS = 0)
// Met & Pregnant (FDBNFSTS = 1)
// Not Met (FDBNFSTS =2)
// Live births (FDBNFSTS = 3)
// Miscarriage / Stillbirth (FDBNFSTS = 4)
// Refusal (FDBNFSTS = 6)
// Permanent Move (FDBNFSTS=7)
// Woman Died before Birth (FDBNFSTS=8)
// Live Births (Sum of FDBNFLB)
// Child Deaths (FDBNFCHLDVITSTS = 0)
// Woman Deaths (FDBNFWOMVITSTS = 0)
// Pending (Scheduled - COUNT (PVF Submissions))

// ANCF1-4:
// Met & Pregnant (TLANCxREMSTS = 1)
// Not Met (TLANCxREMSTS =2)
// Live births (TLANCxREMSTS = 3)
// Miscarriage / Stillbirth (TLANCxREMSTS = 4)
// Refusal (TLANCxREMSTS = 6)
// Permanent Move (TLANCxREMSTS=7)
// Woman Died (TLANCxREMSTS=8)
// DMC Only (TLANCxREMSTS=999)
// Pending (Scheduled - COUNT (PVF Submissions))





    switch(req.query.aggregator) {
        default:
          var disaggregation =  "SUM(titleVar = 'FDCENCONSENT' AND valueVar=1) AS FDCENCONSENT_1,"+
                                "SUM(titleVar = 'FDELIGIBLE' AND valueVar=1) AS FDELIGIBLE_1,"+    
                                "SUM(titleVar = 'FDBNFSTS' AND valueVar=0) AS FDBNFSTS_0,"+    
                                "SUM(titleVar = 'FDPREGSTS' AND valueVar=1) AS FDPREGSTS_1,"+    
                                "SUM(titleVar = 'FDPSRCONSENT' AND valueVar=1) AS FDPSRCONSENT_1,"+    
                                "SUM(titleVar = 'FDBNFLB') AS FDBNFLB";   
                               // "((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage"; 
    }

    var titleVar = "('FDCENCONSENT', 'FDELIGIBLE','FDBNFSTS', 'FDPSRCONSENT', 'FDPREGSTS', 'FDBNFLB' )";


// QUICKER QUERY TO CALCULATE DATEWISE and titleVar 
var query =  "SELECT  CONCAT(DATE(created_at), '_', titleVar, '_', valueVar ) AS date_titleVar_Value,"+
              "CONCAT(titleVar, '_', valueVar ) AS titleVar_Value,"+
              "DATE_FORMAT(created_at, '%Y-%m-%d')  AS DATE, count(*) AS count "+
              "FROM `UnitData`"+
              "WHERE titleVar IN " + titleVar+
              "GROUP BY  CONCAT(DATE(created_at), titleVar, valueVar )"+
              " HAVING date>=\""+ startDate + "\" and date <=\""+ endDate + "\"" ;



  //    var query = "SELECT "+ group_by_attributeMapping + " as date , " + 
   //               disaggregation +  " FROM `UnitData` " +
    //                " GROUP BY " +  group_by_attribute + " HAVING date>=\""+ startDate + "\" and date <=\""+ endDate + "\"" ;

      console.log(query);

      var table = ["Schedule"];
      query = mysql.format(query,table); 
      connection.query(query,function(err,rows){
            if(err) {
              console.log(err);
               res.json({"Error" : true, "Message" : "Error executing MySQL query"});
            } else {
                res.json({"Error" : false, 
                          "Message" : "Success", 
                          "ver": 0.1, 
                          "result" : rows, 
                 
                        });
            }
          }); 
      });

// Get ranking based on status percentage - http://fellowtuts.com/mysql/query-to-obtain-rank-function-in-mysql/
// SELECT scheduleUser_id,  percentage, rank FROM
// (SELECT scheduleUser_id,  percentage,
// @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
// @incRank := @incRank + 1, 
// @prevRank := percentage
// FROM (
// SELECT  scheduleUser_id, ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage
// FROM `Schedule`
// GROUP BY scheduleUser_id
// ) a , (
// SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
// ) r 
// ORDER BY percentage) s



// Find Percentage for different 
// SELECT scheduleUser_id, 
// sum(percentage_1) AS sum_percentage_1,
// sum(percentage_6) AS sum_percentage_6,
// sum(percentage_29) AS sum_percentage_29,
// sum(percentage_30) AS sum_percentage_30,
// sum(percentage_31) AS sum_percentage_31,
// sum(percentage_32) AS sum_percentage_32,
// sum(percentage_anc) AS sum_percentage_anc,
// sum(percentage_vs29) AS sum_percentage_vs29,
// sum(percentage_vs43) AS sum_percentage_vs43
// FROM 
// (
// SELECT 
// #submission_By_User_and_form.*,
// scheduleUser_id,
// concat_user_formId, 
// IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
// IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
// IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
// IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
// IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
// IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
// IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
// IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
// IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
// FROM 
// (
// SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
// FROM `Schedule`
// GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
// ) submission_By_User_and_form
// )
//  submission_By_User_and_form_and_percentage
// GROUP BY scheduleUser_id

// Scheduling with highest given rank 1 and zero has NULL 
// SELECT scheduleUser_id,  percentage, IF(percentage=NULL, NULL, rank) AS rank  FROM
// (SELECT scheduleUser_id,  percentage,
// @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, 
// @incRank := @incRank + 1, 
// @prevRank := percentage
// FROM (
// SELECT  scheduleUser_id, ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage
// FROM `Schedule`
// GROUP BY scheduleUser_id
// ) a , (
// SELECT @curRank :=0, @prevRank := NULL, @incRank := 1
// ) r 
// ORDER BY percentage DESC) s




// Gives table before rankings
// SELECT submission_By_User_and_form_and_percentage_ranking.*
// FROM
// ( # submission_By_User_and_form_and_percentage starts
// SELECT scheduleUser_id, 
// sum(percentage_1) AS sum_percentage_1,
// sum(percentage_6) AS sum_percentage_6,
// sum(percentage_29) AS sum_percentage_29,
// sum(percentage_30) AS sum_percentage_30,
// sum(percentage_31) AS sum_percentage_31,
// sum(percentage_32) AS sum_percentage_32,
// sum(percentage_anc) AS sum_percentage_anc,
// sum(percentage_vs29) AS sum_percentage_vs29,
// sum(percentage_vs43) AS sum_percentage_vs43
// FROM 
// ( # submission_By_User_and_form table starts
// SELECT 
// #submission_By_User_and_form.*,
// scheduleUser_id,
// concat_user_formId, 
// IF(`formToGenerate_id`=1,percentage,NULL) AS percentage_1,
// IF(`formToGenerate_id`=6,percentage,NULL) AS percentage_6,
// IF(`formToGenerate_id`=29,percentage,NULL) AS percentage_29,
// IF(`formToGenerate_id`=30,percentage,NULL) AS percentage_30,
// IF(`formToGenerate_id`=31,percentage,NULL) AS percentage_31,
// IF(`formToGenerate_id`=32,percentage,NULL) AS percentage_32,
// IF(`formToGenerate_id` IN (35, 36, 37, 38), percentage,NULL) AS percentage_anc,
// IF(`formToGenerate_id` IN (40, 42, 44), percentage,NULL) AS percentage_vs29,
// IF(`formToGenerate_id` IN (41, 43, 45), percentage,NULL) AS percentage_vs43
// FROM 
// (
// SELECT  CONCAT(scheduleUser_id, "_", formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage 
// FROM `Schedule`
// GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)
// ) submission_By_User_and_form

// )
//  submission_By_User_and_form_and_percentage
// GROUP BY scheduleUser_id

// ) submission_By_User_and_form_and_percentage_ranking








  }//);

    // router.get("/users/:user_id",function(req,res){
    //     var query = "SELECT * FROM ?? WHERE ??=?";
    //     var table = ["user_login","user_id",req.params.user_id];
    //     query = mysql.format(query,table);
    //     connection.query(query,function(err,rows){
    //         if(err) {
    //             res.json({"Error" : true, "Message" : "Error executing MySQL query"});
    //         } else {
    //             res.json({"Error" : false, "Message" : "Success", "Users" : rows});
    //         }
    //     });
    // });

//}

module.exports = REST_ROUTER;