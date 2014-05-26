Answerer = require './answerer'
Offerer = require './offerer'

class WebRTC
  constructor: (@$rootScope, @network, @peer) ->
    @$rootScope.$on 'offer', (scope, remote, offer) =>
      return if @peer.hasConnection(remote.uuid)
      @_connectByAnswer remote, offer

    @$rootScope.$on 'ice', (scope, remote, ice) =>
      return if @peer.hasConnection(remote.uuid)
      @peer.getConnection(remote.uuid).setICE ice

    @$rootScope.$on 'answer', (scope, remote, desc) =>
      return if @peer.hasConnection(remote.uuid)
      @peer.getConnection(remote.uuid).setRemoteDescription desc

    @$rootScope.$on 'peer.remove', (scope, infos) =>
      @_close infos.uuid

    @$rootScope.$on 'message.own', (scope, msg, uuid) =>
      @send uuid, msg

    @$rootScope.$on 'message.screen', (scope, uuid) =>
      return unless @peer.hasConnection(uuid)
      console.log 'event and create'
      @peer.getConnection(uuid).createStream()

  send: (uuid, msg) ->
    return unless @peer.hasConnection(uuid)
    @peer.getConnection(uuid).send msg

  connect: (uuid) ->
    if @peer.hasConnection(uuid)
      @$rootScope.$broadcast 'channel.open', uuid #emit open event, as it is already open
      return

    @_connectByOffer @peer.getRemote(uuid)

  _close: (uuid) ->
    con = @peer.getConnection uuid
    return unless con?
    con.channel.close()
    con.con.close()

  _connectByAnswer: (remote, offer) ->
    answerer = new Answerer remote, offer
    answerer.on 'ice', @_sendICE.bind(@, answerer)
    answerer.on 'datachannel', @_registerChannelEvents.bind(@, answerer)
    answerer.on 'answer', (desc, remote) =>
      @network.send 'answer', remote, desc

    @peer.setConnection remote.uuid, answerer

  _connectByOffer: (remote) ->
    offerer = new Offerer remote
    offerer.on 'ice', @_sendICE.bind(@, offerer)
    @_registerChannelEvents offerer, offerer.channel, remote.uuid
    offerer.on 'offer', (desc, remote) =>
      @network.send 'offer', remote, desc

    @peer.setConnection remote.uuid, offerer

  _registerChannelEvents: (con, channel, uuid) ->
    con.on 'stream', (stream) =>
      console.log 'got stream'
      @$rootScope.$broadcast 'message.stream', stream

    channel.onmessage = (event) =>
      @$rootScope.$broadcast 'message.peer', event.data, uuid

    channel.onerror = (error) =>
      @$rootScope.$emit 'error', 'error by using the datachannel', error, uuid

    channel.onopen = =>
      @$rootScope.$broadcast 'channel.open', uuid

    channel.onclose = =>
      @$rootScope.$broadcast 'channel.close', uuid

  _sendICE: (con, candidate, remote) ->
    @network.send 'ice', remote, candidate unless con.signalingState is 'stable'

module.exports = WebRTC