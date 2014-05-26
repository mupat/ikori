Socket = require './socket'
Interfaces = require './interfaces'
Broadcaster = require './broadcaster'

class Network
  constructor: (@$rootScope, @config, peer) ->
    interfaces = new Interfaces @config.interfaces
    @socket = new Socket config.port
    @broadcaster = new Broadcaster @socket, interfaces.get(), @config, peer

    #register error event
    @socket.on 'error', (args...) =>
      @$rootScope.$emit 'error', 'error in socket class', args

    @_registerSocketEvents()
    @_registerLogEvents() if config.logging

  start: ->
    @socket.on 'ready', =>
      @$rootScope.$emit 'started'
    @socket.start()
  
  send: (type, remote, data = null)->
    return unless @socket.TYPES_WEBRTC[type]? #return if type isnt provided
    msg = 
      type: @socket.TYPES_WEBRTC[type]
      uuid: @config.uuid

    msg.data = data if data? # add data object if provided
    @socket.send msg, remote.address, remote.port

  _registerSocketEvents: ->
    #re-emit the socket events to angular world
    for type of @socket.TYPES_WEBRTC
      do (type) =>
        @socket.on type, (msg, remote) =>
          remote.uuid = msg.uuid
          @$rootScope.$broadcast type, remote, msg.data

  _registerLogEvents: ->
    @socket.on 'received', (args...) =>
      @$rootScope.$emit 'socket.received', args...

    @socket.on 'sent', (args...) =>
      @$rootScope.$emit 'socket.sent', args...

module.exports = Network