var http = require("http");
var socketio = require("socket.io");
var fs = require("fs"),
    url = require("url"),
    path = require("path");


 
var server = http.createServer(function(request, response) {

  console.log(request.url);

  if(request.url.match("/api")){
    console.log(request.url);
    io.sockets.emit('commands','{"foo":"bar"}');
  }

  if(request.method=='POST'){
        var body='';
        request.on('data', function (data) {
           body +=data;
        });
        request.on('end',function(){
           console.log(body);
           io.sockets.emit('commands',body);
        });
  }

  

    var Response = {
        "200":function(file, filename){
            var extname = path.extname(filename);
            var header = {
                "Access-Control-Allow-Origin":"*",
                "Pragma": "no-cache",
                "Cache-Control" : "no-cache"       
            }

            response.writeHead(200, header);
            response.write(file, "binary");
            response.end();
        },
        "404":function(){
            response.writeHead(404, {"Content-Type": "text/plain"});
            response.write("404 Not Found\n");
            response.end();

        },
        "500":function(err){
            response.writeHead(500, {"Content-Type": "text/plain"});
            response.write(err + "\n");
            response.end();

        }
    }


    var uri = url.parse(request.url).pathname
    , filename = path.join(process.cwd(), uri);

    fs.exists(filename, function(exists){
        console.log(filename+" "+exists);
        if (!exists) { Response["404"](); return ; }
        if (fs.statSync(filename).isDirectory()) { filename += '/index.html'; }

        fs.readFile(filename, "binary", function(err, file){
        if (err) { Response["500"](err); return ; }
            Response["200"](file, filename);   
        }); 

    });


}).listen(process.env.VMC_APP_PORT || 3000);

var io = socketio.listen(server);
 
io.sockets.on("connection", function (socket) {

  socket.on("commands", function (data) {
    socket.broadcast.emit("commands", data);
  });

  socket.on("calibrate", function (data) {
    console.log("calibrate:",data);
    socket.broadcast.emit("calibrate",data);
  });
 
});