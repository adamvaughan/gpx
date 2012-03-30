class App.Views.Rides.ElevationChartView extends Backbone.View
  events:
    'click .menu a': 'selectChart'

  availableCharts:
    [
      {
        name: 'Distance'
        rel: 'distance'
      },
      {
        name: 'Elapsed Time'
        rel: 'elapsedTime'
      }
    ]

  initialize: (options) ->
    @points = options.points

  render: =>
    $(@el).find('.menu').html JST['templates/rides/chart_menu_view'](charts: @availableCharts)
    @renderChart _.first(@availableCharts).rel
    @

  renderChart: (type) =>
    chart = new Highcharts.Chart(@["#{type}ChartOptions"]())
    $(@el).find('.menu a.selected').removeClass('selected')
    $(@el).find(".menu a[rel='#{type}']").addClass('selected')

  selectChart: (event) =>
    event.preventDefault()
    @renderChart $(event.target).closest('a').attr('rel')

  distanceDataPoints: =>
    distances = []
    elevations = []

    @points.each (point) =>
      if point.isActive()
        distances.push App.Helpers.metersToMiles(point.get('distance'))
        elevations.push App.Helpers.metersToFeet(point.get('elevation'))

    _.zip distances, App.Helpers.movingAverage(elevations)

  elapsedTimeDataPoints: =>
    times = []
    elevations = []

    @points.each (point) =>
      if point.isActive()
        time = point.get('active_duration') * 1000

        if time > 0
          times.push time
          elevations.push App.Helpers.metersToFeet(point.get('elevation'))

    _.zip times, App.Helpers.movingAverage(elevations)

  distanceChartOptions: =>
    _.extend @commonChartOptions(), {
      xAxis:
        title:
          text: ''
      tooltip:
        formatter: ->
          "<strong>Distance:</strong>#{Highcharts.numberFormat(this.x, 1)} mi<br><strong>Elevation:</strong>#{Highcharts.numberFormat(this.y, 1)} ft"
      series: [
        _.extend @commonSeriesOptions(), {data: @distanceDataPoints()}
      ]
    }

  elapsedTimeChartOptions: =>
    _.extend @commonChartOptions(), {
      xAxis:
        title:
          text: ''
        type: 'datetime'
      tooltip:
        formatter: ->
          "<strong>Elapsed Time:</strong>#{App.Helpers.formatTime(this.x / 1000)} mi<br><strong>Elevation:</strong>#{Highcharts.numberFormat(this.y, 1)} ft"
      series: [
        _.extend @commonSeriesOptions(), {data: @elapsedTimeDataPoints()}
      ]
    }

  commonChartOptions: =>
    chart:
      renderTo: $(@el).find('.highchart').get(0)
    yAxis:
      title:
        text: 'Elevation (ft)'

  commonSeriesOptions: =>
    marker:
      enabled: false
      fillColor: '#444'
      symbol: 'circle'
      radius: 4
      lineWidth: 2
      states:
        hover:
          enabled: true
    lineWidth: 2
    shadow: false
    states:
      hover:
        lineWidth: 2
    name: 'Elevation'
