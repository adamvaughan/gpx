class App.Views.SegmentView extends Backbone.View
  tagName: 'tr'

  className: 'segment-view'

  events:
    'click a[rel=view]': 'view'
    'click a[rel=edit]': 'edit'
    'keypress input': 'save'
    'blur input': 'cancel'

  initialize: ->
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
        @model.save { name: value },
          success: =>
            $(@el).find('td.name p').html(value)
            @toggleEditInPlace()

  cancel: (event) =>
    if (not event.which? or event.which == 27) and @isEditing()
      @toggleEditInPlace()

  toggleEditInPlace: =>
    $(@el).toggleClass 'editing'

    if $(@el).is('.editing')
      p = $(@el).find('td.name p')
      input = $(@el).find('td.name input')

      input.val $.trim(p.text())
      input.focus().select()

  isEditing: =>
    $(@el).is('.editing')
