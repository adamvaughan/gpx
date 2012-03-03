class App.Views.Summary.LastSegmentSummaryView extends Backbone.View
  tagName: 'section'

  id: 'last_segment'

  sparklineOptions:
    spotRadius: 0
    fillColor: '#a9d5de'
    lineColor: '#439aab'
    width: '250px'
    height: '36px'

  render: =>
    $(@el).html JST['templates/summary/last_segment_summary_view'](@model.toJSON())
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
    sparkline.sparkline values, @sparklineOptions

  fetchPointData: (callback) =>
    pointCollection = new App.Collections.PointCollection(href: @model.get('points_href'))
    pointCollection.fetch
      success: (collection) => callback(collection)
