dgram = require 'dgram'
EventEmitter = require('events').EventEmitter

class Socket extends EventEmitter
  constructor: (config) ->
    @PORT = config.getPort()
    @socket = dgram.createSocket 'udp4'
  
module.exports = Socket