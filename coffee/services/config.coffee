class Config
  constructor: ->
    @config = 
      port: 4000
      interval: 1000 #milliseconds
      logging: false

  get: (key) ->
    return @config[key]
  
module.exports = Config