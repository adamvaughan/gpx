class App.Views.MonthlyDurationChartView extends Backbone.View

  initialize: (options) ->
    @collection.bind 'reset', @render
    @collection.bind 'add', @render
    @collection.bind 'destroy', @render

  render: =>
    @loadMonthlyTotals()
    @

  loadMonthlyTotals: =>
    window.busy(true)
    @model = new App.Models.MonthlyDurationReport
    @model.fetch
      error: =>
        window.busy(false)
        $('#chart').html('<p class="error-message">Unable to load the chart data. Please try again.</p>')
      success: =>
        console.log @model
        console.log @model.get('durations')
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
      type: 'datetime'
      title:
        text: 'Duration'
    tooltip:
      formatter: ->
        "<strong>Duration:</strong>#{App.Helpers.formatTime(@y / 1000)}"
    series: [{
      shadow: false
      states:
        hover: false
      name: ''
      data: @model.get('durations').map (duration) -> parseFloat(duration) * 1000
    }]
