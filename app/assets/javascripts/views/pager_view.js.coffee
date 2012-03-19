class App.Views.PagerView extends Backbone.View
  className: 'pagination'

  events:
    'click a': 'followLink'

  render: =>
    $(@el).html JST['templates/pager'](@model) if @model.totalPages > 1
    @

  followLink: (event) ->
    App.Helpers.followLink event
