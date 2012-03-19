class App.Views.Summary.RecentSegmentListView extends Backbone.View
  tagName: 'section'

  id: 'recent_segments'

  events:
    'click .read-more a': 'followLink'

  render: =>
    $(@el).html JST['templates/summary/recent_segment_list_view']([])

    recentSegments = new App.Collections.SegmentCollection(@collection.first(10))
    segmentListView = new App.Views.SegmentListView(collection: recentSegments)
    $(@el).find('.read-more').before segmentListView.render().el

    if @collection.pager.totalEntries > 5
      $(@el).find('.read-more').show()
    else
      $(@el).find('.read-more').hide()

    @

  followLink: (event) ->
    App.Helpers.followLink event
