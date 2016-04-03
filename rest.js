var mysql = require("mysql");
var indicatorConfig = require("./indicatorConfig.js");

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

//Get array of values from an objects
//http://stackoverflow.com/questions/19590865/from-an-array-of-objects-extract-value-of-a-property-as-array
//Calculate rank of values extracted from object
//http://stackoverflow.com/questions/14834571/ranking-array-elements
  // Indicator 1,2,3 - GET 
  router.get("/CHWScoringIndicator",function(req,res){

      console.log(req.query)

      var group_by_attribute = req.query.groupBy || " YEAR(created_at), MONTH(created_at), DATE(created_at)";

      var group_by_attributeMapping = " DATE_FORMAT(created_at, '%Y-%m-%d') "; //" DATE(created_at)"; //" (SELECT CONCAT(jweek_id, ' (' , SUBSTR(fromDate,1,10) , ' to ' , SUBSTR(toDate,1,10) , ')' ) FROM JWeek AS c WHERE c.id= jweek_id)"

      var startDate = req.query.startDate || "2015-01-01" ;

      var endDate = req.query.endDate || "2017-01-01" ;


      console.log("req.query.indicator1:" + req.query.indicator1);
      console.log("req.query.indicator2:" + req.query.indicator2);
      console.log("req.query.indicator3:" + req.query.indicator3);

      req.query.indicator1 = parseInt(req.query.indicator1);
      req.query.indicator2 = parseInt(req.query.indicator2);
      req.query.indicator3 = parseInt(req.query.indicator3);


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
// var query =  "SELECT  CONCAT(DATE(created_at), '_', titleVar, '_', valueVar ) AS date_titleVar_Value,"+
//               "CONCAT(titleVar, '_', valueVar ) AS titleVar_Value,"+
//               "DATE_FORMAT(created_at, '%Y-%m-%d')  AS DATE, count(*) AS count "+
//               "FROM `UnitData`"+
//               "WHERE titleVar IN " + titleVar+
//               "GROUP BY  CONCAT(DATE(created_at), titleVar, valueVar )"+
//               " HAVING date>=\""+ startDate + "\" and date <=\""+ endDate + "\"" ;


 var indicator1Config = indicatorConfig.indicator1Config;
 var indicator2Config = indicatorConfig.indicator2Config;

 console.log(indicator1Config);
 console.log(indicator2Config);


// SELECT
// rank_one , rank_six , rank_tnine , rank_thirty, 
// IF(rank_one, rank_one, 0) + IF(rank_six, rank_six, 0) + IF(rank_tnine, rank_tnine, 0) + IF(rank_thirty, rank_thirty, 0) AS cummulative_rank,
// IF(rank_one, 1, 0) + IF(rank_six, 1, 0) + IF(rank_tnine, 1, 0) + IF(rank_thirty, 1, 0) AS total_rank_used,

// (IF(rank_one, rank_one, 0) + IF(rank_six, rank_six, 0) + IF(rank_tnine, rank_tnine, 0) + IF(rank_thirty, rank_thirty, 0) ) /
// (IF(rank_one, 1, 0) + IF(rank_six, 1, 0) + IF(rank_tnine, 1, 0) + IF(rank_thirty, 1, 0)) AS FINAL_RANK_BASED_SCORE




// SELECT User.id AS scheduleUser_id , CONCAT(NAME, '-' , displayName) AS NAME , 
// (SELECT (SELECT sectorId FROM Sector AS e WHERE  sectors_id = e.id ) FROM User_Sector AS c WHERE c.User_id= scheduleUser_id) AS sectorId,
// (SELECT (SELECT tlPinId FROM TLPin AS e WHERE  tlPin_id = e.id ) FROM `User` AS c WHERE c.id= scheduleUser_id) AS tlPinId,
// indicator_1.* 
// FROM `User`
// LEFT JOIN
// (
// select 
// (IF(rank_one,rank_one,0)+ IF(rank_six,rank_six,0)+ IF(rank_tnine,rank_tnine,0)+ IF(rank_thirty,rank_thirty,0)+ IF(rank_thrity1,rank_thrity1,0)+ IF(rank_thrity2,rank_thrity2,0)+ IF(rank_anc,rank_anc,0)+ IF(rank_vs29,rank_vs29,0)+ IF(rank_vs43,rank_vs43,0) ) / (IF(rank_one,1,0)+ IF(rank_six,1,0)+ IF(rank_tnine,1,0)+ IF(rank_thirty,1,0)+ IF(rank_thrity1,1,0)+ IF(rank_thrity2,1,0)+ IF(rank_anc,1,0)+ IF(rank_vs29,1,0)+ IF(rank_vs43,1,0) ) AS cummulate_score_1,

// IF(rank_one,rank_one,0)+ IF(rank_six,rank_six,0)+ IF(rank_tnine,rank_tnine,0)+ IF(rank_thirty,rank_thirty,0)+ IF(rank_thrity1,rank_thrity1,0)+ IF(rank_thrity2,rank_thrity2,0)+ IF(rank_anc,rank_anc,0)+ IF(rank_vs29,rank_vs29,0)+ IF(rank_vs43,rank_vs43,0) AS sum_rank_1,

// IF(rank_one,1,0)+ IF(rank_six,1,0)+ IF(rank_tnine,1,0)+ IF(rank_thirty,1,0)+ IF(rank_thrity1,1,0)+ IF(rank_thrity2,1,0)+ IF(rank_anc,1,0)+ IF(rank_vs29,1,0)+ IF(rank_vs43,1,0) AS sum_rank_used_count_1,

// ======

// ) indicator_1  

// ON indicator_1.scheduleUser_id =  User.id
// WHERE role_id=5


var query = "SELECT User.id AS scheduleUser_id , CONCAT(NAME, '-' , displayName) AS name ," +
            "(SELECT (SELECT sectorId FROM Sector AS e WHERE  sectors_id = e.id ) FROM User_Sector AS c WHERE c.User_id= scheduleUser_id) AS sectorId,"+
            "(SELECT (SELECT tlPinId FROM TLPin AS e WHERE  tlPin_id = e.id ) FROM `User` AS c WHERE c.id= scheduleUser_id) AS tlPinId";
     if(req.query.indicator1) {
      query +=",indicator_1.*   ";
     }
     if(req.query.indicator2) {
      query +=",indicator_2.*   ";
     }
     if(req.query.indicator3) {
      query +=",indicator_3.*  ";
     }
     query+=  ", ROUND( (  " ;
     if(req.query.indicator1) {
      query+= "IF(sum_rank_1, sum_rank_1, 0)";
      if(req.query.indicator2 || req.query.indicator3 ) {
        query+= " + ";
      }    
    }
     if(req.query.indicator2) {
      query+= "IF(sum_rank_2, sum_rank_2, 0)";
      if(req.query.indicator3 ) {
        query+= " + ";
      }    
    }
     if(req.query.indicator3) {
      query+= "IF(sum_rank_3, sum_rank_3, 0)";
    }
    query+=  " ) / (" ;
     if(req.query.indicator1) {
      query+= "IF(sum_rank_1, 1, 0)";
      if(req.query.indicator2 || req.query.indicator3 ) {
        query+= " + ";
      }    
    }
     if(req.query.indicator2) {
      query+= "IF(sum_rank_2, 1, 0)";
      if(req.query.indicator3 ) {
        query+= " + ";
      }    
    }
     if(req.query.indicator3) {
      query+= "IF(sum_rank_3, 1, 0)";
    }
    query+=  " ) , 2) AS total_commulative_rank " ;

    query+=  " FROM `User` LEFT JOIN (";


var sum_rank_1 = "";

for(var i=0; i<indicator1Config.length; i++){

  sum_rank_1+= "IF(percentage_"+ indicator1Config[i].postfix +  ",rank_"+ indicator1Config[i].postfix + ",0)";
  if(i!=indicator1Config.length-1){
    sum_rank_1+="+";
  }

}


var sum_rank_used_count_1 = "";

for(var i=0; i<indicator1Config.length; i++){

  sum_rank_used_count_1+= "IF(percentage_"+ indicator1Config[i].postfix +  ",1,0)";
  if(i!=indicator1Config.length-1){
    sum_rank_used_count_1+="+";
  }

}


query+= "select ROUND(("+ sum_rank_1 +")/("+ sum_rank_used_count_1 +"),2) as cummulate_score_1 ,";
query+=  sum_rank_1 +" as sum_rank_1 ,";
query+=  sum_rank_used_count_1 +" as sum_rank_used_count_1, ";
query+= indicator1Config[0].postfix+ ".scheduleUser_id AS scheduleUser_id"

//(SELECT (SELECT sectorId from Sector as e WHERE  sector_id = e.id ) FROM User_Sector AS c WHERE c.User_id= scheduleUser_id) AS sectorId,"; 
//   query+=  "(SELECT CONCAT(name, '-' , displayName) FROM User AS c WHERE c.id= "+ indicator1Config[0].postfix +".scheduleUser_id) as name, ";
//   query+=  "(SELECT (SELECT sectorId from Sector as e WHERE  sectors_id = e.id ) FROM User_Sector AS c WHERE c.User_id= "+ indicator1Config[0].postfix +".scheduleUser_id) as sectorId, ";
//   query+=  "(SELECT (SELECT tlPinId from TLPin as e WHERE  tlPin_id = e.id ) FROM User AS c WHERE c.id= "+ indicator1Config[0].postfix +".scheduleUser_id) as tlPinId ";



for(var i=0; i<indicator1Config.length; i++){

query+= ", IF(percentage_"+ indicator1Config[i].postfix + ", CONCAT(rank_" + indicator1Config[i].postfix + ", ' (' , percentage_" + indicator1Config[i].postfix + ", '%)' )   , NULL) as rank_percentage_"+ indicator1Config[i].postfix

}

query+= " from ";


for(var i=0; i<indicator1Config.length; i++){
  query+= "( SELECT IF(percentage>=0,rank,NULL) AS rank_" + indicator1Config[i].postfix +  " , percentage AS percentage_" + indicator1Config[i].postfix  + ",  "+
  "s.scheduleUser_id AS scheduleUser_id  FROM (SELECT    r.*, @curRank := IF(@prevRank = percentage, @curRank, @incRank) AS rank, @incRank := @incRank + 1, @prevRank := percentage,a.* FROM (SELECT * ,"+ 
  "sum_percentage_" + indicator1Config[i].postfix +  " AS percentage "+
  "FROM(SELECT scheduleUser_id, "+
  "sum(percentage_" + indicator1Config[i].postfix +  ") AS sum_percentage_" + indicator1Config[i].postfix +  " "+
  "FROM (SELECT scheduleUser_id, IF(`formToGenerate_id` IN (";

    query+=indicator1Config[i].values

    query+="),percentage,NULL) AS percentage_"+ indicator1Config[i].postfix ; 
    
  // jweekId is below...
  // TODO: Add date filter below

    query+=" FROM (SELECT  CONCAT(scheduleUser_id, '_', formToGenerate_id) AS concat_user_formId, Schedule.scheduleUser_id, formToGenerate_id,  ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` WHERE jweek_id>0 AND jweek_id<1000000 GROUP BY CONCAT(scheduleUser_id, formToGenerate_id)) submission_By_User_and_form)submission_By_User_and_form_and_percentage GROUP BY scheduleUser_id) submission_By_User_and_form_and_percentage_ranking) a , (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY percentage DESC) s"+
              ") " + indicator1Config[i].postfix

  if(i!=indicator1Config.length-1){
    query+=" JOIN "
  }


}


query += " WHERE "


for(var i=1; i<indicator1Config.length; i++){
  query+= indicator1Config[0].postfix + ".scheduleUser_id =" +  indicator1Config[i].postfix + ".scheduleUser_id" 

if(i!=indicator1Config.length-1) {
  query+= " AND "
}


}



query+= ") indicator_1 "+
        " ON indicator_1.scheduleUser_id =  User.id ";





if(req.query.indicator2==1) {

// Indicator 2 - start



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


query+= " LEFT JOIN ("; 


//  query+= " select * ";
 // query+= indicator2Config[0].postfix+ ".sender_id AS sender_id" + ",";
 query+= " select  sender_id_user AS sender_id, ";


for (j=0; j<indicator2Config.length; j++){

query+= " rank_2_" + indicator2Config[j].postfix + " , avgCompletionTime_2_" + indicator2Config[j].postfix + " , deviationFromMean_" + indicator2Config[j].postfix + " , "  ;


query+= " IF(rank_2_" + indicator2Config[j].postfix + " , CONCAT(rank_2_" + indicator2Config[j].postfix + " , ' (' , avgCompletionTime_2_" + indicator2Config[j].postfix  + " ,')' ), '') AS rank_value_2_" + indicator2Config[j].postfix  ;


      if(j!=indicator2Config.length-1){
          query+= " , "; 
      }
}

var sum_rank_2 = "";
for(var i=0; i<indicator2Config.length; i++){
  //TODO: Change this to deviation from Mean when deviation code is fixed
  sum_rank_2+= "IF(avgCompletionTime_2_"+ indicator2Config[i].postfix + ",rank_2_"+ indicator2Config[i].postfix + ",0)";
  if(i!=indicator2Config.length-1){
    sum_rank_2+="+";
  }
}



var sum_rank_used_count_2 = "";

for(var i=0; i<indicator2Config.length; i++){
  //TODO: Change this to deviation from Mean when deviation code is fixed
  sum_rank_used_count_2+= " IF(avgCompletionTime_2_"+ indicator2Config[i].postfix +  ",1,0)";
  if(i!=indicator2Config.length-1){
    sum_rank_used_count_2+="+";
  }
}


query+= ", ROUND(("+ sum_rank_2 +")/("+ sum_rank_used_count_2 +"),2) as cummulate_score_2 ,";
query+=  sum_rank_2 +" as sum_rank_2 ,";
query+=  sum_rank_used_count_2 +" as sum_rank_used_count_2 ";


  query+= " from (select id as sender_id_user from `User` where role_id=5) `User` LEFT JOIN ";



for (j=0; j<indicator2Config.length; j++){
  var disaggregation = "";

  for (k=0; k<indicator2Config[j].values.length; k++){

      disaggregation+= " (titleVar = '"+ indicator2Config[j].values[k].titleVar + "' AND valueVar = "+ indicator2Config[j].values[k].valueVar + ") ";

      if(k!=indicator2Config[j].values.length-1){
          disaggregation+= " OR ";        
      }

    }
      query+= " ( " 


// TODO: ADD JWEEK RANGE

      query+=    " SELECT IF(avgCompletionTime>=0,rank,NULL) AS rank_2_"+  indicator2Config[j].postfix +  ", avgCompletionTime AS avgCompletionTime_2_" + indicator2Config[j].postfix +
          " , deviationFromMean AS deviationFromMean_"+ indicator2Config[j].postfix + 
          ",s.sender_id "+//" AS  sender_id_" + indicator2Config[j].postfix +
          " FROM (SELECT    r.*, @curRank := IF(@prevRank = avgCompletionTime, @curRank, @incRank) AS rank, "+
          " @incRank := @incRank + 1, @prevRank := avgCompletionTime,a.* FROM ("+
          " SELECT CONCAT(sender_id, '_' , form_id) AS sender_form, sender_id, form_id, endTime,startTime, ROUND(AVG((endTime-startTime)),2 ) avgCompletionTime, "+
          " ROUND(STDDEV(endTime-startTime),2) stddevCompletionTime "+
          " , 2 as deviationFromMean  "+ // removed following lines as deviationFrom Mean is not working the they need to be reworked
//          " ,ROUND(AVG((endTime-startTime)) - (SELECT AVG((endTime-startTime)) FROM `Data` WHERE form_id IN (SELECT form_id FROM `UnitData`"+
//          " WHERE  "+ disaggregation +
//          " ),2) deviationFromMean"+
          " FROM `Data` WHERE form_id IN "+
          " (SELECT form_id FROM `UnitData`"+
          " WHERE "+ disaggregation +
          " ) GROUP BY CONCAT(sender_id, '_' , form_id)) a , "+
          " (SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY avgCompletionTime ASC "+ //"avgCompletionTime ORDER BY ABS(deviationFromMean) ASC"+
          ") s";


      query+= " )  " + indicator2Config[j].postfix 
      query+= " ON User.sender_id_user = "+ indicator2Config[j].postfix + ".sender_id ";

      if(j!=indicator2Config.length-1){
          query+= " LEFT JOIN "; 
      }


}



query+= ") indicator_2 "  

 query+= "  ON User.id=  indicator_2.sender_id ";

} 

if(req.query.indicator3==1) {
  console.log("req.query.indicator3"+req.query.indicator3)


// Indicator 3 Start 
 query+= " LEFT JOIN (SELECT   rank AS sum_rank_3 , avgEndToReceiveTime , sender_id AS indicator_3_sender_id, form_count_for_indicator_3, sd_indicator_3 " +
          " FROM  ( SELECT    r.*, @curRank := IF(@prevRank = avgEndToReceiveTime, @curRank, @incRank) AS rank, @incRank := @incRank + 1,"+ 
                  " @prevRank := avgEndToReceiveTime, a.*"+
                  " FROM ( SELECT sender_id, endTime, received, ROUND(STDDEV(ABS(received - endTime)),1) AS sd_indicator_3 , ROUND(SUM(ABS(received - endTime))/count(*),1) AS avgEndToReceiveTime , count(*) AS form_count_for_indicator_3 "+
                          " FROM `Data` GROUP BY sender_id ) a , "+
                  " ( SELECT @curRank :=0, @prevRank := NULL, @incRank := 1) r ORDER BY avgEndToReceiveTime ASC) a)  indicator_3 ";

 query+= "  ON User.id= indicator_3_sender_id ";

}
// Indicator 3 Ends

query+=      " WHERE role_id=5 " // FD ==> 5 and TLI => 4

query+=      "  ORDER BY -total_commulative_rank  DESC ";



  //    var query = "SELECT "+ group_by_attributeMapping + " as date , " + 
   //               disaggregation +  " FROM `UnitData` " +
    //                " GROUP BY " +  group_by_attribute + " HAVING date>=\""+ startDate + "\" and date <=\""+ endDate + "\"" ;

      console.log(query);

      var table = ["Schedule"];
      query = mysql.format(query,table); 
      connection.query({
         sql: query,
          timeout: 400000 // 400s
      },function(err,rows){
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









 // }

  router.get("/CHWScoringIndicatorStatistics",function(req,res){

      console.log(req.query)

      var startDate = req.query.startDate || "2015-01-01" ;

      var endDate = req.query.endDate || "2017-01-01" ;


      console.log("req.query.indicator1:" + req.query.indicator1);
      console.log("req.query.indicator2:" + req.query.indicator2);
      console.log("req.query.indicator3:" + req.query.indicator3);

      req.query.indicator1 = parseInt(req.query.indicator1);
      req.query.indicator2 = parseInt(req.query.indicator2);
      req.query.indicator3 = parseInt(req.query.indicator3);    

     var indicator1Config = indicatorConfig.indicator1Config;
     var indicator2Config = indicatorConfig.indicator2Config;

     console.log(indicator1Config);
     console.log(indicator2Config);

     var query = "";

//indicator 1 
     for(var i=0; i< indicator1Config.length ; i++ ){
       query+= "  ( select 1 as indicatorType,'"+ indicator1Config[i].postfix +"' as indicatorAggregator, ROUND(AVG(percentage),2) as avg, ROUND(STDDEV(percentage),2) as sd "+
                " FROM ( select ((SUM(STATUS= 'DONE')/ (SUM(STATUS= 'ACTIVE')+ SUM(STATUS= 'DONE')))*100) AS percentage FROM `Schedule` " +
                " WHERE jweek_id>0 AND jweek_id<1000000" + 
                " AND formToGenerate_id in (" + indicator1Config[i].values + " ) "+
                " GROUP BY CONCAT(scheduleUser_id, formToGenerate_id) ) " + indicator1Config[i].postfix + 
                " ) ";
      if(i!=indicator1Config.length-1){
          query+= " UNION ";
      }
     }

// indicator 2 


    for (j=0; j<indicator2Config.length; j++){
      var disaggregation = "";

      for (k=0; k<indicator2Config[j].values.length; k++){
          disaggregation+= " (titleVar = '"+ indicator2Config[j].values[k].titleVar + "' AND valueVar = "+ indicator2Config[j].values[k].valueVar + ") ";
          if(k!=indicator2Config[j].values.length-1) {
              disaggregation+= " OR ";        
          }
        }

      query+= " UNION ( " +
          "  SELECT 2 as indicatorType, '"+ indicator2Config[j].postfix+"' as indicatorAggregator , "+
          "  ROUND(AVG((endTime-startTime)),2) avg, "+
          "  ROUND(STDDEV(endTime-startTime),2) sd "+
          "  FROM `Data` WHERE form_id IN "+
          "  (SELECT form_id FROM `UnitData`"+
          "  WHERE "+ disaggregation +
          "  ) ) ";
      }


// indicator 3 
      query+= " UNION ( select 3 as indicatorType, 'avgEndToReceiveTime' as indicatorAggregator , ROUND(AVG(avgEndToReceiveTime),2) as avg, ROUND(STDDEV(avgEndToReceiveTime),2) as sd "+
                " FROM ( SELECT sender_id, ROUND(STDDEV(ABS(received - endTime)),1) AS sd_indicator_3 , ROUND(SUM(ABS(received - endTime))/count(*),1) AS avgEndToReceiveTime , count(*) AS form_count_for_indicator_3 "+
                        " FROM `Data` GROUP BY sender_id ) a ) ";


     console.log(query);

      connection.query({
         sql: query,
      },function(err,rows){
            if(err) {
              console.log(err);
               res.json({"Error" : true, "Message" : "Error executing MySQL query"});
            } else {
                res.json({"Error" : false, 
                          "Message" : "Success", 
                          "ver": 0.1, 
                          "result" : rows, 
                          "startDate" : startDate,
                          "endDate" : endDate                 
                        });
            }
          }); 
  });
}

  //);

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