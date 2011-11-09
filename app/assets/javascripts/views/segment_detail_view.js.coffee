class App.Views.SegmentDetailView extends Backbone.View
  events:
    'click a[rel=back]' : 'back'
    'click a[rel=edit]' : 'edit'

  # TODO display charts

  render: =>
    $(@el).html JST['segment_detail_view'](@model.toJSON())
    @

  back: (event) =>
    event.preventDefault()
    window.location.hash = ''

  edit: (event) =>
    event.preventDefault()
    # TODO add in place editing for the name
