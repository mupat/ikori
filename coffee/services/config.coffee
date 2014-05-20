fs = require 'fs'

class Config
  constructor: ->
    @config = 
      port: 4000
      interval: 1000 #milliseconds

  getPort: ->
    return @config.port

  getInterval: ->
    return @config.interval
  
module.exports = Config