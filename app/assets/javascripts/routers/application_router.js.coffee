class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    '/:id': 'show'

  index: =>
    $('.container').empty()

    fileUploadForm = new App.Views.FileUploadForm
    $('.container').append fileUploadForm.render().el

    historyView = new App.Views.HistoryView
    $('.container').append historyView.render().el

    segmentList = new App.Views.SegmentListView(collection: window.segments)
    $('.container').append segmentList.render().el

  show: (id) =>
    $('.container').empty()

    segment = window.segments.get(id)

    if segment?
      segmentDetailView = new App.Views.SegmentDetailView(model: window.segments.get(id))
      $('.container').append segmentDetailView.render().el
    else
      window.location.hash = ''
