class App.Views.Rides.RidesView extends Backbone.View
  tagName: 'section'

  className: 'all-rides'

  render: =>
    $(@el).html JST['templates/rides/rides_view']([])
    App.Helpers.prepareExpandingSections @el

    unless @collection.isEmpty()
      rideListView = new App.Views.RideListView(collection: @collection)
      $(@el).find('.section-content').append rideListView.render().el

      pagerView = new App.Views.PagerView(model: @collection.pager)
      $(@el).find('.section-content').append pagerView.render().el

    @
