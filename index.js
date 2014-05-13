//network stuff
var dgram = require('dgram');
var Netmask = require('netmask').Netmask;
var networks = require('os').networkInterfaces();
var network = networks['eth0'][0];
console.log(networks);

var block = new Netmask(network.address, network.netmask);
console.log(block);
console.log(block.broadcast); 

var broadcast_address = block.broadcast;

var broadcaster = dgram.createSocket("udp4");

// var answer = new Buffer(JSON.stringify({broadcast: false, text:"Some bytes as answer"}));
var message = new Buffer(JSON.stringify({broadcast: true, text:"Some bytes"}));

var PORT = 4000;


broadcaster.on("listening", function () {
    console.log('listening on port ' + PORT);
    broadcaster.setBroadcast(true);
    broadcaster.send(message, 0, message.length, PORT, broadcast_address, function(err, bytes) {
        console.log('send broadcast');
    });
});

broadcaster.on('message', function (msg, remote) {   
    console.log(remote.address + ':' + remote.port +' - ' + msg);
    msg = JSON.parse(msg);
    if(msg.broadcast) {
      if(remote.address === network.address) return;
      localPeer.createOffer(function(desc) {
        var answer = new Buffer(JSON.stringify(desc));
        broadcaster.send(answer, 0, answer.length, remote.port, remote.address, function(err, bytes) {
              console.log('send answer');
              addPeer(remote);
        });
      });
    }
    else { 
      addPeer(remote);
      localPeer.setLocalDescription(msg);
      localPeer.createAnswer(function(desc) {
        localPeer.setRemoteDescription(desc)
      });
    }
});

broadcaster.bind(PORT);

var list = document.getElementById('peers');
addPeer = function (argument) {
  var entry = document.createElement('li');
  entry.innerHTML = remote.address
  if(remote.address === network.address) { 
    entry.innerHTML +=  ' (own)'
  }
  list.appendChild(entry);
}




// webrtc stuff
var localPeer, remotePeer, sendChannel, receiveChannel = null;
 
localPeer = new webkitRTCPeerConnection(null, {
  optional: [{RTPDataChannels: true}]
});
 
sendChannel = localPeer.createDataChannel("sendDataChannel", {reliable: false});

localPeer.onicecandidate = function(event) {
  if (event.candidate) {
    remotePeer.addIceCandidate(event.candidate);
  }
}
 
// remotePeer = new webkitRTCPeerConnection(null, {
//   optional: [{RTPDataChannels: true}]
// });
 
// remotePeer.onicecandidate = function(event) {
//   if (event.candidate) {
//     localPeer.addIceCandidate(event.candidate);
//   }
// }
 
localPeer.ondatachannel = function(event) {
  receiveChannel = event.channel
  receiveChannel.onmessage = function (event) {
    document.getElementById("receive").innerHTML = event.data
  }
}
 
// localPeer.createOffer(function(desc) {
//   localPeer.setLocalDescription(desc);
//   // remotePeer.setRemoteDescription(desc);
//   remotePeer.createAnswer(function(desc2) {
//     remotePeer.setLocalDescription(desc2);
//     localPeer.setRemoteDescription(desc2);
//   });
// });
 
document.getElementById("send").onclick = function() {
  var data = document.getElementById("sendText").value;
  sendChannel.send(data);
};