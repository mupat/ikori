path = "./js/controller/"
Start = require "#{path}start"
PeerCtrl = require "#{path}peer"
MsgCtrl = require "#{path}msg"
HistoryCtrl = require "#{path}history"

chatAppControllers = angular.module 'chatApp.controllers', []

chatAppControllers.controller 'PeerCtrl', [
  '$scope'
  'broadcaster'
  'webrtc'
  PeerCtrl
]
chatAppControllers.controller 'MsgCtrl', [
  '$scope'
  'webrtc'
  MsgCtrl
]
chatAppControllers.controller 'HistoryCtrl', [
  '$scope'
  HistoryCtrl
]

chatAppControllers.run ['$rootScope', 'broadcaster', Start]
