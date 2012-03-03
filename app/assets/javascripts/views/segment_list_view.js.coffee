class App.Views.SegmentListView extends Backbone.View
  tagName: 'table'

  render: =>
    $(@el).html JST['templates/segment_list_view']([])
    @addAll()
    @

  addAll: =>
    $(@el).find('tbody').empty()
    @collection.each (segment) => @addOne(segment)

  addOne: (segment) =>
    segmentRowView = new App.Views.SegmentRowView(model: segment)
    $(@el).find('tbody').append segmentRowView.render().el
