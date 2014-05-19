Connection = require './connection'

class Offerer extends Connection
  CHANNEL: "channel"
  constructor: (remote, offer) ->
    super remote

    @channel = @con.createDataChannel @CHANNEL, @CHANNEL_OPTIONS
    @con.createOffer @_sendOffer

  _sendOffer: (desc) =>
    @con.setLocalDescription desc
    @emit 'offer', desc, @remote

 module.exports = Offerer