class App.Views.TotalsView extends Backbone.View
  tagName: 'table'

  className: 'report-view'

  initialize: ->
    @collection.bind 'reset', @loadTotals
    @collection.bind 'add', @loadTotals
    @collection.bind 'destroy', @loadTotals
    @loadTotals()

  render: =>
    if @collection.length > 0
      $(@el).html(JST['totals_view'](@model.toJSON())).show()
    else
      $(@el).html('').hide()
    @

  loadTotals: =>
    window.busy(true)
    @model = new App.Models.ReportTotals
    @model.fetch
      error: =>
        window.busy(false)
        $(@el).html('<p class="error-message">Unable to load the report data. Please try again.</p>')
      success: =>
        window.busy(false)
        @render()
