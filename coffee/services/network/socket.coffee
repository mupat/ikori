dgram = require 'dgram'
EventEmitter = require('events').EventEmitter
async = require 'async'

class Socket extends EventEmitter
  QUEUE_CONCURRENCY: 1
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
    @udpSocket.on 'message', @_receive.bind(@)
    @udpSocket.on 'close', => console.log 'socket close'
    @udpSocket.on 'error', (err) => @emit 'error', err

    @queue = async.queue @_send.bind(@), @QUEUE_CONCURRENCY
  
  start: ->
    @udpSocket.bind @port, =>
      @emit 'ready'

  sendBroadcast: (msgJSON, address) ->
    @send msgJSON, address, @port, true

  send: (msgJSON, address, port, broadcast = false) ->
    obj = 
      msg: msgJSON,
      address: address
      port: port
      broadcast: broadcast
    @queue.push obj, (err) =>
      return @emit 'error', err if err
      @emit 'sent', msgJSON

  _receive: (msg, remote) ->
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

  _send: (task, cb) ->
    try
      msgStr = JSON.stringify task.msg
    catch e
      return @emit 'error', 'msg json is not valid', e

    msg = new Buffer msgStr
    @udpSocket.setBroadcast task.broadcast
    @udpSocket.send msg, 0, msg.length, task.port, task.address, (err, bytes) =>
      return cb err if err
      cb()

module.exports = Socket