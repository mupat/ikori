//network stuff
var dgram = require('dgram');
var Netmask = require('netmask').Netmask;
var networks = require('os').networkInterfaces();
console.log(networks);
var network = networks['eth0'][0];
console.log(network);

var block = new Netmask(network.address, network.netmask);
console.log(block);
console.log(block.broadcast); 

var broadcast_address = block.broadcast;

var broadcaster = dgram.createSocket("udp4");

var message = new Buffer(JSON.stringify({broadcast: true, text:"Hello"}));
var answerBr = new Buffer(JSON.stringify({broadcast: false, text:"Hello back"}));

var PORT = 4000;

try {


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
      broadcaster.send(answerBr, 0, answerBr.length, remote.port, remote.address, function(err, bytes) {
        console.log('send answer');
        addPeer(remote);
      });
    }
    else if(msg.offer) { 
      console.log('offer msg get', msg);
      console.log('type offer', typeof msg);
      var offer = new RTCSessionDescription(msg);
      console.log('offer parsed', offer);
      localPeer.setRemoteDescription(offer);
      localPeer.createAnswer(function(desc) {
        localPeer.setLocalDescription(desc);
        desc.answer = true;
        console.log('answer msg obj', desc);
        var msg = new Buffer(JSON.stringify(desc));
        // console.log('answer msg string', msg.toSring());
        broadcaster.send(msg, 0, msg.length, remote.port, remote.address, function(err, bytes) {
          console.log('send answer');
        });
      });
    } else if(msg.answer) {
      console.log('answer msg get', msg);
      var answer = new RTCSessionDescription(msg);
      localPeer.setRemoteDescription(msg);
    } else if(remote.address !== network.address) {
        addPeer(remote);
    } else {
      console.log('remote: ', remote);
      console.log('msg: ', msg);
    }
});

broadcaster.bind(PORT);

var list = document.getElementById('peers');
addPeer = function (remote) {
  var entry = document.createElement('li');
  entry.innerHTML = remote.address
  if(remote.address === network.address) { 
    entry.innerHTML +=  ' (own)'
  }
  list.appendChild(entry);

  // if(remote.address === network.address) { 
  //   return;
  // }

  entry.onclick = function() {
    localPeer.createOffer(function(desc) {
      localPeer.setLocalDescription(desc);
      // var msg = {
      //   offer: true,
      //   desc: desc
      // }
      desc.offer = true;
      console.log('offer msg obj', desc);
      var msg = new Buffer(JSON.stringify(desc));
      // console.log('offer msg string', msg.toSring());
      broadcaster.send(msg, 0, msg.length, remote.port, remote.address, function(err, bytes) {
        console.log('send offer');
      }); 
    });
  }
}

// localPeer.createOffer(function(desc) {
//         var answer = new Buffer(JSON.stringify(desc));
        
//       });


 // localPeer.setLocalDescription(msg);
 //      localPeer.createAnswer(function(desc) {
 //        localPeer.setRemoteDescription(desc)
 //      });

// webrtc stuff
var localPeer, remotePeer, sendChannel, receiveChannel = null;
 
localPeer = new webkitRTCPeerConnection(null, {
  optional: [{RTPDataChannels: true}]
});
 
sendChannel = localPeer.createDataChannel("sendDataChannel", {reliable: false});

// localPeer.onicecandidate = function(event) {
//   if (event.candidate) {
//     remotePeer.addIceCandidate(event.candidate);
//   }
// }
 
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
//   console.log(desc);
//   // localPeer.setLocalDescription(desc);
//   var test = new Buffer(desc);
//   var test2 = new Buffer(JSON.stringify(desc));
//   console.log('test', test.toJSON());
//   console.log('test2', test2.toJSON());
//   console.log('test str', test.toString());
//   console.log('test2 str', test2.toString());
//   console.log('desc', desc.toString());
//   console.log('test2 json', JSON.parse(test2));
//   // localPeer.setLocalDescription(JSON.parse(test2));
// });
 
// localPeer.createOffer(function(desc) {
//   localPeer.setLocalDescription(desc);
//   // remotePeer.setRemoteDescription(desc);
//   remotePeer.createAnswer(function(desc2) {
//     remotePeer.setLocalDescription(desc2);
//     localPeer.setRemoteDescription(desc2);
//   });
// });
 
document.getElementById("send").onclick = function() {
  if (sendChannel.readyState !== 'open') {
    alert('is not open');
    return;
  }
  var data = document.getElementById("sendText").value;
  sendChannel.send(data);
};

} catch(e) {
  alert(e)
}

