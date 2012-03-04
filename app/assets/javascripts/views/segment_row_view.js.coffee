class App.Views.SegmentRowView extends Backbone.View
  tagName: 'tr'

  events:
    'click a': 'followLink'

  render: =>
    $(@el).html JST['templates/segment_row_view'](@model.toJSON())
    @

  followLink: (event) ->
    App.Helpers.followLink event
