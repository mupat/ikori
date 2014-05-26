EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  CON_OPTIONS: 
    optional: [
      RTPDataChannels: true
    ]
  CHANNEL_OPTIONS:
    reliable: true

  constructor: (@remote) ->
    @con = new window.webkitRTCPeerConnection null, @CON_OPTIONS
    @con.onicecandidate = @_gotCandidate

  setICE: (msg) ->
    candidate = 
      sdpMLineIndex: msg.sdpMLineIndex,
      candidate: msg.candidate
      
    @con.addIceCandidate new window.RTCIceCandidate(candidate)

  setRemoteDescription: (msg) ->
    @con.setRemoteDescription new window.RTCSessionDescription(msg)

  send: (msg) ->
    @channel.send msg

  _gotCandidate: (event) =>
    @emit 'ice', event.candidate, @remote if event.candidate

module.exports = Connection