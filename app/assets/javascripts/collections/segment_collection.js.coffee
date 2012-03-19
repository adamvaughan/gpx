class App.Collections.SegmentCollection extends Backbone.Collection
  model: App.Models.Segment

  initialize: (options) ->
    @page = options.page

  url: =>
    baseUrl = App.hrefs.segments
    baseUrl = "#{baseUrl}/page/#{@page}" if @page?
    baseUrl

  parse: (response) =>
    @pager = new App.Models.Pager(@, _.extend(response, url: '/rides'))
    response.items

  comparator: (segment) ->
    segment.get('start_time') * -1
