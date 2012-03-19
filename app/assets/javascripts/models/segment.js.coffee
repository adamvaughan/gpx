class App.Models.Segment extends Backbone.Model
  url: =>
    if @get('href')?
      @get 'href'
    else
      "#{App.hrefs.segments}/#{@id}"
