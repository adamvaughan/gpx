class App.Views.RideRowView extends Backbone.View
  tagName: 'tr'

  events:
    'click a': 'followLink'

  render: =>
    $(@el).html JST['templates/ride_row_view'](@model.toJSON())
    @

  followLink: (event) ->
    App.Helpers.followLink event
