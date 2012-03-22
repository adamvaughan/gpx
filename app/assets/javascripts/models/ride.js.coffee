class App.Models.Ride extends Backbone.Model
  url: =>
    if @get('href')?
      @get 'href'
    else
      "#{App.hrefs.rides}/#{@id}"
