EventEmitter = require('events').EventEmitter

class Broadcaster extends EventEmitter
  peers: {}
  constructor: (@socket, @interfaces, @user, @intervalTime) ->
    @socket.on 'ready', =>
      @_sendBroadcasts()
      setInterval @_sendBroadcasts.bind(@), @intervalTime

    @socket.on @socket.TYPES_NETWORK.broadcast, (msg, remote) =>
      return if @_isYourself remote #ignore own messages
      @_sendAnswer remote

    @socket.on @socket.TYPES_NETWORK.broadcastAnswer, (msg, remote) =>
      return if @_isYourself remote #ignore own messages
      @_sendUser remote unless @peers[remote.address]? #only send user informations if peer is unknown
      @_addPeer remote, msg.data

    @socket.on @socket.TYPES_NETWORK.peerInformations, (msg, remote) =>
      return if @_isYourself remote #ignore own messages
      @_addPeer remote, msg.data

  getPeerInfos: (address) ->
    return @peers[address].infos

  _addPeer: (remote, remoteInfos) ->
    # check if peer already exists
    if @peers[remote.address]?
      @peers[remote.address].reset() #reset timer for delete
      return  #return if we have this peer already

    createPeer = (infos, network, context) ->
      start = ->
        @timeout = setTimeout @remove.bind(context, @network.address), context.intervalTime + 500
      reset = ->
        clearTimeout @timeout
        @start()

      obj =
        infos: infos
        network: network
        start: start
        reset: reset
        remove: context._removePeer
      
      return obj

    peer = createPeer remoteInfos, remote, @
    peer.start()
    @peers[remote.address] = peer

    @emit 'newPeer', peer.network, peer.infos

  _removePeer: (address) ->
    delete @peers[address]
    @emit 'removePeer', address

  _sendAnswer: (remote) ->
    msg = 
      type: @socket.TYPES_NETWORK.broadcastAnswer
      data: @user.getInfos()
    @socket.send msg, remote.address, remote.port

  _sendUser: (remote) ->
    msg = 
      type: @socket.TYPES_NETWORK.peerInformations
      data: @user.getInfos()
    @socket.send msg, remote.address, remote.port

  _sendBroadcasts: ->
    for network in @interfaces
      do (network) =>
        @socket.sendBroadcast {type: @socket.TYPES_NETWORK.broadcast}, network.broadcast

  _isYourself: (remote) ->
    for network in @interfaces
      return true if remote.address is network.address
    return false
  
module.exports = Broadcaster