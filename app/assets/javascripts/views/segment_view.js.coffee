class App.Views.SegmentView extends Backbone.View
  tagName: 'tr'

  className: 'segment-view'

  events:
    'click a[rel=view]': 'view'
    'click a[rel=edit]': 'edit'
    'click a[rel=delete]': 'delete'
    'click .delete-confirmation input[rel=confirm]': 'confirmDelete'
    'click .delete-confirmation input[rel=cancel]': 'cancelDelete'
    'keypress input[type=text]': 'save'
    'blur input[type=text]': 'cancel'

  initialize: ->
    $(document).bind 'keydown', @cancel
    $(document).bind 'keydown', @cancelDeleteOnKeydown

  render: =>
    $(@el).html JST['segment_view'](@model.toJSON())
    @

  view: (event) =>
    event.preventDefault()
    window.location.hash = "/#{@model.id}"

  edit: (event) =>
    event.preventDefault()
    $(@el).removeClass 'error'
    $(@el).removeClass 'deleting'
    @toggleEditInPlace()

  delete: (event) =>
    event.preventDefault()
    $(@el).removeClass 'error'
    $(@el).addClass 'deleting'

  confirmDelete: (event) =>
    event.preventDefault()
    $(@el).removeClass 'error'

    @model.destroy
      success: =>
        @remove()
      error: =>
        $(@el).addClass 'error'
        $(@el).find('div.error-message').html('An unknown error has occurred. Please try again.')

  cancelDelete: (event) =>
    event.preventDefault()
    $(@el).removeClass 'deleting'
    $(@el).removeClass 'error'

  cancelDeleteOnKeydown: (event) =>
    if (not event.which? or event.which == 27) and @isDeleting()
      $(@el).removeClass 'deleting'
      $(@el).removeClass 'error'

  save: (event) =>
    if event.which == 13 and @isEditing()
      event.preventDefault()
      value = $.trim $(@el).find('td.name input[type=text]').val()

      if value == @model.get('name')
        @toggleEditInPlace()
      else
        @model.save { name: value },
          success: =>
            $(@el).find('td.name p').html(value)
            @toggleEditInPlace()
          error: (model, error) =>
            if @isEditing()
              $(@el).addClass 'error'

              if _.isString error
                $(@el).find('div.error-message').html(error)
              else
                $(@el).find('div.error-message').html('An unknown error has occurred. Please try again.')

  cancel: (event) =>
    if (not event.which? or event.which == 27) and @isEditing()
      @toggleEditInPlace()

  toggleEditInPlace: =>
    $(@el).toggleClass 'editing'
    $(@el).removeClass 'error'

    if $(@el).is('.editing')
      p = $(@el).find('td.name p')
      input = $(@el).find('td.name input[type=text]')

      input.val $.trim(p.text())
      input.focus().select()

  isEditing: =>
    $(@el).is('.editing')

  isDeleting: =>
    $(@el).is('.deleting')
