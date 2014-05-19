Connection = require './connection'

class Answerer extends Connection  
  constructor: (remote, offer) ->
    super remote

    @con.setRemoteDescription new window.RTCSessionDescription(offer)
    @con.createAnswer @_sendAnswer

    @con.ondatachannel = (event) =>
      @channel = event.channel
      @emit 'datachannel', @channel, @remote

  _sendAnswer: (desc) =>
    @con.setLocalDescription desc
    @emit 'answer', desc, @remote

 module.exports = Answerer