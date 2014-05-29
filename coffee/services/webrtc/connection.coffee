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
        minWidth: window.screen.width
        minHeight: window.screen.height
        maxWidth: window.screen.width
        maxHeight: window.screen.height
        minFrameRate: 1
        maxFrameRate: 5
      optional: []

  constructor: (@remote, stream = null) ->
    @con = new window.webkitRTCPeerConnection null, @CON_OPTIONS
    @con.onicecandidate = @_gotCandidate
    @con.onaddstream = (event) =>
      @emit 'stream.get', event.stream, @remote

    if stream?
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
      @con.addStream stream
      @emit 'stream.add', stream

    error = (err) =>
      @emit 'error', err

    window.navigator.webkitGetUserMedia @SCREEN_OPTIONS, success, error

  _gotCandidate: (event) =>
    @emit 'ice', event.candidate, @remote if event.candidate

module.exports = Connection