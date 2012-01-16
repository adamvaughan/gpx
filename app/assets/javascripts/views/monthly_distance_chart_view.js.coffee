class App.Views.MonthlyDistanceChartView extends Backbone.View

  initialize: (options) ->
    @collection.bind 'reset', @render
    @collection.bind 'add', @render
    @collection.bind 'destroy', @render

  render: =>
    @loadMonthlyTotals()
    @

  loadMonthlyTotals: =>
    window.busy(true)
    @model = new App.Models.MonthlyDistanceReport
    @model.fetch
      error: =>
        window.busy(false)
        $('#chart').html('<p class="error-message">Unable to load the chart data. Please try again.</p>')
      success: =>
        window.busy(false)
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
        "<strong>Distance:</strong>#{Highcharts.numberFormat(@y, 1)} mi"
    series: [{
      shadow: false
      states:
        hover: false
      name: ''
      data: @model.get('distances').map (distance) -> App.Helpers.metersToMiles(distance)
    }]
