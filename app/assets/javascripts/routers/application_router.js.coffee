class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    'rides': 'rides'
    'rides/page/:page': 'rides'
    'rides/:id': 'ride'
    'upload': 'upload'

  initialize: =>
    $('body > nav a').click @followLink

  index: =>
    @loadRides =>
      summaryView = new App.Views.Summary.SummaryView(collection: App.rides)
      @changePage 'Ride Log', summaryView

  rides: (page = 1) =>
    @loadRidesPage page, =>
      ridesView = new App.Views.Rides.RidesView(collection: App.rides)
      @changePage 'Ride Log', ridesView

  ride: (id) =>
    @loadRide id, (ride) =>
      rideView = new App.Views.Rides.RideView(model: ride)
      @changePage 'Ride Details', rideView

  upload: =>
    fileUploadView = new App.Views.FileUploadView
    @changePage 'Upload', fileUploadView

  changePage: (title, view) =>
    $('body > header > h1').text title
    document.title = title

    $('#container').empty()
    $('#container').append view.render().el

  followLink: (event) ->
    App.Helpers.followLink event

  loadRidesPage: (page, callback) =>
    @loadRides callback, page

  loadRides: (callback, page = 1) =>
    App.rides = new App.Collections.RideCollection(page: page)
    App.rides.fetch
      success: =>
        callback() if _.isFunction(callback)

  loadRide: (id, callback) =>
    ride = App.rides.get(id) if App.rides?

    if ride?
      callback(ride) if _.isFunction(callback)
    else
      ride = new App.Models.Ride(id: id)
      ride.fetch
        success: =>
          callback(ride) if _.isFunction(callback)
