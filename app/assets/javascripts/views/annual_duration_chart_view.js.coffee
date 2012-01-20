class App.Views.AnnualDurationChartView extends Backbone.View

  initialize: (options) ->
    @collection.bind 'reset', @render
    @collection.bind 'add', @render
    @collection.bind 'destroy', @render

  render: =>
    @loadAnnualTotals()
    @

  loadAnnualTotals: =>
    window.busy(true)
    @model = new App.Models.AnnualDurationReport
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
      categories: @model.get('years')
    yAxis:
      type: 'datetime'
      title:
        text: 'Duration'
      labels:
        formatter: ->
          time = App.Helpers.formatTime(@value / 1000)
          parts = time.split(':')
          "#{parts[0]}:#{parts[1]}"
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
