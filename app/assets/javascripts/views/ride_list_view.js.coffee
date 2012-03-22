class App.Views.RideListView extends Backbone.View
  tagName: 'table'

  className: 'rides'

  render: =>
    $(@el).html JST['templates/ride_list_view']([])
    @addAll()
    @

  addAll: =>
    $(@el).find('tbody').empty()
    @collection.each (ride) => @addOne(ride)

  addOne: (ride) =>
    rideRowView = new App.Views.RideRowView(model: ride)
    $(@el).find('tbody').append rideRowView.render().el
