class App.Views.SegmentDetailView extends Backbone.View
  tagName: 'div'

  className: 'segment-detail-view'

  events:
    'click a[rel=back]': 'back'
    'click a[rel=edit]': 'edit'
    'keypress input': 'save'
    'blur input': 'cancel'

  # TODO display charts

  initialize: ->
    $(document).bind 'keydown', @cancel

  render: =>
    $(@el).html JST['segment_detail_view'](@model.toJSON())
    @

  back: (event) =>
    event.preventDefault()
    window.location.hash = ''

  edit: (event) =>
    event.preventDefault()
    @toggleEditInPlace()

  save: (event) =>
    if event.which == 13 and @isEditing()
      event.preventDefault()
      value = $.trim $(@el).find('h1 input').val()

      if value == @model.get('name')
        @toggleEditInPlace()
      else
        # TODO handle errors
        @model.save { name: value },
          success: =>
            $(@el).find('h1 p').html(value)
            @toggleEditInPlace()

  cancel: (event) =>
    if (not event.which? or event.which == 27) and @isEditing()
      @toggleEditInPlace()

  toggleEditInPlace: =>
    $(@el).toggleClass 'editing'

    if $(@el).is('.editing')
      p = $(@el).find('h1 p')
      input = $(@el).find('h1 input')

      input.val $.trim(p.text())
      input.focus().select()

  isEditing: =>
    $(@el).is('.editing')
