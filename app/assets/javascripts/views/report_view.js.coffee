class App.Views.ReportView extends Backbone.View
  tagName: 'table'

  className: 'report-view'

  initialize: ->
    @collection.bind 'reset', @loadReport
    @collection.bind 'add', @loadReport
    @collection.bind 'destroy', @loadReport
    @loadReport()

  render: =>
    if @collection.length > 0
      $(@el).html(JST['report_view'](@model.toJSON())).show()
    else
      $(@el).html('').hide()
    @

  loadReport: =>
    @model = new App.Models.Report
    @model.fetch
      error: =>
        $(@el).html('<p class="error-message">Unable to load the report data. Please try again.</p>')
      success: =>
        @render()
