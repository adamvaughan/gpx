class App.Views.Segments.PaceChartView extends Backbone.View

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
        pace = App.Helpers.secondsPerMeterToMinutesPerMile(point.get('pace'))
        data.push [time, pace]

    data

  chartOptions: =>
    chart:
      renderTo: $('.chart.pace').get(0)
    xAxis:
      title:
        text: 'Elapsed Time'
      type: 'datetime'
    yAxis:
      title:
        text: 'Pace (min/mile)'
    tooltip:
      formatter: ->
        "<strong>Elapsed Time:</strong>#{App.Helpers.formatTime(this.x / 1000)}<br>
          <strong>Pace:</strong>#{App.Helpers.formatTime(this.y * 60)} per mile"
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
      name: 'Pace'
      data: App.Helpers.reduceData(@dataPoints())
    }]
