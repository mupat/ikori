Connection = require './connection'

class Offerer extends Connection
  CHANNEL: "channel"
  constructor: (remote, stream) ->
    console.log 'create offer', stream
    super remote, stream

    @channel = @con.createDataChannel @CHANNEL, @CHANNEL_OPTIONS
    @con.createOffer @_sendOffer

  _sendOffer: (desc) =>
    @con.setLocalDescription desc
    @emit 'offer', desc, @remote

 module.exports = Offerer