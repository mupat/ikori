Netmask = require('netmask').Netmask

class Interfaces
  IP6: 'IPv6'
  constructor: (networks) ->
    @interfaces = @_cleanup networks
    @_addBroadcastAddress network for network in @interfaces

  get: ->
    console.log 'inter', @interfaces
    return @interfaces

  # add broadcast address to every network interface
  _addBroadcastAddress: (network) ->
    block = new Netmask network.address, network.netmask
    network.broadcast = block.broadcast

  # remove not used network interfaces, like internal and IPv6
  _cleanup: (networkInterfaces) ->
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

module.exports = Interfaces