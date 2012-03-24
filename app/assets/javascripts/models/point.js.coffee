class App.Models.Point extends Backbone.Model
  isActive: =>
    parseFloat(@get('speed')) > 0.5
