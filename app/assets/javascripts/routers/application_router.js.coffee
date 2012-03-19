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
    @loadSegments =>
      summaryView = new App.Views.Summary.SummaryView(collection: App.segments)
      @changePage 'Ride Log', summaryView

  rides: (page = 1) =>
    @loadSegmentsPage page, =>
      segmentsView = new App.Views.Segments.SegmentsView(collection: App.segments)
      @changePage 'Ride Log', segmentsView

  ride: (id) =>
    @loadSegment id, (segment) =>
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

  loadSegmentsPage: (page, callback) =>
    @loadSegments callback, page

  loadSegments: (callback, page = 1) =>
    App.segments = new App.Collections.SegmentCollection(page: page)
    App.segments.fetch
      success: =>
        callback() if _.isFunction(callback)

  loadSegment: (id, callback) =>
    segment = App.segments.get(id) if App.segments?

    if segment?
      callback(segment) if _.isFunction(callback)
    else
      segment = new App.Models.Segment(id: id)
      segment.fetch
        success: =>
          callback(segment) if _.isFunction(callback)
