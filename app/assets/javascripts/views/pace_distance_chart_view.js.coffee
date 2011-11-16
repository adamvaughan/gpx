class App.Views.PaceDistanceChartView extends Backbone.View

  initialize: (options) ->
    @points = options.points

  render: =>
    chart = new Highcharts.Chart(@chartOptions())
    @

  dataPoints: =>
    data = []

    @points.each (point) =>
      distance = App.Helpers.metersToMiles(point.get('distance'))
      pace = App.Helpers.secondsPerMeterToMinutesPerMile(point.get('pace'))
      data.push [distance, pace]

    data

  chartOptions: =>
    xAxis:
      title:
        text: 'Distance (miles)'
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
