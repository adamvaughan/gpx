class App.Views.Segments.SegmentView extends Backbone.View
  id: 'segment'

  render: =>
    $(@el).html JST['templates/segments/segment_view'](@model.toJSON())
    @prepareExpandingSections()

    @loadPoints (points) =>
      @loadMap points
      @loadCharts points

    @

  prepareExpandingSections: =>
    $(@el).find('section header h1').click (event) =>
      section = $(event.target).closest('section')
      section.toggleClass('active')

    $(@el).find('section').addClass('active')

  loadPoints: (callback) =>
    points = new App.Collections.PointCollection href: @model.get('points_href')
    points.fetch
      success: => callback points

  loadMap: (points) =>
    mapView = new App.Views.Segments.MapView points: points
    mapView.render()

  loadCharts: (points) =>
    @loadElevationChart points
    @loadSpeedChart points
    @loadPaceChart points
    @loadHeartRateChart points

  loadElevationChart: (points) =>
    elevationChartView = new App.Views.Segments.ElevationChartView
      el: $(@el).find('.chart.elevation').get(0)
      points: points
    elevationChartView.render()

  loadSpeedChart: (points) =>
    speedChartView = new App.Views.Segments.SpeedChartView
      el: $(@el).find('.chart.speed').get(0)
      points: points
    speedChartView.render()

  loadPaceChart: (points) =>
    paceChartView = new App.Views.Segments.PaceChartView
      el: $(@el).find('.chart.pace').get(0)
      points: points
    paceChartView.render()

  loadHeartRateChart: (points) =>
    heartRateChartView = new App.Views.Segments.HeartRateChartView
      el: $(@el).find('.chart.heart-rate').get(0)
      points: points
    heartRateChartView.render()
