dgram = require 'dgram'
os = require 'os'

class Broadcaster
  PORT: 4000
  TYPES:
    broadcast: 'broadcast'
    broadcastAnswer: 'broadcast_answer'
    peerInformations: 'peer_infos'
    offer: 'offer'
    answer: 'answer'
    ice: 'ice'

  constructor: (@$rootScope, network) ->
    @networkInterfaces = network.interfaces
    @socket = dgram.createSocket 'udp4'
    # add msg routing
    @socket.on 'message', (msg, remote) =>
      try
        msgJSON = JSON.parse msg
      catch e
        return @$rootScope.$emit 'error', 'got message that isnt a json string', msg.toString(), remote

      return if @_isOwnRemote remote #ignore own messages

      switch msgJSON.type
        when @TYPES.broadcast then @sendBroadcastAnswer remote
        when @TYPES.broadcastAnswer then @sendPeerInformations(remote); @$rootScope.$emit('newPeer', remote, msgJSON.data);
        when @TYPES.peerInformations then @$rootScope.$emit 'newPeer', remote, msgJSON.data
        when @TYPES.offer then @$rootScope.$emit 'offer', msgJSON.data
        when @TYPES.answer then @$rootScope.$emit 'answer', msgJSON.data
        when @TYPES.ice then @$rootScope.$emit 'ice', msgJSON.data
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
    data = @_getUserInfos()
    @_send {type: @TYPES.broadcastAnswer, data: data}, remote.port, remote.address

  sendPeerInformations: (remote) ->
    data = @_getUserInfos()
    @_send {type: @TYPES.peerInformations, data: data}, remote.port, remote.address

  sendBroadcast: (address) ->
    data = @_getUserInfos
    @_send {type: @TYPES.broadcast, data: data}, @PORT, address, true

  _getUserInfos: ->
    return {
      name: os.hostname()
    }

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