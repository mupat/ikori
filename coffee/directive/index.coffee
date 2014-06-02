path = "./public/js/directive/"
Editable = require "#{path}editable"

chatAppControllers = angular.module 'chatApp.directives', []

chatAppControllers.directive 'contenteditable', -> new Editable()