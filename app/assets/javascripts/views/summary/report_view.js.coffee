class App.Views.Summary.ReportView extends Backbone.View
  initialize: ->
    @model.bind 'change', @render

  render: =>
    $(@el).html JST['templates/summary/report_view'](@model.toJSON())
    @
