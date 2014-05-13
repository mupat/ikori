var os = require('os');

console.log(document.getElementById('tmp'));
console.log(os.tmpdir());
document.getElementById('tmp').innerHTML = os.tmpdir();
document.getElementById('host').innerHTML = os.hostname();
document.getElementById('type').innerHTML = os.type();
document.getElementById('platform').innerHTML = os.platform();
document.getElementById('arch').innerHTML = os.arch();
document.getElementById('release').innerHTML = os.release();
document.getElementById('uptime').innerHTML = os.uptime();
document.getElementById('loadavg').innerHTML = os.loadavg();
document.getElementById('totalmem').innerHTML = os.totalmem();
document.getElementById('freemem').innerHTML = os.freemem();
document.getElementById('cpus').innerHTML = JSON.stringify(os.cpus());
document.getElementById('network').innerHTML = JSON.stringify(os.networkInterfaces());





var localPeer, remotePeer, sendChannel, receiveChannel = null;
 
localPeer = new webkitRTCPeerConnection(null, {
  optional: [{RTPDataChannels: true}]
});
 
console.log(localPeer);
sendChannel = localPeer.createDataChannel("sendDataChannel", {reliable: false});
console.log(sendChannel);
localPeer.onicecandidate = function(event) {
  if (event.candidate) {
    remotePeer.addIceCandidate(event.candidate);
  }
}
 
remotePeer = new webkitRTCPeerConnection(null, {
  optional: [{RTPDataChannels: true}]
});
 
remotePeer.onicecandidate = function(event) {
  if (event.candidate) {
    localPeer.addIceCandidate(event.candidate);
  }
}
 
remotePeer.ondatachannel = function(event) {
  receiveChannel = event.channel
  receiveChannel.onmessage = function (event) {
    document.getElementById("receive").innerHTML = event.data
  }
}
 
localPeer.createOffer(function(desc) {
  localPeer.setLocalDescription(desc);
  remotePeer.setRemoteDescription(desc);
  remotePeer.createAnswer(function(desc2) {
    remotePeer.setLocalDescription(desc2);
    localPeer.setRemoteDescription(desc2);
  });
});
 
document.getElementById("send").onclick = function() {
  var data = document.getElementById("sendText").value;
  sendChannel.send(data);
};