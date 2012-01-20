class App.Views.ElevationDistanceChartView extends Backbone.View

  initialize: (options) ->
    @points = options.points

  render: =>
    chart = new Highcharts.Chart(@chartOptions())
    @

  dataPoints: =>
    data = []

    @points.each (point) =>
      distance = App.Helpers.metersToMiles(point.get('distance'))
      elevation = App.Helpers.metersToFeet(point.get('elevation'))
      data.push [distance, elevation]

    data

  chartOptions: =>
    xAxis:
      title:
        text: ''
    yAxis:
      title:
        text: 'Elevation (ft)'
    tooltip:
      formatter: ->
        "<strong>Elevation:</strong>#{Highcharts.numberFormat(this.y, 1)} ft"
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
      name: 'Elevation'
      data: @dataPoints()
    }]
