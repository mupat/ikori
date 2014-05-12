var dgram = require('dgram');
var my_ip = require('my-ip');
var ip = require('ip');
var netmask = require('netmask').Netmask;
var broadcastAddress = "192.168.1.255";

console.log(my_ip());
console.log(ip.address());
// console.log(ip.subnet(ip.address()));
var net = new netmask('192.168.1.51/24');
console.log(net);
console.log(net.broadcast);

var os=require('os');
var ifaces=os.networkInterfaces();
console.log(ifaces);

var client = dgram.createSocket("udp4");
// var server = dgram.createSocket("udp4");

var answer = new Buffer(JSON.stringify({broadcast: false, text:"Some bytes as answer"}));
var message = new Buffer(JSON.stringify({broadcast: true, text:"Some bytes"}));

var PORT = 4000;

// server.on('listening', function () {
//     var address = server.address();
//     console.log('UDP Server listening on ' + address.address + ":" + address.port);
// });

// server.on('message', function (message, remote) {
//     console.log(remote.address + ':' + remote.port +' - ' + message);
//     server.send(answer, 0, answer.length, remote.port, remote.address, function(err, bytes) {
//         console.log('send answer');
//     });

// });

// server.bind(PORT);

client.on("listening", function () {
    client.setBroadcast(true);
    client.send(message, 0, message.length, PORT, broadcastAddress, function(err, bytes) {
        console.log('send broadcast');
    });
});

client.on('message', function (msg, remote) {
	console.log(remote);
    console.log(remote.address + ':' + remote.port +' - ' + msg);
    msg = JSON.parse(msg)
    if(msg.broadcast) {
    	client.send(answer, 0, answer.length, remote.port, remote.address, function(err, bytes) {
        	console.log('send answer');
    	});
    }

    // client.on('message', function (msg_answer, remote_answer) {
    // 	console.log('second message: ', remote_answer);
    // 	console.log(remote_answer.address + ':' + remote_answer.port +' - ' + msg_answer);
    // });
});

client.bind(PORT);