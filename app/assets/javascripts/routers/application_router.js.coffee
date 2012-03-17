class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    'rides': 'rides'
    'rides/:id': 'ride'
    'upload': 'upload'

  initialize: =>
    $('body > nav a').click @followLink

  index: =>
    @loadSegments =>
      summaryView = new App.Views.Summary.SummaryView(collection: App.segments)
      @changePage 'Ride Log', summaryView

  rides: =>
    @loadSegments =>
      segmentsView = new App.Views.Segments.SegmentsView(collection: App.segments)
      @changePage 'Ride Log', segmentsView

  ride: (id) =>
    @loadSegments =>
      segment = App.segments.get(id)
      segmentView = new App.Views.Segments.SegmentView(model: segment)
      @changePage 'Ride Details', segmentView

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

  loadSegments: (callback) =>
    App.segments = new App.Collections.SegmentCollection()
    App.segments.fetch
      success: =>
        callback() if _.isFunction(callback)
