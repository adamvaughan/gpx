class App.Views.SegmentView extends Backbone.View
  tagName: 'tr'

  className: 'segment-view'

  events:
    'click a[rel=view]': 'view'
    'click a[rel=edit]': 'edit'
    'keypress input': 'save'

  initialize: ->
    @model.bind 'change:name', @render

    $(document).bind 'keydown', @cancel

  render: =>
    $(@el).html JST['segment_view'](@model.toJSON())
    @

  view: (event) =>
    event.preventDefault()
    window.location.hash = "/#{@model.id}"

  edit: (event) =>
    event.preventDefault()
    @toggleEditInPlace()

  save: (event) =>
    if event.which == 13 and @isEditing()
     event.preventDefault()
     value = $.trim $(@el).find('td.name input').val()

     if value == @model.get('name')
       @toggleEditInPlace()
     else
       # TODO handle errors
       @model.save {name: $(@el).find('td.name input').val()}

  cancel: (event) =>
    if event.which == 27 and @isEditing()
     @toggleEditInPlace()

  toggleEditInPlace: =>
    $(@el).find('td').toggleClass 'editing'

    p = $(@el).find('td.name p')
    input = $(@el).find('td.name input')

    input.val $.trim(p.text())
    input.focus().select()

  isEditing: =>
    input = $(@el).find('td.name input')
    input.is(':visible') and input.is(':focus')
