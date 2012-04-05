class App.Views.Summary.SummaryView extends Backbone.View
  events:
    'click .read-more a': 'followLink'

  render: =>
    unless @collection.isEmpty()
      lastRide = @collection.first()
      lastRideSummaryView = new App.Views.Summary.LastRideSummaryView(model: lastRide)
      $(@el).append lastRideSummaryView.render().el

      report = new App.Models.Report()
      reportView = new App.Views.Summary.ReportView(model: report)
      $(@el).append reportView.render().el

      recentRideListView = new App.Views.Summary.RecentRideListView(collection: @collection)
      $(@el).append recentRideListView.render().el

      App.Helpers.prepareExpandingSections @el
      report.fetch()
    @

  followLink: (event) ->
    App.Helpers.followLink event
