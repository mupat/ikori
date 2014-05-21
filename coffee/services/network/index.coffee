Socket = require './socket'
Interfaces = require './interfaces'
Broadcaster = require './broadcaster'

class Network
  constructor: (@$rootScope, config, user) ->
    interfaces = new Interfaces user.getNetworks()
    @socket = new Socket config.get('port')
    @broadcaster = new Broadcaster @socket, interfaces.get(), user, config.get('interval')

    #register error event
    @socket.on 'error', (args...) =>
      @$rootScope.$emit 'error', 'error in socket class', args

    @_registerSocketEvents()
    @_registerPeerEvents()
    @_registerLogEvents() if config.get('logging')

  start: ->
    @socket.on 'ready', =>
      @$rootScope.$emit 'started'
    @socket.start()
  
  send: (type, remote, data = null)->
    return unless @socket.TYPES_WEBRTC[type]? #return if type isnt provided
    msg = 
      type: @socket.TYPES_WEBRTC[type]

    msg.data = data if data?
    @socket.send msg, remote.address, remote.port

  getPeerInfos: (address) ->
    return @broadcaster.getPeerInfos address

  _registerPeerEvents: ->
    @broadcaster.on 'newPeer', (remote, infos) =>
      @$rootScope.$broadcast 'newPeer', remote, infos

    @broadcaster.on 'removePeer', (address) =>
      @$rootScope.$broadcast 'remoteClose', address
      @$rootScope.$broadcast 'removePeer', address

  _registerSocketEvents: ->
    #re-emit the socket events to angular world
    for type of @socket.TYPES_WEBRTC
      do (type) =>
        @socket.on type, (msg, remote) =>
          @$rootScope.$broadcast type, remote, msg.data

  _registerLogEvents: ->
    @socket.on 'received', (args...) =>
      @$rootScope.$emit 'received', args...

    @socket.on 'sent', (args...) =>
      @$rootScope.$emit 'sent', args...

module.exports = Network