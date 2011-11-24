class App.Views.RecordView extends Backbone.View
  tagName: 'table'

  className: 'record-view'

  initialize: ->
    @collection.bind 'reset', @loadRecords
    @collection.bind 'add', @loadRecords
    @collection.bind 'destroy', @loadRecords
    @loadRecords()

  render: =>
    if @collection.length > 0
      $(@el).html(JST['record_view'](@model.toJSON())).show()
    else
      $(@el).html('').hide()
    @

  loadRecords: =>
    window.busy(true)
    @model = new App.Models.Record
    @model.fetch
      error: =>
        window.busy(false)
        $(@el).html('<p class="error-message">Unable to load the record data. Please try again.</p>')
      success: =>
        window.busy(false)
        @render()
