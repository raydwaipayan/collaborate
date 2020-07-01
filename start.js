const {createServer} = require("http")
const {handleCollabRequest} = require("/var/collaborate/src/server/server")
const fs = require('fs')
const path = require('path')

const port = 8000


createServer((req, res) => {
  //console.log(req.url);
  res.setHeader('Access-Control-Allow-Origin','*')
  res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  if(req.url === '/') {
    fs.readFile('/var/collaborate/build/index.html','UTF-8',function(err,html){
      res.writeHead(200,{"Content-Type": "text/html"})
      res.end(html)
    })
  }
  else if(req.url.match("\.css$")) {
    var cssPath=path.join('/var/collaborate/build',req.url)
    var fileStream=fs.createReadStream(cssPath,"UTF-8")
    res.writeHead(200,{"Content-Type": "text/css"})
    fileStream.pipe(res)
  }
  else if(req.url.match("\.js$")) {
    var jsPath=path.join('/var/collaborate/build',req.url)
    var fileStream=fs.createReadStream(jsPath,"UTF-8")
    res.writeHead(200,{"Content-Type": "text/js"})
    fileStream.pipe(res)
  }
  else if (!handleCollabRequest(req, res)) {
    res.writeHead(404, {"Content-Type": "text/plain"})
    res.end("Not found")
  }
}).listen(port)

console.log("Collab demo server listening on " + port)

