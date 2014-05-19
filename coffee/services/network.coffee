Netmask = require('netmask').Netmask

class Network
  IP6: 'IPv6'
  constructor: (user) ->
    @interfaces = @cleanup user.getNetworks()
    @addBroadcastAddress network for network in @interfaces

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