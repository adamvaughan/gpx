class App.Routers.ApplicationRouter extends Backbone.Router
  routes:
    '': 'index'

  index: =>
    $('#container').empty()

    summaryView = new App.Views.SummaryView(collection: window.segments)
    $('#container').append summaryView.render().el
