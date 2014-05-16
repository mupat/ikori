class PeerConnection
  CON_OPTIONS: 
    optional: [
      RTPDataChannels: true
    ]
  CHANNEL_OPTIONS:
    reliable: true
    
  constructor: (@$rootScope, @broadcaster, type, remote, offer = null) ->
    @con = new window.webkitRTCPeerConnection null, @CON_OPTIONS
    @con.onicecandidate = (event) =>
      @broadcaster.sendICE event.candidate, remote if event.candidate

    switch type
      when 'answerer' then @_createAnswerer remote, offer
      when 'offerer' then @_createOfferer remote    

  setICE: (msg) ->
    candidate = 
      sdpMLineIndex: msg.sdpMLineIndex,
      candidate: msg.candidate
      
    @con.addIceCandidate new window.RTCIceCandidate(candidate)

  setRemoteDescription: (msg) ->
    @con.setRemoteDescription new window.RTCSessionDescription(msg)

  _createAnswerer: (remote, offer) ->
    @con.setRemoteDescription new window.RTCSessionDescription(offer)

    sendDescription = (desc) =>
      @con.setLocalDescription desc
      @broadcaster.sendAnswer desc, remote

    @con.createAnswer sendDescription

    @con.ondatachannel = (event) =>
      @channel = event.channel
      @_addChannelEvents()

  _createOfferer: (remote) ->
    @channel = @con.createDataChannel "channel", @CHANNEL_OPTIONS
    @_addChannelEvents()

    sendOffer = (desc) =>
      @con.setLocalDescription desc
      @broadcaster.sendOffer desc, remote

    @con.createOffer sendOffer

  _addChannelEvents: ->
    @channel.onmessage = (event) =>
      @$rootScope.$broadcast 'newMessage', event.data, event, @con, @channel

    @channel.onerror = (error) =>
      @$rootScope.$emit 'error', 'error during the datachannel', error, @con, @channel

    @channel.onopen = =>
      @$rootScope.$broadcast 'open', @con, @channel

    @channel.onclose = =>
      @$rootScope.$broadcast 'close', @con, @channel

module.exports = PeerConnection