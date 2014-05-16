PeerConnection = require './peer_connection'

class WebRTC
  peerConnections: {}
  constructor: (@$rootScope, @broadcaster) ->
    @$rootScope.$on 'offer', (scope, remote, offer) =>
      return if @_connectionExists remote
      peer = @_connectByAnswer remote, offer
      @peerConnections[remote.address] = peer

    @$rootScope.$on 'ice', (scope, remote, ice) =>
      return if @_connectionExists remote
      @peerConnections[remote.address].setICE ice

    @$rootScope.$on 'answer', (scope, remote, desc) =>
      return if @_connectionExists remote
      @peerConnections[remote.address].setRemoteDescription desc

  connect: (remote) ->
    return if @_connectionExists remote
    peer = @_connectByOffer remote
    @peerConnections[remote.address] = peer

  _connectionExists: (remote) ->
    con = @peerConnections[remote.address]
    return con?.channel?.readyState is 'open'

  _connectByAnswer: (remote, offer) ->
    return new PeerConnection @$rootScope, @broadcaster, 'answerer', remote, offer

  _connectByOffer: (remote) ->
    return new PeerConnection @$rootScope, @broadcaster, 'offerer', remote

module.exports = WebRTC