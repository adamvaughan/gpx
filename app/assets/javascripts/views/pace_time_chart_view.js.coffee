class App.Views.PaceTimeChartView extends Backbone.View

  initialize: (options) ->
    @points = options.points

  render: =>
    chart = new Highcharts.Chart(@chartOptions())
    @

  dataPoints: =>
    data = []

    @points.each (point) =>
      time = point.get('duration') * 1000
      pace = App.Helpers.secondsPerMeterToMinutesPerMile(point.get('pace'))
      data.push [time, pace]

    data

  chartOptions: =>
    xAxis:
      title:
        text: ''
      type: 'datetime'
      dateTimeLabelFormats:
        hour: '%H:%M'
        minute: '%H:%M'
    yAxis:
      title:
        text: 'Pace (min/mile)'
    tooltip:
      formatter: ->
        "<strong>Pace:</strong>#{Highcharts.numberFormat(this.y, 1)} min/mile"
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
