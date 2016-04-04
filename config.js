var config = {
	mysqlPool:	{
		    host     : 'localhost',
		  	user     : 'root',
		  	password : 'root',
		  	database : 'mjivitacr_live',
        	debug    :  false,
    },
    port: 3000,
    // TODO: security model is to be updated
     testUser: { user: 'test', pass: 'longlivebangladesh'}
	}

module.exports = config;