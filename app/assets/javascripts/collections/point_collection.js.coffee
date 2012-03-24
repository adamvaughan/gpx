class App.Collections.PointCollection extends Backbone.Collection
  model: App.Models.Point

  url: =>
    @href

  initialize: (options) ->
    @href = options.href

  comparator: (point) ->
    point.get('time')

  speedValues: =>
    values = @map (point) -> parseFloat(point.get('speed')) if point.isActive()
    _.compact values

  paceValues: =>
    values = @map (point) -> parseFloat(point.get('pace')) if point.isActive()
    _.compact values

  elevationValues: =>
    values = @map (point) -> parseFloat(point.get('elevation')) if point.isActive()
    _.compact values

  heartRateValues: =>
    values = @map (point) -> parseFloat(point.get('heart_rate')) if point.isActive()
    _.compact values
