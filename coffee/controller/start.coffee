class Start
  constructor: (network, notification) ->
    global.window.nwDispatcher.requireNwGui()['Window'].get().show() # show window
    network.start() # start the network broadcaster

module.exports = Start