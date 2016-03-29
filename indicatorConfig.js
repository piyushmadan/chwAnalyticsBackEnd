var indicatorConfig = {
    indicator1Config : new Array({ postfix: "one", values: [1]},
                        { postfix: "six", values: [6]},
                        { postfix: "tnine", values: [29]},
                        { postfix: "thirty", values: [30]},
                        { postfix: "thrity1", values: [31]},
                        { postfix: "thrity2", values: [32]},
                        { postfix: "anc", values: [35,36,37,38]},
                        { postfix: "vs29", values: [40,42,44]},
                        { postfix: "vs43", values: [41,43,45]}
                        ),
    indicator2Config : new Array(   { postfix: "census", values: [ { titleVar : "FDCENSTAT", valueVar: 1},
                                                                        { titleVar : "FDELIGIBLE", valueVar: 1}] },
                                            { postfix: "psrf", values: [ { titleVar : "FDPSRSTS", valueVar: 1},
                                                                        { titleVar : "FDPSRPREGSTS", valueVar: 1}]},
                                            { postfix: "pvf", values: [ { titleVar : "FDBNFSTS", valueVar: 1} ]}
                               )
// var indicator2Config: new Array(   { postfix: "census", values: [ { titleVar : "FDCENSTAT", valueVar: 1},
//                                                                 { titleVar : "FDELIGIBLE", valueVar: 1}] },
//                                     { postfix: "psrf", values: [ { titleVar : "FDPSRSTS", valueVar: 1},
//                                                                 { titleVar : "FDPSRPREGSTS", valueVar: 1}]},
//                                  { postfix: "pvf", values: [ { titleVar : "FDBNFSTS", valueVar: 1} ]},
//                                  { postfix: "rest", values: [ { titleVar : "FDPSRSTS", valueVar: 1},
//                                                                 { titleVar : "TLANC1REMSTS", valueVar: 1},
//                                                                 { titleVar : "TLANC2REMSTS", valueVar: 1},
//                                                                 { titleVar : "TLANC3REMSTS", valueVar: 1},
//                                                                 { titleVar : "TLANC4REMSTS", valueVar: 1},
//                                                                 { titleVar : "TLPNCSTS", valueVar: 1},
//                                                                 { titleVar : "SES_STATUS", valueVar: 1},
//                                                                ]}
//                        );

                    };    

module.exports = indicatorConfig;