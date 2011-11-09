class App.Models.Segment extends Backbone.Model
  url: =>
    @get 'href'

  # TODO add validation

  compare: =>
    @get 'epoch_created_at'
