Window = global.window.nwDispatcher.requireNwGui()['Window']
screen = window.screen

os = require 'os'
notify = require 'node-notify'

class Notification
  MARGIN: 25 #margin to top and right
  GROUP_ID: 'chat' #group id for notifications on mac
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
  notification: null

  constructor: ($rootScope) ->
    @main = Window.get()
    @main.on 'blur', =>
      console.log 'focue lost'
      @focus = false

    @main.on 'focus', =>
      console.log 'got focus'
      @focus = true

    @main.on 'close', =>
      @_removeNotification()
      @main.close true

    #register for new remote messages
    $rootScope.$on 'newRemoteMessage', (scope, msg, event, remote) =>
      @new remote.address, msg

  new: (origin, text) ->
    console.log 'new notif', @focus
    return if @focus # return if the chat has focus from the user

    if os.platform() is 'darwin' #show other notification on mac
      notify {title: origin, msg: text, group: @GROUP_ID, sender: 'com.mupat.nodechat'}
    else
      #check if a notification is open
      @_removeNotification() if @notification?

      #create new window
      @notification = Window.open @TEMPLATE, @OPTIONS
      @notification.on 'loaded', @_onLoad.bind(@, origin, text)
      @notification.once 'focus', @_onFocus.bind(@)

  _removeNotification: ->
    if os.platform() is 'darwin'
      notify remove: @GROUP_ID
    else 
      @notification.close()
      @notification = null

  _onFocus: ->
    @_removeNotification()
    @main.focus()

  _onLoad: (origin, text) ->
    dom = @notification.window.document # get dom from new window

    # set origin and text
    dom.getElementById('origin').innerHTML = origin
    dom.getElementById('text').innerHTML = text

    #move notification to upper right corner
    pos = @_calcPosition()
    @notification.moveTo pos.x, pos.y
    @notification.show() #finally show the new window
    setTimeout @_removeNotification.bind(@), 1000

  _calcPosition: ->
    return {
      x: (screen.availLeft + screen.availWidth) - @OPTIONS.width - @MARGIN
      y: screen.availTop + @MARGIN
    }

module.exports = Notification