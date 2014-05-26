EventEmitter = require('events').EventEmitter

class Broadcaster extends EventEmitter
  constructor: (@socket, @interfaces, @user, @config, @peer) ->
    @socket.on 'ready', =>
      @_sendBroadcasts() #send initial broadcast
      setInterval @_sendBroadcasts.bind(@), @config.broadcastInterval #send broadcast in given interval

    @socket.on @socket.TYPES_NETWORK.broadcast, (msg, remote) =>
      return if @_isYourself remote.address #ignore own messages
      @_sendAnswer remote

    @socket.on @socket.TYPES_NETWORK.broadcastAnswer, (msg, remote) =>
      return if @_isYourself remote.address #ignore own messages
      @_sendUser remote unless @peer.exists msg.uuid #only send user informations if peer is unknown
      @peer.add remote, msg.data

    @socket.on @socket.TYPES_NETWORK.peerInformations, (msg, remote) =>
      return if @_isYourself remote.address #ignore own messages
      @peer.add remote, msg.data

  _sendAnswer: (remote) ->
    msg = 
      type: @socket.TYPES_NETWORK.broadcastAnswer
      data: @_buildUser()
    @socket.send msg, remote.address, remote.port

  _sendUser: (remote) ->
    msg = 
      type: @socket.TYPES_NETWORK.peerInformations
      data: @_buildUser()
    @socket.send msg, remote.address, remote.port

  _buildUser: ->
    return {
      name: @user.name
      uuid: @user.uuid
    }

  _sendBroadcasts: ->
    for network in @interfaces
      do (network) =>
        @socket.sendBroadcast {type: @socket.TYPES_NETWORK.broadcast}, network.broadcast

  _isYourself: (address) ->
    for network in @interfaces
      return true if address is network.address
    return false
  
module.exports = Broadcaster