var mysql = require('mysql');
var config = require("./config.js");

var connection = mysql.createConnection(config.mysqlPool);
var del = connection._protocol._delegateError;
connection._protocol._delegateError = function(err, sequence) {
    if (err.fatal) {
        console.trace('fatal error: ' + err.message);
    }
    return del.call(this, err, sequence);
};

var express = require("express");


var bodyParser = require("body-parser");
var md5 = require('MD5');
var rest = require("./rest.js");
var app = express();



function REST() {
    var self = this;
    self.connectMysql();
};


REST.prototype.connectMysql = function() {
    var self = this;
    var pool = mysql.createPool(config.mysqlPool);
    pool.getConnection(function(err, connection) {
        if (err) {
            self.stop(err);
        } else {
            self.configureExpress(connection);
        }
    });
}

REST.prototype.configureExpress = function(connection) {
    var self = this;
    app.use(bodyParser.urlencoded({
        extended: true
    }));
    app.use(bodyParser.json());
    var router = express.Router();

    app.use(function(req, res, next) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        next();
    });

    app.use('/', router);

    var rest_router = new rest(router, connection, md5);
    self.startServer();
}

REST.prototype.startServer = function() {
    app.listen(config.port, function() {
        console.log("All right ! I am alive at Port" + config.port);
    });
}

REST.prototype.stop = function(err) {
    console.log("ISSUE WITH MYSQL \n" + err);
    process.exit(1);
}

new REST();