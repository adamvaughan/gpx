class App.Views.Rides.RideView extends Backbone.View
  id: 'ride'

  render: =>
    $(@el).html JST['templates/rides/ride_view'](@model.toJSON())
    App.Helpers.prepareExpandingSections @el

    @loadPoints (points) =>
      @loadMap points
      @loadCharts points

    @

  loadPoints: (callback) =>
    points = new App.Collections.PointCollection href: @model.get('points_href')
    points.fetch
      success: => callback points

  loadMap: (points) =>
    mapView = new App.Views.Rides.MapView points: points
    mapView.render()

  loadCharts: (points) =>
    @loadElevationChart points

  loadElevationChart: (points) =>
    elevationChartView = new App.Views.Rides.ElevationChartView
      el: $(@el).find('.chart.elevation').get(0)
      points: points
    elevationChartView.render()
