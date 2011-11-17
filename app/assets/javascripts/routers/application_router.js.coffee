class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'
    '/:id': 'show'

  index: =>
    $('.container').empty()

    fileUploadForm = new App.Views.FileUploadForm
    $('.container').append fileUploadForm.render().el

    reportView = new App.Views.ReportView(collection: window.segments)
    $('.container').append reportView.render().el

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
