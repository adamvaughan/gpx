class App.Views.SegmentListView extends Backbone.View
  tagName: 'table'

  initialize: ->
    @collection.bind 'reset', @addAll
    @collection.bind 'add', @addOne

  render: =>
    $(@el).html JST['segment_list_view']([])
    @addAll()
    @

  addOne: (segment) =>
    view = new App.Views.SegmentView(model: segment)
    $(@el).find('tbody').append view.render().el

  addAll: =>
    $(@el).find('tbody').empty()
    @collection.each (segment) =>
      @addOne(segment)
