class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    '/:id': 'show'

  index: =>
    $('.container').empty()

    fileUploadForm = new App.Views.FileUploadForm
    $('.container').append fileUploadForm.render().el

    @totalsView = new App.Views.TotalsView(collection: window.segments)
    $('.container').append @totalsView.render().el

    @recordView = new App.Views.RecordView(collection: window.segments)
    $('.container').append @recordView.render().el

    $('.container').append $('<div id="chart" class="chart"></div>')
    chartView = new App.Views.MonthlyDistanceChartView(collection: window.segments)
    chartView.render()

    $('.container').append $('<ul class="pills"><li class="active"><a href="#" rel="distance" title="Distance">Distance</a></li><li><a href="#" rel="time" title="Time">Time</a></li></ul>')
    $('.container .pills a').click @changeRecordView

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

  changeRecordView: (event) =>
    event.preventDefault()
    activeRecordView = $('.container .pills a.active').attr('rel')
    selectedRecordView = $(event.target).closest('a').attr('rel')

    if activeRecordView != selectedRecordView
      $('.container .pills li.active').removeClass('active')
      $(event.target).closest('li').addClass('active')

      if selectedRecordView == 'distance'
        @totalsView.displayDistanceTotals()
        @recordView.displayDistanceRecords()
        chartView = new App.Views.MonthlyDistanceChartView(collection: window.segments)
        chartView.render()
      else
        @totalsView.displayDurationTotals()
        @recordView.displayDurationRecords()
        chartView = new App.Views.MonthlyDurationChartView(collection: window.segments)
        chartView.render()
