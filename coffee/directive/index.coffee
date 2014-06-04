path = "./public/js/directive/"
Editable = require "#{path}editable"
Time = require "#{path}time"
Link = require "#{path}link"

chatAppControllers = angular.module 'chatApp.directives', []

chatAppControllers.directive 'contenteditable', -> new Editable()
chatAppControllers.directive 'historytime', -> new Time()
chatAppControllers.directive 'a', -> new Link()