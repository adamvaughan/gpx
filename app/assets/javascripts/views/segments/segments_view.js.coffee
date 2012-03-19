class App.Views.Segments.SegmentsView extends Backbone.View
  tagName: 'section'

  className: 'all-rides'

  render: =>
    $(@el).html JST['templates/segments/segments_view']([])
    App.Helpers.prepareExpandingSections @el

    unless @collection.isEmpty()
      segmentListView = new App.Views.SegmentListView(collection: @collection)
      $(@el).find('.section-content').append segmentListView.render().el

      pagerView = new App.Views.PagerView(model: @collection.pager)
      $(@el).find('.section-content').append pagerView.render().el

    @
