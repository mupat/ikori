class Start
  constructor: (network, notification) ->
    global.window.nwDispatcher.requireNwGui()['Window'].get().show() # show window
    network.start() # start the network broadcaster

    # show = ->
    #   notification.new('test', 'test test test ')

    # setInterval(show, 3000)

module.exports = Start