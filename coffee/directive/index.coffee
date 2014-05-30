path = "./public/js/directive/"
width = require "#{path}width"

chatAppControllers = angular.module 'chatApp.directives', []

chatAppControllers.directive 'caWidth', ->
  return width