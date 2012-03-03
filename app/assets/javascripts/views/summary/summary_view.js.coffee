class App.Views.Summary.SummaryView extends Backbone.View
  render: =>
    unless @collection.isEmpty()
      lastSegment = @collection.first()
      lastSegmentSummaryView = new App.Views.Summary.LastSegmentSummaryView(model: lastSegment)
      $(@el).append lastSegmentSummaryView.render().el

      recentSegmentListView = new App.Views.Summary.RecentSegmentListView(collection: @collection)
      $(@el).append recentSegmentListView.render().el

    @
