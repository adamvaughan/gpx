class App.Views.SummaryView extends Backbone.View
  render: =>
    unless @collection.isEmpty()
      lastSegment = @collection.first()
      lastSegmentSummaryView = new App.Views.LastSegmentSummaryView(model: lastSegment)
      $(@el).append lastSegmentSummaryView.render().el

      recentSegmentListView = new App.Views.RecentSegmentListView(collection: @collection)
      $(@el).append recentSegmentListView.render().el

    @
