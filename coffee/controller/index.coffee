path = "./public/js/controller/"
Start = require "#{path}start"
PeerCtrl = require "#{path}peer"
MsgCtrl = require "#{path}message"
HistoryCtrl = require "#{path}history"
UserCtrl = require "#{path}user"

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
chatAppControllers.controller 'UserCtrl', [
  '$rootScope'
  '$scope'
  'CONFIG'
  UserCtrl
]

chatAppControllers.run ['network', 'notification', Start]
