class App.Views.Segments.ElevationChartView extends Backbone.View
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
    chart:
      renderTo: $('.chart.elevation').get(0)
    xAxis:
      title:
        text: 'Distance (mi)'
    yAxis:
      title:
        text: 'Elevation (ft)'
    tooltip:
      formatter: ->
        "<strong>Distance:</strong>#{Highcharts.numberFormat(this.x, 1)} mi<br><strong>Elevation:</strong>#{Highcharts.numberFormat(this.y, 1)} ft"
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
