localStorage = window.localStorage

class Peer
  peers: {}

  constructor: (@$rootScope, @config) ->

  get: (uuid) ->
    return @peers[uuid]

  add: (remote, data) ->
    uuid = data.uuid || remote.uuid

    # check if peer already exists
    if @exists(uuid)
      @peers[uuid].resetTimer() #reset timer for delete
      @peers[uuid].infos = data
      @$rootScope.$broadcast 'peer.update', @peers[uuid].infos
      return  #return if we have this peer already

    peer = @_createPeer data, remote
    @peers[uuid] = peer

    @$rootScope.$broadcast 'peer.new', peer.infos

  remove: (uuid) ->
    return unless @exists(uuid)
    @$rootScope.$broadcast 'peer.remove', @peers[uuid].infos
    delete @peers[uuid]

  getName: (uuid) ->
    @_exists uuid
    return @peers[uuid].infos.name

  getHistory: (uuid) ->
    @_exists uuid
    return @peers[uuid].history

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

  addHistoryEntry: (uuid, obj) ->
    @peers[uuid].history.push obj
    localStorage[@_buildKey(uuid)] = JSON.stringify(@peers[uuid].history)

  _buildKey: (uuid) ->
    return "peers.#{uuid}.history"

  _exists: (uuid) ->
    throw new Error('peer doesnt exists') unless @exists uuid

  _createPeer: (infos, network) ->
    context = @
    start = ->
      @timeout = setTimeout context.remove.bind(context, @infos.uuid), (context.config.broadcastInterval + 500)
    reset = ->
      clearTimeout @timeout
      @startTimer()

    obj =
      infos: infos
      network: network
      startTimer: start
      resetTimer: reset
      history: JSON.parse(localStorage[context._buildKey(infos.uuid)] || '[]')
    
    obj.startTimer()
    return obj

module.exports = Peer