class App.Views.HistoryView extends Backbone.View
  tagName: 'div'

  className: 'history-view'

  initialize: ->
    @loadHistory()

  render: =>
    $(@el).html JST['history_view'](@model.toJSON())
    @

  loadHistory: =>
    @model = new App.Models.History
    @model.fetch
      error: =>
        $(@el).html('<p class="error-message">Unable to load the history data. Please try again.</p>')
      success: =>
        @render()
