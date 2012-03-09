class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    'rides': 'rides'
    'rides/:id': 'ride'

  index: =>
    @setHeading 'Ride Log'
    $('#container').empty()

    summaryView = new App.Views.Summary.SummaryView(collection: App.segments)
    $('#container').append summaryView.render().el

  rides: =>
    @setHeading 'Ride Log'
    $('#container').empty()

    segmentsView = new App.Views.Segments.SegmentsView(collection: App.segments)
    $('#container').append segmentsView.render().el

  ride: (id) =>
    @setHeading 'Ride Details'
    $('#container').empty()

    segment = App.segments.get(id)
    segmentView = new App.Views.Segments.SegmentView(model: segment)
    $('#container').append segmentView.render().el

  setHeading: (heading) =>
    $('body > header > h1').text heading
    document.title = heading
