class App.Views.SegmentListView extends Backbone.View
  tagName: 'table'

  # TODO make sure the segment views are in the right order

  initialize: ->
    @collection.bind 'reset', @addAll
    @collection.bind 'add', @addOne
    @collection.bind 'destroy', @updateVisibility

  render: =>
    $(@el).html JST['segment_list_view']([])
    $(@el).hide()
    @addAll()
    @

  addOne: (segment) =>
    view = new App.Views.SegmentView(model: segment)
    $(@el).find('tbody').append view.render().el
    @updateVisibility()

  addAll: =>
    $(@el).find('tbody').empty()
    @collection.each (segment) =>
      @addOne(segment)

  updateVisibility: =>
    if @collection.length > 0
      $(@el).show()
    else
      $(@el).hide()
