dgram = require 'dgram'
EventEmitter = require('events').EventEmitter

class Socket extends EventEmitter
  TYPES_WEBRTC:
    offer: 'offer'
    answer: 'answer'
    ice: 'ice'
    remoteClose: 'remoteClose'

  TYPES_NETWORK:
    broadcast: 'broadcast'
    broadcastAnswer: 'broadcastAnswer'
    peerInformations: 'peerInformations'

  constructor: (@port) ->
    @udpSocket = dgram.createSocket 'udp4'
    @udpSocket.on 'listening', =>
      @emit 'ready'

    @udpSocket.on 'message', (msg, remote) =>
      #parse to json or throw error if it fails
      try
        msgJSON = JSON.parse msg
      catch e
        return @emit 'error', 'got message that isnt a json string', msg.toString(), remote

      @emit 'received', remote, msg.toString() #for logging
      
      # check if received has type that we are interested in
      if @TYPES_NETWORK[msgJSON.type]? or @TYPES_WEBRTC[msgJSON.type]? # if so, emit it 
        @emit msgJSON.type, msgJSON, remote
      else #otherwise throw error
        @emit 'error', 'got message with undefined type', msgJSON, remote
  
  start: ->
    @udpSocket.bind @port

  sendBroadcast: (msgJSON, address) ->
    @send msgJSON, address, @port, true

  send: (msgJSON, address, port, broadcast = false) ->
    try
      msgStr = JSON.stringify msgJSON
    catch e
      return @emit 'error', 'msg json is not valid', e

    msg = new Buffer msgStr
    @udpSocket.setBroadcast broadcast
    @udpSocket.send msg, 0, msg.length, port, address, (err, bytes) =>
      return @emit 'error', err if err
      @emit 'sent', msgStr

module.exports = Socket