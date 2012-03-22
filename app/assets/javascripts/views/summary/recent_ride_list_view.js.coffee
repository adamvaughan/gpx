class App.Views.Summary.RecentRideListView extends Backbone.View
  tagName: 'section'

  id: 'recent_rides'

  events:
    'click .read-more a': 'followLink'

  render: =>
    $(@el).html JST['templates/summary/recent_ride_list_view']([])

    recentRides = new App.Collections.RideCollection(@collection.first(10))
    rideListView = new App.Views.RideListView(collection: recentRides)
    $(@el).find('.read-more').before rideListView.render().el

    if @collection.pager.totalEntries > 5
      $(@el).find('.read-more').show()
    else
      $(@el).find('.read-more').hide()

    @

  followLink: (event) ->
    App.Helpers.followLink event
