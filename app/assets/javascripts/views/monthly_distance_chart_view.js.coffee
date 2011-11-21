class App.Views.MonthlyDistanceChartView extends Backbone.View

  initialize: (options) ->
    @collection.bind 'reset', @render
    @collection.bind 'add', @render
    @collection.bind 'destroy', @render

  render: =>
    @loadMonthlyTotals()
    @

  loadMonthlyTotals: =>
    @model = new App.Models.MonthlyReport
    @model.fetch
      error: =>
        $('#chart').html('<p class="error-message">Unable to load the chart data. Please try again.</p>')
      success: =>
        chart = new Highcharts.Chart(@chartOptions())

  chartOptions: =>
    chart:
      type: 'column'
    xAxis:
      title:
        text: ''
      categories: @model.get('months')
    yAxis:
      title:
        text: 'Distance (miles)'
    tooltip:
      formatter: ->
        "<strong>Distance:</strong>#{Highcharts.numberFormat(this.y, 1)} mi"
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
      name: ''
      data: @model.get('distances').map (distance) -> App.Helpers.metersToMiles(distance)
    }]
