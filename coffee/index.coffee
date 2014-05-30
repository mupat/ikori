require 'coffee-script/register'
async = require 'async'
exec = require('child_process').exec
os = require 'os'
uuid = require 'uuid'
localStorage = window.localStorage

getName = (cb) ->
  name = localStorage.name
  if name?
    cb null, name
  else
    exec 'whoami', (err, stdout) =>
      return cb err if err
      return cb null, stdout.replace('\n', '')

buildConfig = (name, cb) ->
  #get uuid from localstorage, if don't have one, we create a new uuid
  localStorage.uuid = id = uuid.v1() unless (id = localStorage.uuid)?

  config = 
    port: Number(localStorage.port || 4000)
    broadcastInterval: Number(localStorage.broadcastInterval || 1000)
    notificationInterval: Number(localStorage.notificationInterval || 3000)
    logging: JSON.parse(localStorage.logging || false)
    bundleIdentifier: 'com.mupat.nodechat'
    host: os.hostname()
    interfaces: os.networkInterfaces()
    platform: os.platform()
    uuid: id
    name: name

  cb null, config

# start angular app, AFTER we load the user and config obj
async.waterfall [
  getName
  buildConfig
], (err, results) ->
  if err
    console.log 'error during init', err.message, err.stack
    process.exit 1

  chatApp = angular.module 'chatApp', [
    'chatApp.controllers'
    'chatApp.services'
    'chatApp.directives'
  ]
  chatApp.value 'CONFIG', results
  chatApp.factory '$exceptionHandler', ->
    return (exception, cause) ->
      console.log 'error', exception.message, exception.stack
      console.log 'cause', cause
  
  angular.bootstrap document, ['chatApp']