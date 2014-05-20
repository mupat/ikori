path = "./public/js/controller/"
Start = require "#{path}start"
PeerCtrl = require "#{path}peer"
MsgCtrl = require "#{path}msg"
HistoryCtrl = require "#{path}history"
UserCtrl = require "#{path}user"

chatAppControllers = angular.module 'chatApp.controllers', []

chatAppControllers.controller 'PeerCtrl', [
  '$scope'
  'broadcaster'
  'webrtc'
  PeerCtrl
]
chatAppControllers.controller 'MsgCtrl', [
  '$rootScope'
  '$scope'
  'webrtc'
  MsgCtrl
]
chatAppControllers.controller 'HistoryCtrl', [
  '$scope'
  'user'
  HistoryCtrl
]
chatAppControllers.controller 'UserCtrl', [
  '$scope'
  'user'
  UserCtrl
]

chatAppControllers.run ['$rootScope', 'broadcaster', Start]
