class App.Views.SpeedActiveTimeChartView extends Backbone.View

  initialize: (options) ->
    @points = options.points

  render: =>
    chart = new Highcharts.Chart(@chartOptions())
    @

  dataPoints: =>
    data = []

    @points.each (point) =>
      time = point.get('active_duration') * 1000

      if time > 0
        speed = App.Helpers.metersPerSecondToMilesPerHour(point.get('speed'))
        data.push [time, speed]

    data

  chartOptions: =>
    xAxis:
      title:
        text: 'Time'
      type: 'datetime'
      dateTimeLabelFormats:
        hour: '%H:%M'
        minute: '%H:%M'
    yAxis:
      title:
        text: 'Speed (mph)'
    tooltip:
      formatter: ->
        "<strong>Speed:</strong>#{Highcharts.numberFormat(this.y, 1)} mph"
    series: [{
      marker:
        enabled: false
        fillColor: '#444'
        symbol: 'circle'
        radius: 4
        lineWidth: 2
        states:
          hover:
            enabled: true
      lineWidth: 3
      shadow: false
      states:
        hover:
          lineWidth: 3
      name: 'Speed'
      data: App.Helpers.reduceData(@dataPoints())
    }]
