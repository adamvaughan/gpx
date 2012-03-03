class App.Views.SegmentRowView extends Backbone.View
  tagName: 'tr'

  render: =>
    $(@el).html JST['templates/segment_row_view'](@model.toJSON())
    @
