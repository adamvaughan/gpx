class App.Views.Summary.LastRideSummaryView extends Backbone.View
  tagName: 'section'

  id: 'last_ride'

  events:
    'click .read-more a': 'followLink'

  render: =>
    $(@el).html JST['templates/summary/last_ride_summary_view'](@model.toJSON())
    @

  followLink: (event) ->
    App.Helpers.followLink event
