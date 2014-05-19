dgram = require 'dgram'

class Broadcaster
  PORT: 4000
  TYPES:
    broadcast: 'broadcast'
    broadcastAnswer: 'broadcast_answer'
    peerInformations: 'peer_infos'
    offer: 'offer'
    answer: 'answer'
    ice: 'ice'
    close: 'close'

  constructor: (@$rootScope, @user, network) ->
    @networkInterfaces = network.interfaces
    @socket = dgram.createSocket 'udp4'
    # add msg routing
    @socket.on 'message', (msg, remote) =>
      try
        msgJSON = JSON.parse msg
      catch e
        return @$rootScope.$emit 'error', 'got message that isnt a json string', msg.toString(), remote

      return if @_isOwnRemote remote #ignore own messages

      @$rootScope.$broadcast 'received', remote, msg.toString()
      switch msgJSON.type
        when @TYPES.broadcast then @sendBroadcastAnswer remote
        when @TYPES.broadcastAnswer then @sendPeerInformations(remote); @$rootScope.$broadcast('newPeer', remote, msgJSON.data);
        when @TYPES.peerInformations then @$rootScope.$broadcast 'newPeer', remote, msgJSON.data
        when @TYPES.offer then @$rootScope.$broadcast 'offer', remote, msgJSON.data
        when @TYPES.answer then @$rootScope.$broadcast 'answer', remote, msgJSON.data
        when @TYPES.ice then @$rootScope.$broadcast 'ice', remote, msgJSON.data
        when @TYPES.close then @$rootScope.$broadcast 'remoteClose', remote
        else @$rootScope.$emit 'error', 'got message with undefined type', msgJSON, remote

  sendBroadcasts: ->
    @socket.on 'listening', =>
      for network in @networkInterfaces
        @sendBroadcast network.broadcast

    @socket.bind @PORT

  sendICE: (ice, remote) ->
    @_send {type: @TYPES.ice, data: ice}, remote.port, remote.address

  sendAnswer: (answer, remote) ->
    @_send {type: @TYPES.answer, data: answer}, remote.port, remote.address

  sendOffer: (offer, remote) ->
    @_send {type: @TYPES.offer, data: offer}, remote.port, remote.address

  sendBroadcastAnswer: (remote) ->
    data = @user.getInfos()
    @_send {type: @TYPES.broadcastAnswer, data: data}, remote.port, remote.address

  sendPeerInformations: (remote) ->
    data = @user.getInfos()
    @_send {type: @TYPES.peerInformations, data: data}, remote.port, remote.address

  sendBroadcast: (address) ->
    @_send {type: @TYPES.broadcast}, @PORT, address, true

  sendClose: (remote) ->
    @_send {type: @TYPES.close}, remote.port, remote.address

  _send: (msgJSON, port, address, broadcast = false) ->
    try
      msgStr = JSON.stringify msgJSON
    catch e
      return @$rootScope.$emit 'error', 'msg json is not valid', e

    msg = new Buffer msgStr
    @socket.setBroadcast broadcast
    @socket.send msg, 0, msg.length, port, address, (err, bytes) =>
      return @$rootScope.$emit 'error' if err
      @$rootScope.$emit 'sent', msgStr

  _isOwnRemote: (remote) ->
    for network in @networkInterfaces
      return true if remote.address is network.address
    return false

module.exports = Broadcaster