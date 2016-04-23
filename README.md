# chwAnalyticsBackEnd
Health Worker Analytics Back-end is developed to visualize and generate report from data of a large scale mHealth project focused on Maternal &amp; child health

Installation 
-------------
- Install `npm` and `node` 
- Clone the repository 
```shell
 git clone https://github.com/piyushmadan/chwAnalyticsBackEnd 
``` 
- `cd chwAnalyticsBackEnd` 
- `npm install` (reads `package.json` to install all neccessary packages in node-module folder)
- change mysql host, username and password in `config.js`. Default basic auth password can also be set here
- run `nodejs server.js`
- To stop use `Cmd/Ctrl + C`
- To run the service on server instance, so that it runs even after you exit, use nohup
` nohup nodejs server.js &`
- To stop nohup,  `ps -ef | grep nohup ` to know the process id
- Kill the process `kill -9 <process_id>`
