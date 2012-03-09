class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    "#{CONTEXT_ROOT}": 'index'
    "#{CONTEXT_ROOT}/rides": 'rides'
    "#{CONTEXT_ROOT}/rides/:id": 'ride'
    "#{CONTEXT_ROOT}/upload": 'upload'

  initialize: =>
    $('body > nav a').click @followLink

  index: =>
    summaryView = new App.Views.Summary.SummaryView(collection: App.segments)
    @changePage 'Ride Log', summaryView

  rides: =>
    segmentsView = new App.Views.Segments.SegmentsView(collection: App.segments)
    @changePage 'Ride Log', segmentsView

  ride: (id) =>
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
