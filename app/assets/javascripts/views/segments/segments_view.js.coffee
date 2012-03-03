class App.Views.Segments.SegmentsView extends Backbone.View
  render: =>
    $(@el).html JST['templates/segments/segments_view']([])

    unless @collection.isEmpty()
      segmentListView = new App.Views.SegmentListView(collection: @collection)
      $(@el).append segmentListView.render().el

    @
