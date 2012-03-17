class App.Collections.SegmentCollection extends Backbone.Collection
  model: App.Models.Segment

  url: =>
    App.hrefs.segments

  comparator: (segment) ->
    segment.get('start_time') * -1
