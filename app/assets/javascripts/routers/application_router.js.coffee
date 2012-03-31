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
      @changePage summaryView

  rides: (page = 1) =>
    @loadRidesPage page, =>
      ridesView = new App.Views.Rides.RidesView(collection: App.rides)
      @changePage ridesView, 'All Rides'

  ride: (id) =>
    @loadRide id, (ride) =>
      rideView = new App.Views.Rides.RideView(model: ride)
      @changePage rideView, 'Ride Details'

  upload: =>
    fileUploadView = new App.Views.FileUploadView
    @changePage fileUploadView, 'Upload'

  changePage: (view, title) =>
    document.title = if title? then "Ride Log - #{title}" else 'Ride Log'

    title = 'Ride Log' unless title?
    $('body > header > h1').text title

    $('#container').empty()
    $('#container').append view.render().el
    $('html, body').scrollTop 0

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
