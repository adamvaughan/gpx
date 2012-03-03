class App.Views.RecentSegmentListView extends Backbone.View
  tagName: 'section'

  id: 'recent_segments'

  render: =>
    $(@el).html JST['templates/summary/recent_segment_list_view']([])

    recentSegments = new App.Collections.SegmentCollection(_.first(@collection.rest(), 5))
    segmentListView = new App.Views.SegmentListView(collection: recentSegments)
    $(@el).find('.read-more').before segmentListView.render().el

    if @collection.size() > 5
      $(@el).find('.read-more').show()
    else
      $(@el).find('.read-more').hide()

    @
