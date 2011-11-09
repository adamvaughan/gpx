class App.Views.SegmentDetailView extends Backbone.View
  render: =>
    $(@el).html JST['segment_detail_view'](@model.toJSON())
    @

