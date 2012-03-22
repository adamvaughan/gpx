class App.Collections.RideCollection extends Backbone.Collection
  model: App.Models.Ride

  initialize: (options) ->
    @page = options.page

  url: =>
    baseUrl = App.hrefs.rides
    baseUrl = "#{baseUrl}/page/#{@page}" if @page?
    baseUrl

  parse: (response) =>
    @pager = new App.Models.Pager(@, _.extend(response, url: '/rides'))
    response.items

  comparator: (ride) ->
    ride.get('start_time') * -1
