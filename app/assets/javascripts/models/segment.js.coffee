class App.Models.Segment extends Backbone.Model
  url: =>
    @get 'href'

  validate: (attributes) =>
    if _.isString(attributes.name) and attributes.name.length == 0
      return "Please enter a name."
