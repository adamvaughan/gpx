class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    '/:id': 'show'

  index: =>
    $('.container').empty()

    fileUploadForm = new App.Views.FileUploadForm
    $('.container').append fileUploadForm.render().el

    totalsView = new App.Views.TotalsView(collection: window.segments)
    $('.container').append totalsView.render().el

    recordView = new App.Views.RecordView(collection: window.segments)
    $('.container').append recordView.render().el

    $('.container').append $('<div id="chart" class="chart"></div>')
    chartView = new App.Views.MonthlyDistanceChartView(collection: window.segments)
    chartView.render()

    segmentListView = new App.Views.SegmentListView(collection: window.segments)
    $('.container').append segmentListView.render().el

  show: (id) =>
    $('.container').empty()

    segment = window.segments.get(id)

    if segment?
      segmentDetailView = new App.Views.SegmentDetailView(model: window.segments.get(id))
      $('.container').append segmentDetailView.render().el
    else
      window.location.hash = ''
