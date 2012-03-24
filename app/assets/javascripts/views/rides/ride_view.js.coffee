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
    @loadSpeedChart points
    @loadPaceChart points
    @loadHeartRateChart points

  loadElevationChart: (points) =>
    elevationChartView = new App.Views.Rides.ElevationChartView
      el: $(@el).find('.chart.elevation').get(0)
      points: points
    elevationChartView.render()

  loadSpeedChart: (points) =>
    speedChartView = new App.Views.Rides.SpeedChartView
      el: $(@el).find('.chart.speed').get(0)
      points: points
    speedChartView.render()

  loadPaceChart: (points) =>
    paceChartView = new App.Views.Rides.PaceChartView
      el: $(@el).find('.chart.pace').get(0)
      points: points
    paceChartView.render()

  loadHeartRateChart: (points) =>
    heartRateChartView = new App.Views.Rides.HeartRateChartView
      el: $(@el).find('.chart.heart-rate').get(0)
      points: points
    heartRateChartView.render()
