class Start
  constructor: (network, notification) ->
    # start the broadcast
    network.start()

    show = ->
      notification.new('test', 'test test test ')

    setInterval(show, 3000)

module.exports = Start