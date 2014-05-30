path = "./public/js/controller/"
Start = require "#{path}start"
PeerCtrl = require "#{path}peer"
MsgCtrl = require "#{path}message"
HistoryCtrl = require "#{path}history"
OptionsCtrl = require "#{path}options"

chatAppControllers = angular.module 'chatApp.controllers', []

chatAppControllers.controller 'PeerCtrl', [
  '$rootScope'
  '$scope'
  'webrtc'
  'peer'
  PeerCtrl
]
chatAppControllers.controller 'MsgCtrl', [
  '$rootScope'
  '$scope'
  MsgCtrl
]
chatAppControllers.controller 'HistoryCtrl', [
  '$scope'
  'peer'
  HistoryCtrl
]
chatAppControllers.controller 'OptionsCtrl', [
  '$rootScope'
  '$scope'
  'CONFIG'
  OptionsCtrl
]

chatAppControllers.run ['network', 'notification', Start]
