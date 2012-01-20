class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    '/distance-summary': 'distanceSummary'
    '/duration-summary': 'durationSummary'
    '/:id': 'show'

  index: =>
    window.location.hash = '/distance-summary'

  distanceSummary: =>
    $('.container').empty()

    distanceSummaryView = new App.Views.DistanceSummaryView(collection: window.segments)
    $('.container').append distanceSummaryView.render().el

  durationSummary: =>
    $('.container').empty()

    durationSummaryView = new App.Views.DurationSummaryView(collection: window.segments)
    $('.container').append durationSummaryView.render().el

  show: (id) =>
    $('.container').empty()

    segment = window.segments.get(id)

    if segment?
      segmentDetailView = new App.Views.SegmentDetailView(model: segment)
      $('.container').append segmentDetailView.render().el
    else
      window.location.hash = ''
