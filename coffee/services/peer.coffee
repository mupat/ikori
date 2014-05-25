localStorage = window.localStorage

class Peer
  peers: {}

  constructor: (@$rootScope, @config) ->
    @$rootScope.$on 'message.own', (scope, msg, uuid) =>
      console.log 'own message'
      @_addHistoryEntry uuid, msg, 'you'

    @$rootScope.$on 'message.peer', (scope, msg, uuid) =>
      console.log 'remote message'
      @_addHistoryEntry uuid, msg, @peers[uuid].infos.name

    # @$rootScope.$on 'channel.open', (scope, uuid) =>
    #   @peers[uuid].history = JSON.parse(localStorage[@_buildKey(uuid)] || [])

    # @$rootScope.$on 'channel.close', (scope, uuid) =>
    #   @peers[uuid].open = false

  get: (uuid) ->
    return @peers[uuid]

  add: (remote, data) ->
    uuid = data.uuid || remote.uuid

    # check if peer already exists
    if @peers[uuid]?
      # @peers[uuid].resetTimer() #reset timer for delete
      return  #return if we have this peer already

    peer = @_createPeer data, remote
    @peers[uuid] = peer

    @$rootScope.$broadcast 'peer.new', peer.infos

  remove: (uuid) ->
    @$rootScope.$broadcast 'peer.remove', @peers[uuid].infos
    delete @peers[uuid]

  getName: (uuid) ->
    @_exists uuid
    return @peers[uuid].info.name
    return ''

  getHistory: (uuid) ->
    @_exists uuid
    history = @peers[uuid].history
    unless history?
      history = JSON.parse(localStorage[@_buildKey(uuid)] || [])
      @peers[uuid].history = history
    
    return history

  exists: (uuid) ->
    return @peers[uuid]?

  setConnection: (uuid, con) ->
    @_exists uuid
    @peers[uuid].con = con

  getConnection: (uuid) ->  
    @_exists uuid
    return @peers[uuid].con

  hasConnection: (uuid) ->
    @_exists uuid
    con = @getConnection uuid
    return con?.channel?.readyState is 'open'

  getRemote: (uuid) ->
    @_exists uuid
    return {
      address: @peers[uuid].network.address
      port: @peers[uuid].network.port
      uuid: @peers[uuid].infos.uuid
    }

  _addHistoryEntry: (uuid, msg, origin) ->
    obj = 
      time: new Date()
      msg: msg
      origin: origin

    @peers[uuid].history.push obj
    localStorage[@_buildKey(uuid)] = JSON.stringify(@peers[uuid].history)
    # @$rootScope.$broadcast 'peer.message', obj

  _buildKey: (uuid) ->
    return "peers.#{uuid}.history"

  _exists: (uuid) ->
    throw new Error('peer doesnt exists') unless @exists uuid

  _createPeer: (infos, network) ->
    context = @
    start = ->
      console.log 'start', context.config.broadcastInterval
      @timeout = setTimeout context.remove(@infos.uuid), context.config.broadcastInterval + 500
    reset = ->
      clearTimeout @timeout
      @startTimer()

    obj =
      infos: infos
      network: network
      startTimer: start
      resetTimer: reset
      # open: false
      # history: []
    
    # obj.startTimer()
    return obj

module.exports = Peer