# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http://example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require highcharts
#= require underscore
#= require backbone
#= require handlebars.vm
#= require date
#= require_self
#= require_tree ./helpers
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers
#= require_tree ../templates

window.App =
  Helpers: {}
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

Highcharts.setOptions
  plotOptions:
    series:
      animation: false
  chart:
    renderTo: 'chart'
    type: 'spline'
    width: 900
    height: 300
  legend:
    enabled: false
  credits:
    enabled: false
  title:
    text: ''

$ ->
  router = new App.Routers.ApplicationRouter
  Backbone.history.start()
