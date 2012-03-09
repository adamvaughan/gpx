class App.Views.Segments.SegmentsView extends Backbone.View
  render: =>
    $(@el).html JST['templates/segments/segments_view']([])
    App.Helpers.prepareExpandingSections @el

    unless @collection.isEmpty()
      segmentListView = new App.Views.SegmentListView(collection: @collection)
      $(@el).find('.section-content').append segmentListView.render().el

    @
