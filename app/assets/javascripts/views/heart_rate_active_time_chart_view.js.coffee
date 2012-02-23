class App.Views.HeartRateActiveTimeChartView extends Backbone.View

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
        data.push [time, point.get('heart_rate')]

    data

  chartOptions: =>
    xAxis:
      title:
        text: ''
      type: 'datetime'
    yAxis:
      title:
        text: 'Heart Rate (bpm)'
    tooltip:
      formatter: ->
        "<strong>Heart Rate:</strong>#{Highcharts.numberFormat(this.y, 1)} bpm"
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
      name: 'Heart Rate'
      data: @dataPoints()
    }]
