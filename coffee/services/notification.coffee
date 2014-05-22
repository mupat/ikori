Window = global.window.nwDispatcher.requireNwGui()['Window']
screen = window.screen

os = require 'os'
displayNotification = require 'display-notification'

class Notification
  TEMPLATE: 'app://local/notification.html' #template, relative to the root path
  OPTIONS: # options for the new window
    frame: false
    toolbar: false
    width: 300
    height: 50
    'always-on-top': true
    show: false
    resizable: false
    focus: false

  focus: true  #hold if the main window has focus or not
  notifications: {} #hold the open windows

  constructor: ($rootScope) ->
    @main = Window.get()
    @main.on 'blur', =>
      console.log 'focue lost'
      @focus = false

    @main.on 'focus', =>
      console.log 'got focus'
      @focus = true

    @main.on 'close', =>
      @_closeAllNotifications()
      @main.close true

  new: (origin, text) ->
    console.log 'new notif', @focus
    return if @focus # return if the chat has focus from the user

    if os.platform() is 'darwin'
      displayNotification {title: origin, subtitle: text}
    else
      #create new window
      notification = Window.open @TEMPLATE, @OPTIONS
      index = Object.keys(@notifications).length + 1
      @notifications[index] = notification

      notification.on 'loaded', @_newWindowLoaded.bind(@, index, origin, text)
      notification.once 'focus', @_newWindowFocus.bind(@, index)

  _closeAllNotifications: ->
    for index, notification of @notifications
      notification.close()
      delete @notifications[index]

  _newWindowFocus: (index) ->
    notification = @notifications[index]
    @_closeAllNotifications()

    @main.focus()

  _newWindowLoaded: (index, origin, text) ->
    notification = @notifications[index]
    dom = notification.window.document # get dom from new window

    # set origin and text
    dom.getElementById('origin').innerHTML = origin
    dom.getElementById('text').innerHTML = text

    #move element to upper right corner
    pos = @_calcPosition()
    notification.moveTo pos.x, pos.y
    notification.show() #finally show the new window

  _calcPosition: ->
    openCount = Object.keys(@notifications).length

    return {
      x: (screen.availLeft + screen.availWidth) - @OPTIONS.width - 25
      y: (screen.availTop * openCount) + (openCount * @OPTIONS.height) + 25
    }

module.exports = Notification