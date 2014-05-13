var dgram = require('dgram');
var netmask = require('netmask').Netmask;
var broadcastAddress = "192.168.1.255";

// console.log(ip.subnet(ip.address()));
var net = new netmask('192.168.1.51/');
// console.log(net);
// console.log(net.broadcast);

// var os=require('os');
// var ifaces=os.networkInterfaces();
// console.log(ifaces);

var client = dgram.createSocket("udp4");
// var server = dgram.createSocket("udp4");

var answer = new Buffer(JSON.stringify({broadcast: false, text:"Some bytes as answer"}));
var message = new Buffer(JSON.stringify({broadcast: true, text:"Some bytes"}));

var PORT = 4000;

client.on("listening", function () {
    client.setBroadcast(true);
    client.send(message, 0, message.length, PORT, broadcastAddress, function(err, bytes) {
        console.log('send broadcast');
    });
});

client.on('message', function (msg, remote) {
    console.log(remote.address + ':' + remote.port +' - ' + msg);
    msg = JSON.parse(msg)
    if(msg.broadcast) {
    	client.send(answer, 0, answer.length, remote.port, remote.address, function(err, bytes) {
        	console.log('send answer');
    	});
    }
});

client.bind(PORT);