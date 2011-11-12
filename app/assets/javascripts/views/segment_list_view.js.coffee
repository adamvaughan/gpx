class App.Views.SegmentListView extends Backbone.View
  tagName: 'table'

  # TODO make sure the segment views are in the right order

  initialize: ->
    @collection.bind 'reset', @addAll
    @collection.bind 'add', @addOne

  render: =>
    $(@el).html JST['segment_list_view']([])
    $(@el).hide()
    @addAll()
    @

  addOne: (segment) =>
    $(@el).show()
    view = new App.Views.SegmentView(model: segment)
    $(@el).find('tbody').append view.render().el

  addAll: =>
    $(@el).find('tbody').empty()
    @collection.each (segment) =>
      @addOne(segment)
