class App.Collections.RideCollection extends Backbone.Collection
  model: App.Models.Ride

  initialize: (options) ->
    @page = options.page
    @from = options.from
    @to = options.to

  url: =>
    baseUrl = App.hrefs.rides

    if @page?
      baseUrl = "#{baseUrl}/page/#{@page}"
    else if @from? and @to?
      from = Math.floor(@from.clearTime().getTime() / 1000)
      to = Math.floor(@to.clearTime().getTime() / 1000)
      baseUrl = "#{baseUrl}?from=#{from}&to=#{to}"

    baseUrl

  getByDate: (date) =>
    @select (ride) ->
      rideDate = new Date(ride.get('start_time') * 1000)
      rideDate.getFullYear() == date.getFullYear() and rideDate.getMonth() == date.getMonth() and rideDate.getDate() == date.getDate()

  parse: (response) =>
    @pager = new App.Models.Pager(@, _.extend(response, url: '/rides'))
    response.items

  comparator: (ride) ->
    ride.get('start_time') * -1
