Answerer = require './answerer'
Offerer = require './offerer'

class WebRTC
  connections: {}
  constructor: (@$rootScope, @broadcaster) ->
    @$rootScope.$on 'offer', (scope, remote, offer) =>
      return if @_connectionExists remote
      @_connectByAnswer remote, offer

    @$rootScope.$on 'ice', (scope, remote, ice) =>
      return if @_connectionExists remote
      return @$rootScope.$emit 'error', 'no connection for ice candidate', remote, ice unless @connections[remote.address]?
      @connections[remote.address].setICE ice

    @$rootScope.$on 'answer', (scope, remote, desc) =>
      return if @_connectionExists remote
      @connections[remote.address].setRemoteDescription desc

  connect: (remote) ->
    return if @_connectionExists remote
    @_connectByOffer remote

  close: (remote) ->
    con = @connections[remote.address]
    con.channel.close()
    con.con.close()
    delete @connections[remote.address]

  _connectionExists: (remote) ->
    con = @connections[remote.address]
    return con?.channel?.readyState is 'open'

  _connectByAnswer: (remote, offer) ->
    answerer = new Answerer remote, offer
    answerer.on 'ice', @_sendICE.bind(@, answerer)
    answerer.on 'datachannel', @_registerChannelEvents.bind(@, answerer)
    answerer.on 'answer', (desc, remote) =>
      @broadcaster.sendAnswer desc, remote

    @connections[remote.address] = answerer

  _connectByOffer: (remote) ->
    offerer = new Offerer remote
    offerer.on 'ice', @_sendICE.bind(@, offerer)
    @_registerChannelEvents offerer, offerer.channel, offerer.remote
    offerer.on 'offer', (desc, remote) =>
      @broadcaster.sendOffer desc, remote

    @connections[remote.address] = offerer

  _registerChannelEvents: (con, channel, remote) ->
    channel.onmessage = (event) =>
      @$rootScope.$broadcast 'newMessage', event.data, event, channel, con, remote

    channel.onerror = (error) =>
      @$rootScope.$emit 'error', 'error by using the datachannel', error, channel, con, remote

    channel.onopen = =>
      @$rootScope.$broadcast 'open', channel, con, remote

    channel.onclose = =>
      @$rootScope.$broadcast 'close', channel, con, remote

  _sendICE: (con, candidate, remote) ->
    @broadcaster.sendICE candidate, remote unless con.signalingState is 'stable'

module.exports = WebRTC