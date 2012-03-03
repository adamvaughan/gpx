class App.Collections.PointCollection extends Backbone.Collection
  model: App.Models.Point

  url: =>
    @href

  initialize: (options) ->
    @href = options.href

  comparator: (point) ->
    point.get('time')

  speedValues: =>
    values = @map (point) -> point.get('speed') if point.get('speed') > 0.5
    _.compact(values)

  paceValues: =>
    values = @map (point) -> point.get('pace') if point.get('pace') > 0 and point.get('pace') < 1
    _.compact(values)

  elevationValues: =>
    values = @map (point) -> point.get('elevation') if point.get('speed') > 0.5
    _.compact(values)

  heartRateValues: =>
    values = @map (point) -> point.get('heart_rate')
    _.compact(values)
