class App.Views.Summary.LastRideSummaryView extends Backbone.View
  tagName: 'section'

  id: 'last_ride'

  sparklineOptions:
    spotRadius: 0
    fillColor: '#a9d5de'
    lineColor: '#439aab'
    width: '250px'
    height: '36px'

  events:
    'click .read-more a': 'followLink'

  render: =>
    $(@el).html JST['templates/summary/last_ride_summary_view'](@model.toJSON())
    @drawSparklines()
    @

  drawSparklines: =>
    @fetchPointData (points) =>
      @drawSparkline 'speed', points.speedValues()
      @drawSparkline 'pace', points.paceValues()
      @drawSparkline 'elevation', points.elevationValues()
      @drawSparkline 'heart-rate', points.heartRateValues()

  drawSparkline: (measurement, values) =>
    sparkline = $(@el).find(".summary.#{measurement} .sparkline")
    sparkline.sparkline App.Helpers.movingAverage(values), @sparklineOptions

  fetchPointData: (callback) =>
    pointCollection = new App.Collections.PointCollection(href: @model.get('points_href'))
    pointCollection.fetch
      success: (collection) => callback(collection)

  followLink: (event) ->
    App.Helpers.followLink event
