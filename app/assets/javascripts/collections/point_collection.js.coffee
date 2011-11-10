class App.Collections.PointCollection extends Backbone.Collection
  model: App.Models.Point

  url: =>
    @href

  initialize: (options) ->
    @href = options.href
