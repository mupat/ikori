Netmask = require('netmask').Netmask
os = require 'os'

class Network
  IP6: 'IPv6'
  constructor: ->
    console.log 'network contrs'
    @interfaces = @cleanup os.networkInterfaces()
    @addBroadcastAddress network for network in @interfaces
    # @block = new Netmask(network.address, network.netmask);

  # add broadcast address to every network interface
  addBroadcastAddress: (network) ->
    block = new Netmask network.address, network.netmask
    network.broadcast = block.broadcast

  # remove not used network interfaces, like internal and IPv6
  cleanup: (networkInterfaces) ->
    usableNetworks = []
    for name, networks of networkInterfaces
      for network in networks
        if !network.internal and network.family isnt @IP6
          obj = 
            address: network.address
            netmask: network.netmask
            name: name
          usableNetworks.push obj

    return usableNetworks

module.exports = Network