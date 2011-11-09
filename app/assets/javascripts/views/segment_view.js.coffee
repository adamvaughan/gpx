class App.Views.SegmentView extends Backbone.View
  tagName: 'tr'

  events:
    'click a[rel=view]' : 'view'
    'click a[rel=edit]' : 'edit'

  render: =>
    $(@el).html JST['segment_view'](@model.toJSON())
    @

  view: (event) =>
    event.preventDefault()
    window.location.hash = "/#{@model.id}"

  edit: =>
    event.preventDefault()
    window.location.hash = "/edit/#{@model.id}"
