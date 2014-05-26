require 'coffee-script/register'
async = require 'async'
exec = require('child_process').exec
os = require 'os'
fs = require 'fs'
uuid = require 'uuid'

getUser = (cb) ->
  exec 'whoami', (err, stdout) =>
    return cb err if err

    #get uuid from localstorage, if don't have one, we create a new uuid
    localStorage.uuid = id = uuid.v1() unless (id = localStorage.uuid)?

    user = 
      host: os.hostname() 
      name: stdout.replace('\n', '')
      interfaces: os.networkInterfaces()
      platform: os.platform()
      uuid: id
    cb null, user

getConfig = (cb) ->
  fs.readFile 'config/user.json', (err, content) ->
    return cb err if err
    try
      configFile = JSON.parse content
    catch e
      return cb e

    #explicit map properties from config file to object to have default values for old config files
    config =
      port: configFile.port || 4000
      broadcastInterval: configFile.broadcastInterval || 1000 
      notificationInterval: configFile.notificationInterval || 1000
      logging: false

    cb null, config

# start angular app, AFTER we load the user and config obj
async.series {
  user: getUser
  config: getConfig
}, (err, results) ->
  if err
    console.log 'error during init', err
    process.exit 1

  chatApp = angular.module 'chatApp', [
    'chatApp.controllers'
    'chatApp.services'
  ]
  chatApp.constant 'USER', results.user
  chatApp.constant 'CONFIG', results.config
  chatApp.factory '$exceptionHandler', ->
    return (exception, cause) ->
      console.log 'error', exception.message, exception.stack
      console.log 'cause', cause
  
  angular.bootstrap document, ['chatApp']