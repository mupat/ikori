EventEmitter = require('events').EventEmitter

class Connection extends EventEmitter
  CON_OPTIONS: 
    optional: [
      RTPDataChannels: true
    ]
  CHANNEL_OPTIONS:
    reliable: true
  SCREEN_OPTIONS:
    audio: false
    video:
      mandatory:
        chromeMediaSource: 'screen'
        maxWidth: 1280
        maxHeight: 720
      optional: []

  constructor: (@remote, stream = null) ->
    @con = new window.webkitRTCPeerConnection null, @CON_OPTIONS
    @con.onicecandidate = @_gotCandidate
    @con.onaddstream = (event) =>
      console.log 'get stream in base class'
      @emit 'stream.get', event.stream, @remote

    if stream?
      console.log 'have stream in base class'
      @con.addStream stream 

  setICE: (msg) ->
    candidate = 
      sdpMLineIndex: msg.sdpMLineIndex,
      candidate: msg.candidate
      
    @con.addIceCandidate new window.RTCIceCandidate(candidate)

  setRemoteDescription: (msg) ->
    @con.setRemoteDescription new window.RTCSessionDescription(msg)

  send: (msg) ->
    @channel.send msg

  createStream: ->
    success = (stream) =>
      console.log 'success add stream', @con
      @con.addStream stream
      @emit 'stream.add', stream

    error = (err) =>
      console.log 'eeror by stream'
      @emit 'error', err

    window.navigator.webkitGetUserMedia @SCREEN_OPTIONS, success, error

  _gotCandidate: (event) =>
    @emit 'ice', event.candidate, @remote if event.candidate

module.exports = Connection