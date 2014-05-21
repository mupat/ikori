Answerer = require './answerer'
Offerer = require './offerer'

class WebRTC
  connections: {}
  constructor: (@$rootScope, @network) ->
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

    @$rootScope.$on 'remoteClose', (scope, address) =>
      @_close address

  send: (remote, msg) ->
    return unless @_connectionExists remote
    @connections[remote.address].channel.send msg

  connect: (remote) ->
    if @_connectionExists remote
      @$rootScope.$broadcast 'open', remote
      return 
    @_connectByOffer remote

  close: (remote) ->
    @_close remote.address
    @network.send 'close', remote
        
  _close: (address) ->
    con = @connections[address]
    return unless con?
    con.channel.close()
    con.con.close()
    delete @connections[address]

  _connectionExists: (remote) ->
    con = @connections[remote.address]
    return con?.channel?.readyState is 'open'

  _connectByAnswer: (remote, offer) ->
    answerer = new Answerer remote, offer
    answerer.on 'ice', @_sendICE.bind(@, answerer)
    answerer.on 'datachannel', @_registerChannelEvents.bind(@, answerer)
    answerer.on 'answer', (desc, remote) =>
      @network.send 'answer', remote, desc

    @connections[remote.address] = answerer

  _connectByOffer: (remote) ->
    offerer = new Offerer remote
    offerer.on 'ice', @_sendICE.bind(@, offerer)
    @_registerChannelEvents offerer, offerer.channel, offerer.remote
    offerer.on 'offer', (desc, remote) =>
      @network.send 'offer', remote, desc

    @connections[remote.address] = offerer

  _registerChannelEvents: (con, channel, remote) ->
    channel.onmessage = (event) =>
      @$rootScope.$broadcast 'newRemoteMessage', event.data, event, remote, channel, con

    channel.onerror = (error) =>
      @$rootScope.$emit 'error', 'error by using the datachannel', error, remote, channel, con

    channel.onopen = =>
      @$rootScope.$broadcast 'open', remote, channel, con

    channel.onclose = =>
      @$rootScope.$broadcast 'close', remote, channel, con

  _sendICE: (con, candidate, remote) ->
    @network.send 'ice', remote, candidate unless con.signalingState is 'stable'

module.exports = WebRTC