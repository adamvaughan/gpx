class App.Views.HistoryView extends Backbone.View
  tagName: 'div'

  className: 'history-view'

  initialize: ->
    @collection.bind 'reset', @loadHistory
    @collection.bind 'add', @loadHistory
    @collection.bind 'destroy', @loadHistory
    @loadHistory()

  render: =>
    if @collection.length > 0
      $(@el).html JST['history_view'](@model.toJSON())
    else
      $(@el).html('').hide()
    @

  loadHistory: =>
    @model = new App.Models.History
    @model.fetch
      error: =>
        $(@el).html('<p class="error-message">Unable to load the history data. Please try again.</p>')
      success: =>
        @render()
