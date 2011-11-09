class App.Views.SegmentView extends Backbone.View
  tagName: 'tr'

  events:
    'click a[rel=view]' : 'view'
    'click a[rel=edit]' : 'edit'

  # TODO listen for changes to the name and re-render

  render: =>
    $(@el).html JST['segment_view'](@model.toJSON())
    @

  view: (event) =>
    event.preventDefault()
    window.location.hash = "/#{@model.id}"

  edit: =>
    event.preventDefault()
    # TODO add in place editing for the name
