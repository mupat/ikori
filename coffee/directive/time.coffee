moment = require 'moment'

class Time
  constructor: ->
    obj = 
      restrict: 'E'
      replace: true
      link: @run.bind(@)
    return obj

  run: (scope, element, attr) ->
    #return if don't have a lasttime timestamp, this happens if we have the first entry of a history log
    return if !attr.lasttime? or attr.lasttime.length is 0

    #parse timestamps to moment obj
    actualTime = moment.utc Number(attr.actualtime)
    lastTime = moment.utc Number(attr.lasttime)

    #check if lasttime day is before actualtime day
    if lastTime.isBefore(actualTime, 'day')
      element.html '<li class="timescope">' + lastTime.fromNow() + '</li>'
   
module.exports = Time