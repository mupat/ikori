os = require 'os'

class User
  infos: {}
  constructor: ->
    @infos =
      name: os.hostname()

  getInfos: ->
    return @infos

  getNetworks: ->
    return os.networkInterfaces()
  
module.exports = User